import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/maintenance/presentation/pages/maintenance_change_product/maintenance_change_product_input_page.dart';
import 'package:logsheet_app/features/maintenance/presentation/pages/maintenance_change_product/maintenance_change_product_list_detail_page.dart';
import 'package:logsheet_app/features/maintenance/presentation/pages/maintenance_startup_production/maintenance_startup_production_input_page.dart';
import 'package:logsheet_app/features/maintenance/presentation/pages/maintenance_startup_production/maintenance_startup_production_list_detail_page.dart';
import 'package:logsheet_app/features/quality_control/presentation/pages/qc/quality_input_qc_page.dart';
import 'package:logsheet_app/core/widgets/custom_date_field.dart';
import 'package:logsheet_app/features/maintenance/presentation/provider/change_product_checklist/maintenance_change_product_checklist_provider.dart';
import 'package:logsheet_app/features/maintenance/presentation/provider/start_up_produksi_checklist/maintenance_start_up_produksi_checklist_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/data_form_no_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/plant_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/quality_report/quality_report_qc_provider.dart';
import 'package:provider/provider.dart';

class MaintenanceStartupProductionListPage extends StatefulWidget {
  const MaintenanceStartupProductionListPage({super.key});

  @override
  State<MaintenanceStartupProductionListPage> createState() =>
      _MaintenanceStartupProductionListPageState();
}

