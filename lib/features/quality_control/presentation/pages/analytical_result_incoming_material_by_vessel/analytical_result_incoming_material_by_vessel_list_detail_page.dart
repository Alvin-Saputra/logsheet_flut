import 'dart:developer';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/maintenance/data/model/change_product_checklist/maintenance_change_product_checklist_report_entity.dart';
import 'package:logsheet_app/features/master_data/data/model/master/user_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_report_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/daily_quality_composite_fractionation/daily_quality_composite_fractionation_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/daily_storage_tank_analytical/daily_storage_tank_analytical_from_db_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/daily_storage_tank_analytical/daily_storage_tank_analytical_to_db_entity.dart';
import 'package:logsheet_app/features/maintenance/presentation/pages/maintenance_change_product/maintenance_change_product_edit_page.dart';
import 'package:logsheet_app/features/quality_control/presentation/pages/daily_quality_composite_fractionation/daily_quality_composite_fractionation_edit_page.dart';
import 'package:logsheet_app/features/quality_control/presentation/pages/daily_storage_tank_analytical/daily_storage_tank_analytical_edit_page.dart';
import 'package:logsheet_app/features/quality_control/presentation/pages/daily_storage_tank_analytical/daily_storage_tank_analytical_report_detail_page.dart';
import 'package:logsheet_app/core/widgets/custom_remark_field.dart';
import 'package:logsheet_app/core/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/core/widgets/custom_stateless_checklist_item_row.dart';
import 'package:logsheet_app/features/maintenance/presentation/provider/change_product_checklist/maintenance_change_product_checklist_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/daily_quality_composite_fractionation/daily_quality_composite_fractionation_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/daily_storage_tank_analytical/daily_storage_tank_analytical_provider.dart';
import 'package:provider/provider.dart';

class AnalyticalResultIncomingMaterialByVesselListDetailPage
    extends StatefulWidget {
  AnalyticalResultIncomingMaterialByVesselListDetailPage({
    super.key,
    required this.id,
  });

  String id;

  @override
  State<AnalyticalResultIncomingMaterialByVesselListDetailPage> createState() =>
      _AnalyticalResultIncomingMaterialByVesselListDetailPageState();
}

