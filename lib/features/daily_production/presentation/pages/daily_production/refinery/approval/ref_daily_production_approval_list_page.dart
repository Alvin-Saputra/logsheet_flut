import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/features/daily_production/data/model/daily_production/daily_production_refinery_entity.dart';
import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
// Pastikan import Detail Page untuk Approval sudah benar
import 'package:logsheet_app/features/daily_production/presentation/pages/daily_production/refinery/approval/ref_daily_production_approval_detail_page.dart';
import 'package:logsheet_app/features/daily_production/presentation/provider/daily_production/daily_production_refinery_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/plant_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:provider/provider.dart';

class DailyProductionRefineryApprovalListPage extends StatefulWidget {
  const DailyProductionRefineryApprovalListPage({super.key});

  @override
  State<DailyProductionRefineryApprovalListPage> createState() =>
      _DailyProductionRefineryApprovalListPageState();
}

class _DailyProductionRefineryApprovalListPageState
    extends State<DailyProductionRefineryApprovalListPage> {
  DataFormNoEntity? formRefinery;
  final TextEditingController _remarkController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchData();
    });
  }

  void _fetchData() {
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";

    // Fetch Data
    context.read<DailyProductionRefineryProvider>().fetchReportsForManager(
      plantCode,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Refinery Approval List"),
        actions: [
          IconButton(onPressed: _fetchData, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    // 1. Tentukan Role User
    final currentUser = context.watch<UserProvider>().currentUser;
    final String userRole = currentUser?.role ?? "";

    final bool isManager =
        userRole.contains("MGR_PROD") || userRole.contains("MGR");

    return Consumer<DailyProductionRefineryProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        List<DailyProductionRefineryEntity> rawList =
            provider.reportsForManager;

        if (rawList.isEmpty) {
          return const Center(child: Text("No data needing approval"));
        }

        // ============================================================
        // GROUPING LOGIC
        // ============================================================
        Map<String, List<DailyProductionRefineryEntity>> ticketMap = {};

        for (var item in rawList) {
          if (!ticketMap.containsKey(item.id)) {
            ticketMap[item.id] = [];
          }
          ticketMap[item.id]!.add(item);
        }

        var allTickets = ticketMap.values.toList();

        // Sort by Date Descending
        allTickets.sort((a, b) {
          DateTime dateA = a.first.transactionDate ?? DateTime(2000);
          DateTime dateB = b.first.transactionDate ?? DateTime(2000);
          return dateB.compareTo(dateA);
        });

        return ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: allTickets.length,
          itemBuilder: (context, index) {
            List<DailyProductionRefineryEntity> thisTicketRows =
                allTickets[index];
            final headerData = thisTicketRows.first;

            // Grouping per Shift
            Map<String, List<DailyProductionRefineryEntity>> shiftMap = {};
            for (var item in thisTicketRows) {
              String shiftKey = item.shift ?? "Unknown";
              if (!shiftMap.containsKey(shiftKey)) {
                shiftMap[shiftKey] = [];
              }
              shiftMap[shiftKey]!.add(item);
            }
            var sortedShiftKeys = shiftMap.keys.toList()..sort();

            String titleDate =
                headerData.transactionDate != null
                    ? DateFormat(
                      'dd MMM yyyy',
                    ).format(headerData.transactionDate!)
                    : "-";
            String titleWC = headerData.workCenter ?? "-";

            // Status Global Tiket (untuk warna icon)
            bool hasRejection = thisTicketRows.any(
              (e) =>
                  e.preparedStatus == "Rejected" ||
                  e.checkedStatus == "Rejected",
            );

            bool isAllCheckedNull = thisTicketRows.every(
              (e) => e.checkedStatus == null,
            );

            bool isAllPreparedApproved = thisTicketRows.every(
              (e) => e.preparedStatus == "Approved",
            );

            return Card(
              elevation: 2,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side:
                    hasRejection
                        ? const BorderSide(color: Colors.red, width: 1)
                        : BorderSide.none,
              ),
              child: ExpansionTile(
                leading: Icon(Icons.verified_user, color: Colors.blueGrey),
                title: Text(
                  "${headerData.id}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("$titleDate • WC: $titleWC"),
                childrenPadding: const EdgeInsets.all(8),
                children: [
                  ...sortedShiftKeys.map((shiftKey) {
                    List<DailyProductionRefineryEntity> itemsInThisShift =
                        shiftMap[shiftKey]!;
                    var repItem = itemsInThisShift.first;

                    // Status Helper Booleans
                    bool isPrepared = repItem.preparedStatus == "Approved";
                    bool isChecked = repItem.checkedStatus == "Approved";
                    bool isLeadPending = repItem.preparedStatus == null;

                    String approvalText = _getApprovalStatusText(repItem);
                    Color approvalColor = _getApprovalStatusColor(repItem);

                    return ListTile(
                      leading: const Icon(
                        Icons.access_time,
                        color: Colors.blueGrey,
                      ),
                      title: Padding(
                        padding: const EdgeInsets.only(bottom: 6.0),
                        child: Text(
                          'Shift $shiftKey',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                      subtitle: Wrap(
                        spacing: 8.0,
                        runSpacing: 4.0,
                        children: [
                          _buildStatusBadge(
                            approvalText,
                            approvalColor,
                            icon:
                                approvalText.contains("Approved")
                                    ? Icons.check_circle
                                    : (approvalText.contains("Rejected")
                                        ? Icons.cancel
                                        : Icons.pending),
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.more_horiz, size: 16),
                      onTap: () {
                        if (isManager) {
                          if (isLeadPending) {
                            _showSnackBar(
                              "Gagal: Shift ini belum di-approve oleh Lead.",
                            );
                            return;
                          }

                          if (repItem.preparedStatus == "Rejected") {
                            _showSnackBar(
                              "Gagal: Shift ini statusnya REJECTED oleh Lead.",
                            );
                            return;
                          }

                          if (isPrepared && !isChecked) {
                            _navigateToDetail(context, itemsInThisShift);
                          } else if (isChecked) {
                            _showSnackBar(
                              "Shift ini sudah Anda approve (Checked).",
                            );
                            _navigateToDetail(context, itemsInThisShift);
                          }
                        } else {
                          _navigateToDetail(context, itemsInThisShift);
                        }
                      },
                    );
                  }).toList(),

                  if (isAllPreparedApproved && isAllCheckedNull)
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                _showApprovedRejectedBottomSheet(
                                  context: context,
                                  isApproved: false,
                                  headerData: headerData,
                                  user: currentUser,
                                );
                              },
                              child: const Text('Reject All'),
                            ),
                          ),
                        ),

                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ElevatedButton(
                              onPressed: () {
                                _showApprovedRejectedBottomSheet(
                                  context: context,
                                  isApproved: true,
                                  headerData: headerData,
                                  user: currentUser,
                                );
                              },
                              child: const Text('Approve All'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green[700],
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToDetail(
    BuildContext context,
    List<DailyProductionRefineryEntity> items,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => DailyProductionRefineryApprovalDetailPage(
              reportEntities: items,
              reportIdentifier:
                  "${items.first.id} - Shift ${items.first.shift}",
            ),
      ),
    ).then((value) {
      if (value == true) {
        _fetchData();
      }
    });
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.redAccent, // Beri warna merah untuk error
      ),
    );
  }

  String _getApprovalStatusText(DailyProductionRefineryEntity item) {
    if (item.checkedStatus == "Approved") return "Approved (Manager Prod))";
    if (item.checkedStatus == "Rejected") return "Rejected (Manager Prod)";
    if (item.preparedStatus == "Approved") return "Waiting Check (Lead Prod)";
    if (item.preparedStatus == "Rejected") return "Rejected (Lead Prod)";
    // Jika null
    return "Waiting Approval (Lead)";
  }

  Color _getApprovalStatusColor(DailyProductionRefineryEntity item) {
    if (item.checkedStatus == "Approved") return Colors.green;
    if (item.checkedStatus == "Rejected" || item.preparedStatus == "Rejected") {
      return Colors.red;
    }
    if (item.preparedStatus == "Approved") {
      return Colors.orange;
    }

    return Colors.blue;
  }

  Widget _buildStatusBadge(String text, Color color, {IconData? icon}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 14, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showApprovedRejectedBottomSheet({
    required BuildContext context,
    required bool isApproved,
    required DailyProductionRefineryEntity headerData,
    required dynamic
    user, // Menggunakan tipe dari UserProvider Anda (UserEntity)
  }) {
    // Karena approve all, kita bisa set default tiket completed atau sesuaikan dengan bisnis logic
    bool isTicketCompleted = true;

    // Reset remarks setiap kali bottom sheet dibuka
    _remarkController.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  isApproved ? "Approve All Shifts" : "Reject All Shifts",
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  "Are you sure you want to ${isApproved ? "approve" : "reject"} ALL shifts for Ticket ID: ${headerData.id}?",
                  style: const TextStyle(fontSize: 14),
                ),
                const SizedBox(height: 16),
                if (!isApproved)
                  TextFormField(
                    controller: _remarkController,
                    decoration: const InputDecoration(
                      labelText: "Remarks",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 5,
                  ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.only(right: 8),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Cancel"),
                        ),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          final result = await context
                              .read<DailyProductionRefineryProvider>()
                              .sendApproveRejectReport(
                                user.username ?? "",
                                isApproved ? "Approved" : "Rejected",
                                user.role ?? "",
                                "", // shift kosong
                                isApproved ? null : _remarkController.text,
                                headerData.id ??
                                    "", // PINDAH KE SINI (Parameter ke-6)
                                headerData.plant ??
                                    "", // PINDAH KE SINI (Parameter ke-7)
                                changeUncompletedTicket: !isTicketCompleted,
                                approveAllShift: true,
                              );

                          if (!context.mounted) return;

                          if (result) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isApproved
                                      ? "Semua shift berhasil diapprove"
                                      : "Semua shift berhasil direject",
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.of(
                              context,
                            ).pop(); // Tutup bottom sheet saja
                            _fetchData(); // Refresh list data di background
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  isApproved
                                      ? "Gagal melakukan approve"
                                      : "Gagal melakukan reject",
                                ),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              isApproved ? Colors.green[700] : Colors.red[700],
                          foregroundColor: Colors.white,
                        ),
                        child: Text(
                          isApproved ? 'Submit Approval' : 'Submit Rejection',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
