import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/features/daily_production/data/model/daily_production/daily_production_fractionation_entity.dart';
import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/daily_production/presentation/pages/daily_production/fractination/fra_daily_production_detail_page.dart';
import 'package:logsheet_app/features/daily_production/presentation/pages/daily_production/fractination/fra_daily_production_input_page.dart';
import 'package:logsheet_app/features/daily_production/presentation/provider/daily_production/daily_production_fractionation_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/plant_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/value_provider.dart';
import 'package:provider/provider.dart';

class DailyProductionFractionationListPage extends StatefulWidget {
  const DailyProductionFractionationListPage({
    super.key,
    required this.formData,
  });
  final DataFormNoEntity formData;

  @override
  State<DailyProductionFractionationListPage> createState() =>
      _DailyProductionFractionationListPageState();
}

class _DailyProductionFractionationListPageState
    extends State<DailyProductionFractionationListPage> {
  @override
  void initState() {
    super.initState();
    final username = context.read<UserProvider>().currentUser?.username;
    final role = context.read<UserProvider>().currentUser?.role;
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context
          .read<DailyProductionFractionationProvider>()
          .fetchAllTickets(null, null, username ?? "", role ?? "", plantCode);
      if (!mounted) return;
      await context.read<ValueProvider>().fetchAllInitialData();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: Consumer<UserProvider>(
        builder:
            (context, provider, child) => FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => DailyProductionFractinationInputPage(
                          dataForm: widget.formData,
                          userName: provider.currentUser?.username ?? "",
                          isFromAddNewShift: false,
                        ),
                  ),
                );
              },
              label: const Text("Tambah Ticket"),
              icon: Icon(Icons.add),
              backgroundColor: Color(0xFFB91C1C),
              foregroundColor: Colors.white,
            ),
      ),
    );
  }

  String _displayTime(TimeOfDay? time) {
    if (time == null) return "-";
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }

  Widget _buildBody() {
    return Consumer3<
      DailyProductionFractionationProvider,
      PlantProvider,
      UserProvider
    >(
      builder: (
        context,
        dailyProdFracProvider,
        plantprovider,
        userProvider,
        child,
      ) {
        // 1. Filter raw list
        List<DailyProductionFractionationEntity> rawList =
            dailyProdFracProvider.reportsList;
        // .where(
        //   (e) => e.preparedStatus == null && e.checkedStatus == null,
        // )
        // .toList();

        Map<String, List<DailyProductionFractionationEntity>> ticketMap = {};

        for (var item in rawList) {
          // Kita jadikan 'id' sebagai key utama
          if (!ticketMap.containsKey(item.id)) {
            ticketMap[item.id] = [];
          }
          ticketMap[item.id]!.add(item);
        }

        var allTickets = ticketMap.values.toList();

        if (dailyProdFracProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (allTickets.isEmpty) {
          return const Center(
            child: Text("No Data"),
          ); // Ganti dengan widget empty state Anda
        }

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 88),
            itemCount: allTickets.length,
            itemBuilder: (context, index) {
              // Ini adalah SATU TIKET (List of Rows dengan ID yang sama)
              List<DailyProductionFractionationEntity> thisTicketRows =
                  allTickets[index];

              Map<String, List<DailyProductionFractionationEntity>> shiftMap =
                  {};

              final ticketClosedStatus = thisTicketRows.every(
                (item) => item.isCompleted == true,
              );

              for (var item in thisTicketRows) {
                String shiftKey = item.shift ?? "Unknown";
                if (!shiftMap.containsKey(shiftKey)) {
                  shiftMap[shiftKey] = [];
                }
                shiftMap[shiftKey]!.add(item);
              }

              var sortedShiftKeys = shiftMap.keys.toList()..sort();

              final headerData = thisTicketRows.first;
              String titleDate = DateFormat(
                'dd MMM yyyy',
              ).format(headerData.transactionDate!);
              String titleWC = headerData.workCenter ?? "-";

              return Card(
                elevation: 2,
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ExpansionTile(
                  leading: const Icon(
                    Icons.description,
                    color: Colors.blueGrey,
                  ),
                  trailing: _buildStatusBadge(
                    (ticketClosedStatus == true) ? "Close" : "Open",
                    (ticketClosedStatus == true) ? Colors.red : Colors.green,
                    icon:
                        (ticketClosedStatus == true)
                            ? Icons.lock
                            : Icons.lock_open,
                  ),

                  title: Text(
                    "${headerData.id}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("$titleDate • WC: $titleWC"),
                  childrenPadding: const EdgeInsets.all(8),

                  children: [
                    ...sortedShiftKeys.map((shiftKey) {
                      List<DailyProductionFractionationEntity>
                      itemsInThisShift = shiftMap[shiftKey]!;

                      var representativeItem = itemsInThisShift.first;
                      String approvalText = _getApprovalStatusText(
                        representativeItem,
                      );
                      Color approvalColor = _getApprovalStatusColor(
                        representativeItem,
                      );

                      return ListTile(
                        leading: const Icon(Icons.domain_verification_sharp),
                        trailing: const Icon(
                          Icons.keyboard_double_arrow_right_outlined,
                        ),
                        title: Text('Shift $shiftKey'),
                        subtitle: Wrap(
                          spacing: 8.0, // Jarak horizontal antar badge
                          runSpacing: 4.0, // Jarak vertikal jika turun baris
                          children: [
                            // Badge 1: Status Open/Close Shift
                            _buildStatusBadge(
                              (representativeItem.isCompleted == true)
                                  ? "Close"
                                  : "Open",
                              (representativeItem.isCompleted == true)
                                  ? Colors.red
                                  : Colors.green,
                            ),

                            // Badge 2: Status Approval
                            _buildStatusBadge(
                              approvalText,
                              approvalColor,
                              // Tambahkan icon opsional berdasarkan teks
                              icon:
                                  approvalText == "Approved"
                                      ? Icons.check_circle
                                      : (approvalText == "Rejected"
                                          ? Icons.cancel
                                          : Icons.pending),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      DailyProductionFractionationDetailPage(
                                        formData: widget.formData,
                                        listItem: itemsInThisShift,
                                      ),
                            ),
                          );
                        },
                      );
                    }),

                    const Divider(),

                    // ===== ADD NEW SHIFT DATA BUTTON =====
                    ListTile(
                      leading: const Icon(
                        Icons.add_circle_outline,
                        color: Colors.redAccent,
                      ),
                      title: const Text(
                        "Add New Shift Data",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          color: Colors.red,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (
                                  context,
                                ) => DailyProductionFractinationInputPage(
                                  dataForm: widget.formData,
                                  entity: shiftMap[sortedShiftKeys.last]!.first,
                                  userName:
                                      userProvider.currentUser?.username ?? '',
                                  isFromAddNewShift: true,
                                ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Fractionation List (${widget.formData.code})"),
      actions: [
        context.watch<DailyProductionFractionationProvider>().isLoading
            ? CircularProgressIndicator()
            : IconButton(
              onPressed: () async {
                final username =
                    context.read<UserProvider>().currentUser?.username;
                final role = context.read<UserProvider>().currentUser?.role;
                final plantCode =
                    context.read<PlantProvider>().currentPlant?.code ?? "";
                await context
                    .read<DailyProductionFractionationProvider>()
                    .fetchAllTickets(
                      null,
                      null,
                      username ?? "",
                      role ?? "",
                      plantCode,
                    );
              },
              icon: Consumer<DailyProductionFractionationProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
                    return const CircularProgressIndicator();
                  }
                  return const Icon(Icons.replay);
                },
              ),
            ),
      ],
    );
  }

  String _getApprovalStatusText(DailyProductionFractionationEntity item) {
    if (item.checkedStatus == "Approved") return "Approved";
    if (item.checkedStatus == "Rejected") return "Rejected";
    if (item.preparedStatus == "Approved") return "Prepared";
    if (item.preparedStatus == "Rejected") return "Rejected";
    if (item.preparedStatus == null) return "Submitted";
    // Jika null
    return "Waiting Approval (Lead)";
  }

  Color _getApprovalStatusColor(DailyProductionFractionationEntity item) {
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
        color: color.withOpacity(0.1), // Latar belakang transparan
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
}
