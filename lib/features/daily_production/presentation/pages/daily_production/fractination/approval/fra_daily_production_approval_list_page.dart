import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/features/daily_production/data/model/daily_production/daily_production_fractionation_entity.dart';
import 'package:logsheet_app/features/daily_production/data/model/daily_production/daily_production_refinery_entity.dart';
import 'package:logsheet_app/features/daily_production/presentation/pages/daily_production/fractination/approval/fra_daily_production_approval_detail_page.dart';
import 'package:logsheet_app/features/daily_production/presentation/provider/daily_production/daily_production_fractionation_provider.dart';
import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
// Pastikan import Detail Page untuk Approval sudah benar
import 'package:logsheet_app/features/daily_production/presentation/pages/daily_production/refinery/approval/ref_daily_production_approval_detail_page.dart';
import 'package:logsheet_app/features/daily_production/presentation/provider/daily_production/daily_production_refinery_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/plant_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:provider/provider.dart';

class DailyProductionFractinationApprovalListPage extends StatefulWidget {
  const DailyProductionFractinationApprovalListPage({super.key});

  @override
  State<DailyProductionFractinationApprovalListPage> createState() =>
      _DailyProductionFractinationApprovalListPageState();
}

class _DailyProductionFractinationApprovalListPageState
    extends State<DailyProductionFractinationApprovalListPage> {
  DataFormNoEntity? formRefinery;

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
    context.read<DailyProductionFractionationProvider>().fetchReportsForManager(
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

    return Consumer<DailyProductionFractionationProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        List<DailyProductionFractionationEntity> rawList =
            provider.reportsForManager;

        if (rawList.isEmpty) {
          return const Center(child: Text("No data needing approval"));
        }

        // ============================================================
        // GROUPING LOGIC
        // ============================================================
        Map<String, List<DailyProductionFractionationEntity>> ticketMap = {};

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
            List<DailyProductionFractionationEntity> thisTicketRows =
                allTickets[index];
            final headerData = thisTicketRows.first;

            // Grouping per Shift
            Map<String, List<DailyProductionFractionationEntity>> shiftMap = {};
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
                leading: Icon(
                  Icons.verified_user,
                  color: _getApprovalStatusColor(thisTicketRows.first),
                ),
                title: Text(
                  "${headerData.id}",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text("$titleDate • WC: $titleWC"),
                childrenPadding: const EdgeInsets.all(8),
                children:
                    sortedShiftKeys.map((shiftKey) {
                      List<DailyProductionFractionationEntity>
                      itemsInThisShift = shiftMap[shiftKey]!;
                      var repItem = itemsInThisShift.first;

                      // Status Helper Booleans
                      bool isPrepared = repItem.preparedStatus == "Approved";
                      bool isChecked = repItem.checkedStatus == "Approved";
                      bool isRejected =
                          repItem.preparedStatus == "Rejected" ||
                          repItem.checkedStatus == "Rejected";

                      // Cek apakah Lead belum melakukan apa-apa (Null)
                      bool isLeadPending = repItem.preparedStatus == null;

                      return ListTile(
                        leading: const Icon(Icons.access_time),
                        title: Text('Shift $shiftKey'),
                        subtitle: Text(
                          _getApprovalStatusText(repItem),
                          style: TextStyle(
                            color: _getApprovalStatusColor(repItem),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
              ),
            );
          },
        );
      },
    );
  }

  void _navigateToDetail(
    BuildContext context,
    List<DailyProductionFractionationEntity> items,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder:
            (context) => DailyProductionFractionationApprovalDetailPage(
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

  String _getApprovalStatusText(DailyProductionFractionationEntity item) {
    if (item.checkedStatus == "Approved") return "Approved (Manager Prod))";
    if (item.checkedStatus == "Rejected") return "Rejected (Manager Prod)";
    if (item.preparedStatus == "Approved") return "Waiting Check (Lead Prod)";
    if (item.preparedStatus == "Rejected") return "Rejected (Lead Prod)";
    // Jika null
    return "Waiting Approval (Lead)";
  }

  Color _getApprovalStatusColor(DailyProductionFractionationEntity item) {
    if (item.checkedStatus == "Approved") return Colors.green;
    if (item.checkedStatus == "Rejected" || item.preparedStatus == "Rejected") {
      return Colors.red;
    }
    if (item.preparedStatus == "Approved") return Colors.orange;
    return Colors.blue;
  }
}