class _AnalyticalResultIncomingMaterialByVesselListDetailPageState
    extends State<AnalyticalResultIncomingMaterialByVesselListDetailPage> {
  List<AnalyticalResultIncomingMaterialByVesselReportEntity> reportItem = [];
  final TextEditingController remarkController = TextEditingController();
  final PageController detailPageControllers = PageController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      final item =
          context
              .read<AnalyticalResultIncomingMaterialByVesselProvider>()
              .uniqueReportList
              .where((element) => element.idHdr == widget.id)
              .toList();

      setState(() {
        reportItem = item;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Consumer<DailyQualityCompositeFractionationProvider>(
        builder: (
          BuildContext context,
          DailyQualityCompositeFractionationProvider value,
          Widget? child,
        ) {
          return (value.isLoadingApproval)
              ? const Center(child: CircularProgressIndicator())
              : _buildBody(context);
        },
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return Consumer2<DailyQualityCompositeFractionationProvider, UserProvider>(
      builder: (
        BuildContext context,
        DailyQualityCompositeFractionationProvider reportProvider,
        UserProvider userProvider,
        Widget? child,
      ) {
        return (reportProvider.isLoading || reportProvider.isLoadingDelete)
            ? Center(child: CircularProgressIndicator())
            : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: 16,
                  bottom: 36,
                  right: 16,
                  left: 16,
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFAB2F2B),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildInfoCard(
                            'Date',
                            _formatDateString(reportItem[0]?.transactionDate),
                          ),
                        ],
                      ),
                    ),

                    _buildSection('General Information', [
                      _buildDataRow('ID', reportItem[0].idHdr ?? ''),
                    ]),

                    _buildSection('Analytical Information', [
                      _buildDataRow('Material', reportItem[0].material ?? ''),
                      _buildDataRow('Arrival', reportItem[0].arrival ?? ''),
                      _buildDataRow('Quantity', reportItem[0].quantity ?? ''),
                      _buildDataRow('Supplier', reportItem[0].supplier ?? ''),
                      _buildDataRow(
                        "Ship's Name",
                        reportItem[0].shipName ?? '',
                      ),
                      _buildDataRow(
                        'Contract/DO No',
                        reportItem[0].contractDoNomor ?? '',
                      ),
                      _buildDataRow('FFA', reportItem[0].ffa ?? ''),
                      _buildDataRow('M&I', reportItem[0].mni ?? ''),
                      _buildDataRow('Dobi', reportItem[0].dobi ?? ''),
                      _buildDataRow('Others', reportItem[0].others ?? ''),
                    ]),

                    SizedBox(
                      height: 400,
                      child: ExpandablePageView.builder(
                        controller: detailPageControllers,
                        itemCount: reportItem.length,
                        itemBuilder: (context, pageIndex) {
                          return Column(
                            children: [
                              Text(
                                "Detail Data Ke - ${pageIndex + 1}",
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(height: 12),
                      
                              // --- FORM PALKA S ---
                              _buildSection("Palka S", [
                                _buildDataRow(
                                  'Palka S No',
                                  reportItem[pageIndex].palkaSNo ?? '',
                                ),
                                _buildDataRow(
                                  'Palka S FFA',
                                  reportItem[pageIndex].palkaSFfa ?? '',
                                ),
                                _buildDataRow(
                                  'Palka S IV',
                                  reportItem[pageIndex].palkaSIv ?? '',
                                ),
                                _buildDataRow(
                                  'Palka S M&I',
                                  reportItem[pageIndex].palkaSMni ?? '',
                                ),
                                _buildDataRow(
                                  'Palka S Dobi',
                                  reportItem[pageIndex].palkaSDobi ?? '',
                                ),
                              ]),
                      
                              const SizedBox(height: 8),
                              const Divider(),
                      
                              // --- FORM PALKA C ---
                            ],
                          );
                        },
                      ),
                    ),

                    _buildSection('Remarks', [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              reportItem[0]?.remarks ?? '',
                              softWrap: true,
                            ),
                          ),
                        ],
                      ),
                    ]),

                    if ((AppRoles.leadQC.contains(
                          userProvider.currentUser?.role,
                        )) ||
                        (AppRoles.qualityControlManagerApproval.contains(
                          userProvider.currentUser?.role,
                        )))
                      _buildSection('Approval Actions', [
                        if (reportItem[0]?.preparedStatus == "Approved" &&
                            reportItem[0]?.approvedStatus == "Approved") ...[
                          Text(
                            "Checklist Approved",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ] else if (reportItem[0]?.preparedStatus ==
                                "Rejected" ||
                            reportItem[0]?.approvedStatus == "Rejected") ...[
                          Text(
                            "Checklist Rejected",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ] else if (AppRoles.leadQC.contains(
                          userProvider.currentUser?.role,
                        )) ...[
                          if (reportItem[0]?.preparedStatus == null) ...[
                            Text('Prepared Status:'),
                            SizedBox(height: 8.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 8.0,
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        _showRejectBottomSheet(context);
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: const [
                                          Text('Reject'),
                                          Icon(Icons.close),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0,
                                      vertical: 8.0,
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        bool isSuccess =
                                            await _approveRejectReport(
                                              "Approved",
                                            );
                                        if (isSuccess) {
                                          showSnackBar(
                                            "Berhasil Approve Checklist",
                                            context,
                                          );

                                          log("Sukses Approve");
                                          if (!mounted) return;
                                          Navigator.of(this.context).pop();
                                        } else {
                                          showSnackBar(
                                            "Gagal Approve Checklist",
                                            context,
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: const [
                                          Text('Approve'),
                                          Icon(Icons.check),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ] else if (reportItem[0]?.preparedStatus != null &&
                              reportItem[0]?.approvedStatus == null) ...[
                            Text(
                              "Waiting Apprvoal From Manager Productions...",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ] else if (AppRoles.qualityControlManagerApproval
                            .contains(userProvider.currentUser?.role)) ...[
                          if (reportItem[0]?.approvedStatus == null) ...[
                            Text(
                              "Waiting Apprvoal From Leader QC...",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ] else if (reportItem[0]?.preparedStatus ==
                                  "Approved" ||
                              reportItem[0]?.approvedStatus == "Rejected") ...[
                            Row(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  "Checklist Prepared",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ],
                      ]),
                  ],
                ),
              ),
            );
      },
    );
  }

  Widget _buildDataRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF655F5B),
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(), // <-- ini kuncinya
          Text(value, style: const TextStyle(color: Colors.black54)),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFFAB2F2B),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: title == "Shift" || title == "Jam" ? 24 : 14,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<Widget> children) {
    return Card(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 3,
      margin: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xFF655F5B),
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: const Text(
        'Detail',
        style: TextStyle(color: Color(0xFF655F5B), fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        if (reportItem[0]?.preparedStatus == null)
          IconButton(
            onPressed: () async {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => DailyQualityCompositeFractionationEditPage(
                        id: widget.id,
                      ),
                ),
              );
            },
            icon: const Icon(Icons.edit),
          ),
        if (reportItem[0]?.preparedStatus == null)
          IconButton(
            onPressed: () async {
              return _showDeleteConfirmationDialog(context);
            },
            icon: const Icon(Icons.delete_rounded, color: Colors.red),
          ),
      ],
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
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
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                Navigator.of(dialogContext).pop(); // tutup dialog dulu

                final provider =
                    parentContext
                        .read<DailyQualityCompositeFractionationProvider>();

                final isSuccess = await provider
                    .deletedailyQualityCompositeFractionation(widget.id);

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
            ),
          ],
        );
      },
    );
  }

  Future<bool> _approveRejectReport(String status) {
    final user = context.read<UserProvider>();

    var isSuccess = context
        .read<DailyQualityCompositeFractionationProvider>()
        .updateApproveRejectToHeader(
          id: widget.id,
          approvedBy: user.currentUser!.username,
          status: status,
          role: user.currentUser!.role,
          remarks: remarkController.text,
        );
    return isSuccess;
  }

  void _showRejectBottomSheet(BuildContext context) {
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
                        bool isSuccess = await _approveRejectReport("Rejected");
                        if (isSuccess) {
                          Navigator.of(
                            this.context,
                          ).pop(); // Tutup bottom sheet
                          showSnackBar(
                            "Berhasil Reject Checklist",
                            this.context,
                          );
                        } else {
                          Navigator.of(this.context).pop();
                          showSnackBar("Gagal Reject Checklist", this.context);
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

  String _formatDateString(String? s) {
    if (s == null || s.isEmpty) return '-';
    final dt = DateTime.tryParse(s);
    if (dt != null) {
      return DateFormat('dd MMMM yyyy').format(dt);
    }
    // If parsing fails, return the original string as a fallback
    return s;
  }

  String _formatTimeString(String? s) {
    if (s == null || s.isEmpty) return '-';
    try {
      final dt = DateFormat("HH:mm:ss").parse(s);
      return DateFormat("HH:mm").format(dt); // hasil: 08:00
    } catch (e) {
      return s; // fallback jika parsing gagal
    }
  }
}
