import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/core/widgets/custom_section_card.dart';
import 'package:logsheet_app/core/widgets/custom_section_card_data.dart';
import 'package:logsheet_app/core/widgets/custom_section_title.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:logsheet_app/features/production/data/model/dry_fractionation/local/dry_fractionation_detail_entity.dart';
import 'package:logsheet_app/features/production/data/model/dry_fractionation/local/dry_fractionation_header_entity.dart';
import 'package:logsheet_app/features/production/presentation/pages/dry_fractionation/dry_fractionation_edit_page.dart'; // Pastikan import ini ada
import 'package:logsheet_app/features/production/presentation/provider/dry_fractionation/dry_fractionation_provider.dart';
import 'package:provider/provider.dart';

class DryFractionationReportDetailPage extends StatefulWidget {
  final List<DryFractionationHeaderEntity> reportEntities;
  final String title;

  const DryFractionationReportDetailPage({
    super.key,
    required this.reportEntities,
    required this.title,
  });

  @override
  State<DryFractionationReportDetailPage> createState() =>
      _DryFractionationReportDetailPageState();
}

class _DryFractionationReportDetailPageState
    extends State<DryFractionationReportDetailPage> {
  final TextEditingController remarkController = TextEditingController();
  final PageController detailPageControllers = PageController();

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().currentUser;

    return Scaffold(
      appBar: AppBar(title: Text(widget.title)),
      body: Consumer<DryFractionationProvider>(
        builder: (context, provider, child) {
          if (provider.isLoadingApproval) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: widget.reportEntities.length,
                  itemBuilder: (context, index) {
                    final report = widget.reportEntities[index];

                    IconData? icon;
                    Color? iconColor;
                    Color? cardColor;

                    String? showedStatus = '';

                    if (report.preparedStatus == "Approved" &&
                        report.approvedStatus == "Approved") {
                      icon = Icons.check_circle;
                      iconColor = Colors.green;
                      cardColor = Colors.green[50];
                      showedStatus = "Approved";
                    } else if (report.preparedStatus == "Rejected" ||
                        report.approvedStatus == "Rejected") {
                      icon = Icons.cancel;
                      iconColor = Colors.red;
                      cardColor = Colors.red[50];
                      showedStatus = "Rejected";
                    } else if (report.preparedStatus != null) {
                      icon = Icons.hourglass_empty;
                      iconColor = Colors.orange;
                      cardColor = Colors.orange[50];
                      showedStatus = "Prepared";
                    } else if (report.preparedStatus == null &&
                        report.approvedStatus == null) {
                      icon = Icons.hourglass_empty;
                      iconColor = Colors.blue;
                      cardColor = Colors.blue[50];
                      showedStatus = "Submitted";
                    }

                    return Card(
                      color: cardColor,
                      elevation: 2,
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ExpansionTile(
                        initiallyExpanded: false,
                        leading: Icon(icon, color: iconColor),
                        // Modifikasi Trailing untuk menampilkan Status & Tombol Edit
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              showedStatus ?? '',
                              style: TextStyle(
                                color: iconColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                            // Tampilkan tombol edit jika status masih awal (Submitted / null)
                            if (report.preparedStatus == null &&
                                report.isCompleted == false) ...[
                              const SizedBox(width: 4),
                              IconButton(
                                icon: const Icon(Icons.edit, size: 20),
                                tooltip: 'Edit Report',
                                onPressed: () async {
                                  // Navigasi ke halaman edit
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) => DryFractionationEditPage(
                                            data: report,
                                          ),
                                    ),
                                  );
                                  // Refresh UI setelah kembali dari edit page (jika ada perubahan)
                                  setState(() {});
                                },
                              ),

                              IconButton(
                                icon: const Icon(Icons.delete, size: 20),
                                tooltip: 'Delete Report',
                                onPressed: () async {
                                  return _showDeleteConfirmationDialog(
                                    context,
                                    id: report.id,
                                  );
                                },
                              ),
                            ],
                          ],
                        ),
                        title: Text(
                          'Crystallizer: ${report.crystallizer}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('ID: ${report.id}'),

                        children: [
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 1. Header Information (Process Parameters)
                                CustomSectionCard("Process Parameters", [
                                  CustomSectionCardData(
                                    "Feed Oil IV",
                                    "${report.feedOilIv ?? '-'}",
                                  ),
                                  CustomSectionCardData(
                                    "Filling Start",
                                    formatTimeOfDay(report.fillingStartTime) ??
                                        '-',
                                  ),
                                  CustomSectionCardData(
                                    "Filling End",
                                    formatTimeOfDay(report.fillingEndTime) ??
                                        '-',
                                  ),
                                  CustomSectionCardData(
                                    "Cooling Start Temp",
                                    "${report.coolingStartTemp ?? '-'}",
                                  ),
                                ]),

                                const Divider(),

                                // 2. Detail Data (Filtration Cycles)
                                CustomSectionTitle(
                                  title:
                                      "Filtration Details (${report.details.length} Cycles)",
                                ),
                                if (report.details.isEmpty)
                                  const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Text("No details recorded."),
                                  ),

                                ...report.details.map((detail) {
                                  return _buildDetailRowItem(detail);
                                }).toList(),

                                const SizedBox(height: 16),

                                // 3. Approval Actions (Only if leadProd & not finalized)
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildDetailRowItem(DryFractionationDetailEntity detail) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        dense: true,
        title: Text(
          "Cycle #${detail.filtrationCycleNumber}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "Time: ${formatTimeOfDay(detail.timeStartFiltration)} - ${formatTimeOfDay(detail.timeEndFiltration)}\n"
          "Olein IV: ${detail.oleinIv ?? '-'} | CP: ${detail.oleinCp ?? '-'}",
        ),
        trailing: const Icon(Icons.keyboard_arrow_right, size: 20),
        onTap: () {
          _showDetailBottomSheet(context, detail);
        },
      ),
    );
  }

  // Tombol Approve/Reject

  void _showDetailBottomSheet(
    BuildContext context,
    DryFractionationDetailEntity detail,
  ) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Detail Cycle #${detail.filtrationCycleNumber}",
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const Divider(),
              CustomSectionCardData(
                "Filtration Temp",
                "${detail.filtrationTemp ?? '-'}",
              ),
              CustomSectionCardData("Load", "${detail.load ?? '-'}"),
              const SizedBox(height: 8),
              const Text(
                "Olein",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CustomSectionCardData("IV", "${detail.oleinIv ?? '-'}"),
              CustomSectionCardData("CP", "${detail.oleinCp ?? '-'}"),
              CustomSectionCardData("Color", "${detail.oleinColorRed ?? '-'}"),
              const SizedBox(height: 8),
              const Text(
                "Stearin",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              CustomSectionCardData("IV", "${detail.stearinIv ?? '-'}"),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDeleteConfirmationDialog(
    BuildContext context, {
    required String id,
  }) async {
    // Simpan context utama ke variabel
    final parentContext = context;

    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Delete Report',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: const Text(
            'Are you sure you want to delete this report? This action cannot be undone.',
          ),
          actions: [
            TextButton(
              onPressed:
                  () => Navigator.of(dialogContext).pop(), // tutup dialog
              child: const Text('Cancel'),
            ),
            Consumer<DryFractionationProvider>(
              builder: (
                BuildContext context,
                DryFractionationProvider provider,
                Widget? child,
              ) {
                return (provider.isLoadingDelete)
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () async {
                        Navigator.of(dialogContext).pop(); // tutup dialog dulu

                        final provider =
                            parentContext.read<DryFractionationProvider>();

                        final isSuccess = await provider.deleteReport(
                          id: id ?? '',
                        );

                        if (isSuccess) {
                          if (parentContext.mounted) {
                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              const SnackBar(
                                content: Text('Report deleted successfully.'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.of(
                              parentContext,
                            ).pop(); // ✅ ini menutup halaman detail
                          }
                        } else {
                          if (parentContext.mounted) {
                            ScaffoldMessenger.of(parentContext).showSnackBar(
                              const SnackBar(
                                content: Text('Failed to delete report.'),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        }
                      },
                      child: const Text('Delete'),
                    );
              },
            ),
          ],
        );
      },
    );
  }
}