class _MaintenanceStartupProductionListPageState
    extends State<MaintenanceStartupProductionListPage> {
  DataFormNoEntity? formData;
  final TextEditingController dateEntryController = TextEditingController();

  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context
          .read<MaintenanceStartUpProduksiChecklistProvider>()
          .clearUniqueReportList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final username = context.read<UserProvider>().currentUser?.username;
    final userRole = context.read<UserProvider>().currentUser?.role;
    return Scaffold(
      appBar: _buildAppBar(userRole ?? ''),
      body: _buildBody(userRole ?? ''),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          log("Tombol Tambah Change Product Ditekan");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MaintenanceStartupProductionInputPage(),
            ),
          ).then((_) async {
            // Refresh the list when returning from the detail page
            if (!mounted) return;
            final formatted = parseDateTimeForQuery(dateEntryController.text);
            await context
                .read<MaintenanceStartUpProduksiChecklistProvider>()
                .getAllReportsFromDate(formatted ?? '', userRole ?? '');
          });
        },
        label: const Text("Tambah Startup Product"),
        icon: Icon(Icons.add),
        backgroundColor: Color(0xFFB91C1C),
        foregroundColor: Colors.white,
      ),
    );
  }

  AppBar _buildAppBar(String role) {
    formData =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where((form) => form.isMenu == "Start_Up_Produksi_Checklist")
            .first;
    return AppBar(
      title: Text("Startup Product (${formData?.code})"),
      actions: [
        Consumer<MaintenanceStartUpProduksiChecklistProvider>(
          builder: (
            BuildContext context,
            MaintenanceStartUpProduksiChecklistProvider provider,
            Widget? child,
          ) {
            return (provider.isLoading)
                ? CircularProgressIndicator()
                : IconButton(
                  onPressed: () async {
                    await provider.getAllReportsFromDate(
                      parseDateTimeForQuery(dateEntryController.text) ?? '',
                      role,
                    );
                  },
                  icon: Icon(Icons.replay),
                );
          },
        ),
      ],
    );
  }

  Widget _buildBody(String role) {
    final startUpProduksiChecklistProvider =
        context.watch<MaintenanceStartUpProduksiChecklistProvider>();

    final isLoading = startUpProduksiChecklistProvider.isLoading;
    var reportList = startUpProduksiChecklistProvider.uniqueReportList;

    if ((AppRoles.leadProd.contains(role))) {
      reportList =
          startUpProduksiChecklistProvider.uniqueReportList
              .where((item) => item.preparedStatus == null)
              .toList();
    }

    return Column(
      children: [
        _buildFilterSection(context, role),
        Expanded(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Builder(
                builder: (context) {
                  if (isLoading) {
                    // 🔹 Tampilkan indikator loading
                    return const Center(child: CircularProgressIndicator());
                  } else if (reportList.isEmpty) {
                    // 🔹 Tampilkan teks jika tidak ada data
                    return const Center(child: Text("No Data Available"));
                  } else {
                    // 🔹 Tampilkan list jika ada data
                    return ListView.builder(
                      itemCount: reportList.length,
                      itemBuilder: (context, index) {
                        final item = reportList[index];
                        return _changeProductsCardItem(
                          id: item.id,
                          date: item.transactionDate,
                          time: item.transactionTime,
                          workCenter: item.workCenter ?? '',
                          entryBy: item.entryBy ?? '',
                          role: role,
                          approvedStatus: item.checkedStatus ?? '',
                          preparedStatus: item.preparedStatus ?? '',
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilterSection(BuildContext context, String role) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Row(
        children: [
          Expanded(
            child: CustomDateField(
              controller: dateEntryController,
              label: 'Tanggal',
              icon: Icons.event,
            ),
          ),
          SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () async {
              final formattedDate = parseDateTimeForQuery(
                dateEntryController.text,
              );
              log('Searching for date: $formattedDate');
              if (formattedDate != null) {
                await context
                    .read<MaintenanceStartUpProduksiChecklistProvider>()
                    .getAllReportsFromDate(formattedDate, role);
              }
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
      ),
    );
  }

  Widget _changeProductsCardItem({
    required String id,
    required String date,
    required String time,
    required String workCenter,
    required String entryBy,
    String? role,
    required String approvedStatus,
    required String preparedStatus,
    Color? badgeColor,
    String? showedStatus,
  }) {
    if (preparedStatus == "Approved" && approvedStatus == "Approved") {
      badgeColor = Colors.green;
      showedStatus = "Approved";
    } else if (preparedStatus == "Rejected" || approvedStatus == "Rejected") {
      badgeColor = Colors.red;
      showedStatus = "Rejected";
    } else if (preparedStatus != '') {
      badgeColor = Colors.orange;
      showedStatus = "Prepared";
    } else if (preparedStatus == '') {
      badgeColor = Colors.blue;
      showedStatus = "Submitted";
    }
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => MaintenanceStartupProductionListDetailPage(id: id),
          ),
        ).then((_) {
          // Refresh the list when returning from the detail page
          if (!mounted) return;
          final formatted = parseDateTimeForQuery(dateEntryController.text);
          context
              .read<MaintenanceStartUpProduksiChecklistProvider>()
              .getAllReportsFromDate(formatted ?? '', role ?? '');
        });
      },
      child: Card(
        child: Padding(
          padding: EdgeInsetsGeometry.all(16.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      "$id",
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '$showedStatus',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              const Divider(height: 16),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.calendar_today,
                    size: 16,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "${_formatDateString(date)}",
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  SizedBox(width: 16),

                  const Icon(Icons.schedule, size: 18, color: Colors.grey),
                  SizedBox(width: 8),
                  Text(
                    "$time",
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  SizedBox(width: 16),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  const Icon(
                    Icons.home_work_rounded,
                    size: 18,
                    color: Colors.grey,
                  ),
                  SizedBox(width: 8),
                  Text(
                    "$workCenter",
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                  const Icon(Icons.person, size: 16, color: Colors.grey),
                  const SizedBox(width: 8),
                  Text(
                    'Entried by: $entryBy',
                    style: const TextStyle(fontSize: 14, color: Colors.black87),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? parseDateTimeForQuery(String? selectedDate) {
    if (selectedDate == null || selectedDate.isEmpty) return null;

    try {
      // Step 1: Parse dari format UI
      final inputFormat = DateFormat('dd-MM-yyyy');
      final dateTime = inputFormat.parse(selectedDate);

      // Step 2: Ubah ke format yang diinginkan
      final outputFormat = DateFormat('yyyy-MM-dd');
      return outputFormat.format(dateTime);
    } catch (e) {
      print("Error parsing date: $e");
      return null;
    }
  }

  String _formatDateString(String? s) {
    if (s == null || s.isEmpty) return '-';
    final dt = DateTime.tryParse(s);
    if (dt != null) {
      return DateFormat('dd-MM-yyyy').format(dt);
    }
    // If parsing fails, return the original string as a fallback
    return s;
  }
}
