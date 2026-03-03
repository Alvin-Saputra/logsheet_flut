import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/core/widgets/custom_remark_field.dart';
import 'package:logsheet_app/core/widgets/custom_save_button.dart';
import 'package:logsheet_app/core/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/quality_refinery/quality_report_qc_entity.dart';
import 'package:logsheet_app/features/quality_control/presentation/pages/qc/quality_detail_qc_page.dart';
import 'package:logsheet_app/features/quality_control/presentation/pages/qc/quality_input_qc_page.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/data_form_no_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/plant_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/product_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/value_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/quality_report/quality_report_qc_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:provider/provider.dart';

class QualityReportQCList extends StatefulWidget {
  const QualityReportQCList({super.key});

  @override
  State<QualityReportQCList> createState() => _QualityReportQCListState();
}

class _QualityReportQCListState extends State<QualityReportQCList> {
  DataFormNoEntity? formData;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  DateTime? _selectedDate;
  String? _tempSelectedShift = "All";
  final List<String> shifts = ["1", "2", "3", "4", "5"];

  @override
  void initState() {
    final username = context.read<UserProvider>().currentUser?.username;
    final role = context.read<UserProvider>().currentUser?.role;
    final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<QualityReportQCProvider>().fetchAllTickets(
        null,
        null,
        username ?? "",
        role ?? "",
        plantCode,
      );
      if (!mounted) return;
      await context.read<ValueProvider>().fetchAllInitialData();

      if (!mounted) return;
      await context.read<ProductProvider>().fetchProducts();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final username = context.read<UserProvider>().currentUser?.username;
    return Scaffold(
      appBar: _buildAppBar(),
      body: _buildBody(),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          log("Tombol tambah report diklik");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) =>
                      QualityReportInputQCPage(userName: username ?? "Unknown"),
            ),
          ).then((_) async {
            final plantCode =
                context.read<PlantProvider>().currentPlant?.code ?? "";
            await context.read<QualityReportQCProvider>().fetchFilteredTickets(
              _selectedDate,
              plantCode,
              _tempSelectedShift,
            );
          });
        },
        label: const Text("Tambah Quality Report"),
        icon: Icon(Icons.add),
        backgroundColor: Color(0xFFB91C1C),
        foregroundColor: Colors.white,
      ),
    );
  }

  AppBar _buildAppBar() {
    formData =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where((form) => form.isMenu == "Quality_Report")
            .first;
    return AppBar(
      title: Text("Quality List (${formData!.code})"),
      actions: [
        context.watch<QualityReportQCProvider>().isLoading
            ? CircularProgressIndicator()
            : IconButton(
              onPressed: () async {
                final username =
                    context.read<UserProvider>().currentUser?.username;
                final role = context.read<UserProvider>().currentUser?.role;
                final plantCode =
                    context.read<PlantProvider>().currentPlant?.code ?? "";
                await context.read<QualityReportQCProvider>().fetchAllTickets(
                  null,
                  null,
                  username ?? "",
                  role ?? "",
                  plantCode,
                );
              },
              icon: Consumer<QualityReportQCProvider>(
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

  Widget _buildBody() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          // child: _buildFilterSection(context),
        ),
        Expanded(
          child: Consumer3<
            QualityReportQCProvider,
            PlantProvider,
            UserProvider
          >(
            builder: (
              context,
              qualityProvider,
              plantprovider,
              userProvider,
              child,
            ) {
              // 1. Ambil data yang difilter
              List<QualityReportQcEntity> filteredList =
                  qualityProvider.reportsList;
              // .where(
              //   (e) =>
              //       e.preparedStatus == null && e.checkedStatus == null,
              // )
              // .toList();

              if (qualityProvider.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }

              if (qualityProvider.errorMessage != null) {
                return _buildErrorView(
                  qualityProvider,
                  plantprovider,
                ); // Refactored error view
              }

              if (filteredList.isEmpty) {
                return _buildEmptyView(
                  qualityProvider,
                  plantprovider,
                ); // Refactored empty view
              }

              // 2. LOGIKA GROUPING
              // Map key: "Plant|Date|WorkCenter|Shift"
              Map<String, List<QualityReportQcEntity>> groupedData = {};

              for (var report in filteredList) {
                if (report.transactionDate == null) continue;

                String dateStr = DateFormat(
                  'yyyy-MM-dd',
                ).format(report.transactionDate!);
                String plantStr = report.plant ?? "Unknown";
                String wcStr = report.workCenter ?? "Unknown";
                String shiftStr = report.shift.toString() ?? "Unknown";

                // Membuat unique key untuk grouping
                String key = "$plantStr|$dateStr|$wcStr|$shiftStr";

                if (!groupedData.containsKey(key)) {
                  groupedData[key] = [];
                }
                groupedData[key]!.add(report);
              }

              // 3. Render List berdasarkan Group
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 88),
                  itemCount: groupedData.keys.length,
                  itemBuilder: (context, index) {
                    String key = groupedData.keys.elementAt(index);
                    List<QualityReportQcEntity> groupItems = groupedData[key]!;

                    // Parse key kembali untuk display header
                    List<String> keyParts = key.split('|');
                    String displayPlant = keyParts[0];
                    String displayDate = keyParts[1];
                    String displayWC = keyParts[2];
                    String displayShift = keyParts[3];

                    return Card(
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: ExpansionTile(
                        initiallyExpanded:
                            true, // Opsional: default terbuka atau tertutup
                        shape:
                            const Border(), // Hilangkan border default expansion tile
                        backgroundColor: Colors.white,
                        collapsedBackgroundColor: Colors.grey.shade50,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$displayDate - Shift $displayShift",
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Color(0xFFAB2F2B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "WC: $displayWC | Plant: $displayPlant",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 24.0),
                            Row(
                              children: [
                                SizedBox(
                                  height: 36,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      bool isSuccess = await qualityProvider
                                          .sendApproveRejectReportPerDate(
                                            userProvider
                                                    .currentUser
                                                    ?.username ??
                                                '',
                                            "Approved",
                                            userProvider.currentUser?.role ??
                                                '',
                                            parseInt(displayShift) ?? 0,
                                            displayDate,
                                            displayPlant,
                                            displayWC,
                                            '',
                                          );
                                      if (isSuccess) {
                                        showSnackBar(
                                          "Berhasil Approve",
                                          this.context,
                                        );
                                        final plantCode =
                                            plantprovider.currentPlant?.code ??
                                            "";
                                        await qualityProvider
                                            .fetchFilteredTickets(
                                              _selectedDate,
                                              plantCode,
                                              _tempSelectedShift,
                                            );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.green,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text("Approve All"),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                SizedBox(
                                  height: 36,
                                  child: ElevatedButton(
                                    onPressed: () async {
                                      _showRejectBottomSheet(
                                        context,
                                        displayDate,
                                        displayPlant,
                                        displayWC,
                                        displayShift,
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      foregroundColor: Colors.white,
                                    ),
                                    child: const Text("Reject All"),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 24.0),
                          ],
                        ),
                        trailing: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFAB2F2B).withOpacity(0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "${groupItems.length}",
                            style: const TextStyle(
                              color: Color(0xFFAB2F2B),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        children:
                            groupItems.map((report) {
                              return _buildReportItem(context, report);
                            }).toList(),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildReportItem(BuildContext context, QualityReportQcEntity report) {
    return Container(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade200)),
      ),
      child: ListTile(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => QualityDetailQCPage(item: report),
            ),
          );
        },
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                report.id,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
            ),
            _buildStatusBadge(report),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              const Icon(Icons.schedule, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Text(
                report.time != null
                    ? DateFormat('HH:mm').format(report.time!)
                    : "-",
                style: const TextStyle(fontSize: 13),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.person, size: 14, color: Colors.grey),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  report.entryBy ?? "-",
                  style: const TextStyle(fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Extracted Badge Widget agar lebih rapi
  Widget _buildStatusBadge(QualityReportQcEntity report) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: _getStatusColor(report),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        _getStatusText(report),
        style: const TextStyle(
          color: Colors.white,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  // Extracted Error View
  Widget _buildErrorView(
    QualityReportQCProvider qualityProvider,
    PlantProvider plantprovider,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Error: ${qualityProvider.errorMessage!}',
              style: const TextStyle(color: Colors.red, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            OutlinedButton(
              onPressed: () async {
                final plantCode = plantprovider.currentPlant?.code ?? "";
                await qualityProvider.fetchFilteredTickets(
                  _selectedDate,
                  plantCode,
                  _tempSelectedShift,
                );
              },
              child: const Text("Refresh"),
            ),
          ],
        ),
      ),
    );
  }

  // Extracted Empty View
  Widget _buildEmptyView(
    QualityReportQCProvider qualityProvider,
    PlantProvider plantprovider,
  ) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'No data',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            OutlinedButton(
              onPressed: () async {
                final username =
                    context.read<UserProvider>().currentUser?.username;
                final role = context.read<UserProvider>().currentUser?.role;
                final plantCode = plantprovider.currentPlant?.code ?? "";
                await qualityProvider.fetchAllTickets(
                  null,
                  null,
                  username ?? "",
                  role ?? "",
                  plantCode,
                );
              },
              child: const Text("Refresh"),
            ),
          ],
        ),
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
        const SizedBox(width: 10),
        Expanded(
          child: DropdownButtonFormField<String?>(
            isExpanded: true,
            value: _tempSelectedShift,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF0ECE9),
              hintText: "Pilih Shift",
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              prefixIcon: const Icon(Icons.access_time),
            ),
            items: [
              const DropdownMenuItem<String?>(
                value: "All",
                child: Text('Semua'),
              ),
              ...shifts.map(
                (shift) => DropdownMenuItem<String?>(
                  value: shift,
                  child: Text(" $shift"),
                ),
              ),
            ],
            onChanged: (value) {
              setState(() {
                _tempSelectedShift = value;
              });
            },
          ),
        ),
        const SizedBox(width: 10),
        ElevatedButton.icon(
          onPressed: () async {
            // final plantCode =
            //     context.read<PlantProvider>().currentPlant?.code ?? "";
            // await context.read<QualityReportQCProvider>().fetchFilteredTickets(
            //   _selectedDate,
            //   plantCode,
            //   _tempSelectedShift,
            // );

            final username = context.read<UserProvider>().currentUser?.username;
            final role = context.read<UserProvider>().currentUser?.role;
            final plantCode =
                context.read<PlantProvider>().currentPlant?.code ?? "";
            await context.read<QualityReportQCProvider>().fetchAllTickets(
              null,
              null,
              username ?? "",
              role ?? "",
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

  String _getStatusText(QualityReportQcEntity report) {
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

  Color _getStatusColor(QualityReportQcEntity report) {
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

  Future<void> _pickDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      final plantCode = context.read<PlantProvider>().currentPlant?.code ?? "";
      _selectedDate = picked;
      _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      // await context.read<QualityReportQCProvider>().fetchFilteredTickets(
      //   _selectedDate,
      //   plantCode,
      //   _tempSelectedShift,
      // );

        final username = context.read<UserProvider>().currentUser?.username;
            final role = context.read<UserProvider>().currentUser?.role;
           
            await context.read<QualityReportQCProvider>().fetchAllTickets(
              null,
              null,
              username ?? "",
              role ?? "",
              plantCode,
            );
    }
  }

  void _showRejectBottomSheet(
    BuildContext context,
    String displayDate,
    String displayPlant,
    String displayWC,
    String displayShift,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey[400],
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              Text(
                'Reject Checklist',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.red[800],
                ),
              ),
              const SizedBox(height: 12),
              CustomRemarkField(controller: remarkController),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        if (remarkController.text.isEmpty) {
                          showSnackBar(
                            "Harap isi remark sebelum reject",
                            context,
                          );
                          return;
                        }
                        Navigator.of(context).pop();
                        final userProvider = context.read<UserProvider>();

                        bool isSuccess = await context
                            .read<QualityReportQCProvider>()
                            .sendApproveRejectReportPerDate(
                              userProvider.currentUser?.username ?? '',
                              "Rejected",
                              userProvider.currentUser?.role ?? '',
                              parseInt(displayShift) ?? 0,
                              displayDate,
                              displayPlant,
                              displayWC,
                              remarkController.text,
                            );
                        if (isSuccess) {
                          showSnackBar("Berhasil Reject", this.context);
                          final plantCode =
                              context
                                  .read<PlantProvider>()
                                  .currentPlant
                                  ?.code ??
                              "";
                          await context
                              .read<QualityReportQCProvider>()
                              .fetchFilteredTickets(
                                _selectedDate,
                                plantCode,
                                _tempSelectedShift,
                              );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[700],
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: const Text(
                        'Confirm Reject',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}
