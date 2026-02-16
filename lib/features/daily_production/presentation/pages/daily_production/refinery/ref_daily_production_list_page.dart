import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/features/daily_production/data/model/daily_production/daily_production_refinery_entity.dart';
import 'package:logsheet_app/features/daily_production/presentation/pages/daily_production/refinery/ref_daily_production_edit_page.dart';
import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/daily_production/presentation/pages/daily_production/refinery/ref_daily_production_detail_page.dart';
import 'package:logsheet_app/features/daily_production/presentation/pages/daily_production/refinery/ref_daily_production_input_page.dart';
import 'package:logsheet_app/features/daily_production/presentation/provider/daily_production/daily_production_refinery_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/plant_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/value_provider.dart';
import 'package:provider/provider.dart';

class DailyProductionRefineryListPage extends StatefulWidget {
  const DailyProductionRefineryListPage({super.key, required this.dataForm});
  final DataFormNoEntity dataForm;

  @override
  State<DailyProductionRefineryListPage> createState() =>
      _DailyProductionRefineryListPageState();
}

class _DailyProductionRefineryListPageState
    extends State<DailyProductionRefineryListPage> {
  @override
  void initState() {
    super.initState();
    final username = context.read<UserProvider>().currentUser?.username;
    final role = context.read<UserProvider>().currentUser?.role;
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<DailyProductionRefineryProvider>().fetchAllTickets(
        null,
        null,
        username ?? "",
        role ?? "",
        plantCode,
      );
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
                        (context) => DailyProductionRefineryInputPage(
                          dataForm: widget.dataForm,
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
      DailyProductionRefineryProvider,
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
        List<DailyProductionRefineryEntity> rawList =
            dailyProdFracProvider.reportsList
                .where(
                  (e) => e.preparedStatus == null && e.checkedStatus == null,
                )
                .toList();

        Map<String, List<DailyProductionRefineryEntity>> ticketMap = {};

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
              List<DailyProductionRefineryEntity> thisTicketRows =
                  allTickets[index];

              Map<String, List<DailyProductionRefineryEntity>> shiftMap = {};

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

                  title: Text(
                    "${headerData.id}",
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text("$titleDate • WC: $titleWC"),
                  childrenPadding: const EdgeInsets.all(8),
                  trailing: Text(
                    (ticketClosedStatus == true) ? "Close" : "Open",
                    style: TextStyle(
                      color: (ticketClosedStatus == true) ? Colors.red : Colors.green,
                    ),
                  ),

                  children: [
                    ...sortedShiftKeys.map((shiftKey) {
                      List<DailyProductionRefineryEntity> itemsInThisShift =
                          shiftMap[shiftKey]!;

                      var representativeItem = itemsInThisShift.first;

                      return ListTile(
                        leading: const Icon(Icons.domain_verification_sharp),
                        trailing: const Icon(
                          Icons.keyboard_double_arrow_right_outlined,
                        ),
                        title: Text('Shift $shiftKey'),
                        subtitle: Text(
                          (representativeItem.isCompleted == true)
                              ? "Close"
                              : "Open",
                          style: TextStyle(
                            color:
                                (representativeItem.isCompleted == true)
                                    ? Colors.red
                                    : Colors.green,
                          ),
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      DailyProductionRefineryDetailPage(
                                        dataForm: widget.dataForm,
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
                                (context) => DailyProductionRefineryInputPage(
                                  dataForm: widget.dataForm,
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

  // Helper widget untuk membuat kartu detail (per Shift)

  AppBar _buildAppBar() {
    return AppBar(
      title: Text("Refinery List (${widget.dataForm.code})"),
      actions: [
        context.watch<DailyProductionRefineryProvider>().isLoading
            ? CircularProgressIndicator()
            : IconButton(
              onPressed: () async {
                final username =
                    context.read<UserProvider>().currentUser?.username;
                final role = context.read<UserProvider>().currentUser?.role;
                final plantCode =
                    context.read<PlantProvider>().currentPlant?.code ?? "";
                await context
                    .read<DailyProductionRefineryProvider>()
                    .fetchAllTickets(
                      null,
                      null,
                      username ?? "",
                      role ?? "",
                      plantCode,
                    );
              },
              icon: Consumer<DailyProductionRefineryProvider>(
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

  String _getStatusText(DailyProductionRefineryEntity report) {
    if (report.checkedStatus == "Approved") {
      return "Approved";
    }

    if (report.checkedStatus == "Rejected") {
      return "Rejected";
    }
    if (report.preparedStatus == "Approved") {
      return "Prepared ${report.shift}";
    }

    if (report.preparedStatus == "Rejected") {
      return "Rejected";
    }
    return "Submitted";
  }

  String _getIsCompletedStatus(DailyProductionRefineryEntity report) {
    if (report.isCompleted == true) {
      return "Close";
    } else {
      return "Open";
    }
  }

  Color _getStatusColor(DailyProductionRefineryEntity report) {
    if (report.checkedStatus == "Approved") {
      return Colors.green;
    }

    if (report.checkedStatus == "Rejected") {
      return Colors.red;
    }

    if (report.preparedStatus == "Approved") {
      return Colors.orangeAccent;
    }

    if (report.preparedStatus == "Rejected") {
      return Colors.red;
    }
    return Colors.grey;
  }
}
