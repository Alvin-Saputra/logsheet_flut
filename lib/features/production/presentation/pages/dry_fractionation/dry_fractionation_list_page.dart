import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/core/widgets/custom_date_field.dart';
import 'package:logsheet_app/core/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/plant_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:logsheet_app/features/production/data/model/dry_fractionation/local/dry_fractionation_header_entity.dart';
import 'package:logsheet_app/features/production/presentation/pages/dry_fractionation/dry_fractionation_detail_page.dart';
import 'package:logsheet_app/features/production/presentation/pages/dry_fractionation/dry_fractionation_input.dart';
import 'package:logsheet_app/features/production/presentation/provider/dry_fractionation/dry_fractionation_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/data_form_no_provider.dart';
import 'package:provider/provider.dart';

class DryFractionationListPage extends StatefulWidget {
  const DryFractionationListPage({super.key});

  @override
  State<DryFractionationListPage> createState() =>
      _DryFractionationListPageState();
}

class _DryFractionationListPageState extends State<DryFractionationListPage> {
  DataFormNoEntity? formData;
  final TextEditingController dateEntryController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Pastikan provider di-reset atau fetch data awal jika perlu
    context.read<DryFractionationProvider>().clearReports();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildFilterSection(context),
          Expanded(
            child: Consumer<DryFractionationProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (provider.reportList.isEmpty) {
                  return const Center(child: Text("No Data Available"));
                }

                // 1. Grouping Data berdasarkan Tanggal dan Plant
                final Map<String, List<DryFractionationHeaderEntity>>
                groupedData = {};
                for (var report in provider.reportList) {
                  // Key Grouping: Tanggal + Plant
                  final dateStr =
                      formatDatetoString(report.date, 'yyyy-MM-dd') ??
                      'Unknown Date';
                  final plantStr = report.plant ?? 'Unknown Plant';
                  final key = "$dateStr|$plantStr";

                  groupedData.putIfAbsent(key, () => []).add(report);
                }

                final groupedKeys = groupedData.keys.toList();

                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  child: ListView.builder(
                    itemCount: groupedKeys.length,
                    itemBuilder: (context, index) {
                      final key = groupedKeys[index];
                      final reports = groupedData[key]!;

                      // Ambil data representatif dari item pertama di grup
                      final firstItem = reports.first;
                      final formattedDate =
                          formatDatetoString(firstItem.date, 'dd-MM-yyyy') ??
                          '-';
                      final plantName = firstItem.plant ?? '-';

                      // Cek status keseluruhan (Opsional: logic bisa disesuaikan)
                      // Jika ada satu yang belum approve, anggap "Pending"
                      final isAllApproved = reports.every(
                        (e) => e.approvedStatus == "Approved",
                      );
                      final isAnyRejected = reports.any(
                        (e) =>
                            e.approvedStatus == "Rejected" ||
                            e.preparedStatus == "Rejected",
                      );

                      return _groupedCardItem(
                        date: formattedDate,
                        plant: plantName,
                        totalItems: reports.length,
                        isAllApproved: isAllApproved,
                        isAnyRejected: isAnyRejected,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              // 2. Mengirim LIST laporan ke halaman detail
                              builder:
                                  (context) => DryFractionationDetailPage(
                                    reportEntities:
                                        reports, // Kirim list hasil grouping
                                    title: "$formattedDate - $plantName",
                                  ),
                            ),
                          ).then((_) async {
                            if (!mounted) return;
                            _refreshData();
                          });
                        },
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => DryFractionationInputPage(form: formData),
            ),
          ).then((_) {
            _refreshData();
          });
        },
        label: const Text("Tambah Report"),
        icon: Icon(Icons.add),
        backgroundColor: Color(0xFFB91C1C),
        foregroundColor: Colors.white,
      ),
    );
  }

  AppBar _buildAppBar() {
    final formProvider = context.read<DataFormNoProvider>();
    // Safety check jika list kosong
    if (formProvider.dataFormNoList.isNotEmpty) {
      try {
        formData = formProvider.dataFormNoList.firstWhere(
          (form) =>
              form.isMenu == "Logsheet_Dry_Fractionation",
        );
      } catch (e) {
        formData = null;
      }
    }

    return AppBar(
      title: Text("List ${formData?.code ?? ''}"),
      actions: [
        IconButton(onPressed: _refreshData, icon: const Icon(Icons.replay)),
      ],
    );
  }

  Future<void> _refreshData() async {
    final plant = await context.read<PlantProvider>().currentPlant;
    final user = await context.read<UserProvider>().currentUser;
    if (!mounted) return;

    // Menggunakan filter tanggal jika ada
    final formattedDate =
        dateEntryController.text.isNotEmpty
            ? changeStringDateFormat(
              dateEntryController.text,
              'dd-MM-yyyy',
              'yyyy-MM-dd',
            )
            : '';

    await context.read<DryFractionationProvider>().fetchReport(
      plant?.code ?? '',
      formattedDate,
      role: user?.role ?? '',
    );
  }

  Widget _buildFilterSection(BuildContext context) {
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
          const SizedBox(width: 16),
          ElevatedButton.icon(
            onPressed: () {
              if (dateEntryController.text != "") {
                _refreshData();
              } else {
                showSnackBar("Silahkan Pilih Tanggal", context);
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

  Widget _groupedCardItem({
    required String date,
    required String plant,
    required int totalItems,
    required bool isAllApproved,
    required bool isAnyRejected,
    required VoidCallback onTap,
  }) {
    IconData icon = Icons.folder_open;
    Color color = Colors.blue;
    Color bgColor = Colors.blue[50]!;
    String statusText = "Submitted";

    if (isAllApproved) {
      icon = Icons.check_circle;
      color = Colors.green;
      bgColor = Colors.green[50]!;
      statusText = "All Approved";
    } else if (isAnyRejected) {
      icon = Icons.warning_rounded;
      color = Colors.red;
      bgColor = Colors.red[50]!;
      statusText = "Action Needed";
    } else {
      icon = Icons.hourglass_top;
      color = Colors.orange;
      bgColor = Colors.orange[50]!;
      statusText = "Pending";
    }

    return Card(
      // color: bgColor,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
      elevation: 2,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.drag_handle_outlined, color: Colors.grey, size: 40),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      date,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text('Plant: $plant', style: const TextStyle(fontSize: 14)),
                    const SizedBox(height: 4),
                    Text(
                      '$totalItems Crystallizer Batch(es)',
                      style: const TextStyle(
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  // Text(
                  //   statusText,
                  //   style: TextStyle(
                  //     fontSize: 12,
                  //     fontWeight: FontWeight.bold,
                  //     color: color,
                  //   ),
                  // ),
                  const Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: Colors.grey,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
