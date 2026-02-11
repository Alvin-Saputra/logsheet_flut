import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/display.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/daily_production/data/model/daily_production/daily_production_refinery_entity.dart';
import 'package:logsheet_app/features/daily_production/presentation/pages/daily_production/refinery/ref_daily_production_input_page.dart';
import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/daily_production/presentation/pages/daily_production/refinery/ref_daily_production_detail_page.dart';
import 'package:logsheet_app/features/daily_production/presentation/provider/daily_production/daily_production_refinery_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/data_form_no_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/plant_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:provider/provider.dart';

class DailyProductionRefineryReportListPage extends StatefulWidget {
  const DailyProductionRefineryReportListPage({
    super.key,
    required this.userName,
    required this.role,
    required this.dataForm,
  });

  final String userName;
  final String role;
  final DataFormNoEntity dataForm;

  @override
  State<DailyProductionRefineryReportListPage> createState() =>
      _DailyProductionRefineryReportListsPageState();
}

class _DailyProductionRefineryReportListsPageState
    extends State<DailyProductionRefineryReportListPage> {
  final TextEditingController _dateController = TextEditingController();
  DateTime? _selectedDate = DateTime.now();
  String? _tempSelectedShift = "All";
  final List<String> shifts = ["1", "2", "3", "4", "5"];

  DataFormNoEntity? formData;

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now();
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";

    WidgetsBinding.instance.addPostFrameCallback(
      (timeStamp) async => await context
          .read<DailyProductionRefineryProvider>()
          .fetchFilteredTickets(_selectedDate, plantCode),
    );
  }

  @override
  void dispose() {
    _dateController.dispose();
    super.dispose();
  }

  void _resetFormAndRefresh() {
    setState(() {
      _dateController.clear();
      _selectedDate = DateTime.now();
      _tempSelectedShift = null;
      // _fetchReports();
    });
  }

  void _showSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.black87,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
        // _fetchReports();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    formData =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where((form) => form.isMenu == "Daily_Production_Refinery")
            .first;
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      centerTitle: true,
      iconTheme: const IconThemeData(color: Color(0xFF655F5B)),
      title: Text(
        'Daily Refinery List (${formData!.code})',
        style: TextStyle(
          color: Color(0xFF655F5B),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: _resetFormAndRefresh,
        ),
      ],
    );
  }

  Widget _buildBody() {
    // 1. Struktur utama dimulai dengan Column (tanpa Consumer pembungkus utama)
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          // FILTER SECTION:
          // Ditempatkan di sini agar TIDAK ikut hilang saat state berubah/loading
          _buildFilterSection(context),

          // 2. Gunakan Expanded agar List mengisi sisa ruang
          Expanded(
            // 3. Consumer dipindah ke sini (hanya membungkus List)
            child: Consumer3<
              DailyProductionRefineryProvider,
              PlantProvider,
              UserProvider
            >(
              builder: (
                context,
                dailyProdRefProvider,
                plantprovider,
                userProvider,
                child,
              ) {
                // --- LOGIC PEMROSESAN DATA ---
                List<DailyProductionRefineryEntity> rawList =
                    dailyProdRefProvider.filteredTickets;

                Map<String, List<DailyProductionRefineryEntity>> ticketMap = {};

                for (var item in rawList) {
                  if (!ticketMap.containsKey(item.id)) {
                    ticketMap[item.id] = [];
                  }
                  ticketMap[item.id]!.add(item);
                }

                var allTickets = ticketMap.values.toList();

                // --- HANDLING STATE (Loading / Empty) ---
                if (dailyProdRefProvider.isLoadingFilterReport) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (allTickets.isEmpty) {
                  return const Center(child: Text("No Data"));
                }

                // --- LIST VIEW ---
                return ListView.builder(
                  // Padding dipindah ke sini agar rapi di dalam Expanded
                  padding: const EdgeInsets.only(top: 16, bottom: 88),
                  itemCount: allTickets.length,
                  itemBuilder: (context, index) {
                    // Logic per Item (Card)
                    List<DailyProductionRefineryEntity> thisTicketRows =
                        allTickets[index];

                    Map<String, List<DailyProductionRefineryEntity>> shiftMap =
                        {};

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
                        children: [
                          ...sortedShiftKeys.map((shiftKey) {
                            List<DailyProductionRefineryEntity>
                            itemsInThisShift = shiftMap[shiftKey]!;

                            var representativeItem = itemsInThisShift.first;

                            return ListTile(
                              leading: const Icon(
                                Icons.domain_verification_sharp,
                              ),
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
                              if (sortedShiftKeys.isNotEmpty) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            DailyProductionRefineryInputPage(
                                              dataForm: widget.dataForm,
                                              entity:
                                                  shiftMap[sortedShiftKeys
                                                          .last]!
                                                      .first,
                                              userName:
                                                  userProvider
                                                      .currentUser
                                                      ?.username ??
                                                  '',
                                              isFromAddNewShift: true,
                                            ),
                                  ),
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: _dateController,
            readOnly: true,
            decoration: InputDecoration(
              hintText: 'Pilih tanggal',
              filled: true,
              fillColor: const Color(0xFFF0ECE9),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.calendar_today),
            ),
            onTap: () => _pickDate(context),
          ),
        ),
        // const SizedBox(width: 10),
        // Expanded(
        //   child: DropdownButtonFormField<String?>(
        //     isExpanded: true,
        //     value: _tempSelectedShift,
        //     decoration: InputDecoration(
        //       filled: true,
        //       fillColor: const Color(0xFFF0ECE9),
        //       hintText: "Pilih Shift",
        //       contentPadding: const EdgeInsets.symmetric(
        //         horizontal: 16,
        //         vertical: 14,
        //       ),
        //       border: OutlineInputBorder(
        //         borderRadius: BorderRadius.circular(12),
        //         borderSide: BorderSide.none,
        //       ),
        //       prefixIcon: const Icon(Icons.access_time),
        //     ),
        //     items: [
        //       const DropdownMenuItem<String?>(
        //         value: "All",
        //         child: Text('Semua'),
        //       ),
        //       ...shifts.map(
        //         (shift) => DropdownMenuItem<String?>(
        //           value: shift,
        //           child: Text(" $shift"),
        //         ),
        //       ),
        //     ],
        //     onChanged: (value) {
        //       setState(() {
        //         _tempSelectedShift = value;
        //       });
        //     },
        //   ),
        // ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () async {
            final plantCode =
                context.read<PlantProvider>().currentPlant?.code ?? "";

            await context
                .read<DailyProductionRefineryProvider>()
                .fetchFilteredTickets(
                  formatStringtoDate(_dateController.text, "yyyy-MM-dd"),
                  plantCode,
                );
          },
          icon: const Icon(Icons.search),
          label: const Text('Cari'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFAB2F2B),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
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
