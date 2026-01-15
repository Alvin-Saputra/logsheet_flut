import 'dart:developer';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/core/widgets/custom_info_card.dart';
import 'package:logsheet_app/core/widgets/custom_section_card.dart';
import 'package:logsheet_app/core/widgets/custom_section_card_data.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:logsheet_app/features/production/data/model/dry_fractionation/local/dry_fractionation_detail_entity.dart';
import 'package:logsheet_app/features/production/data/model/dry_fractionation/local/dry_fractionation_header_entity.dart';
import 'package:logsheet_app/features/production/presentation/pages/dry_fractionation/dry_fractionation_edit_page.dart';
import 'package:logsheet_app/features/production/presentation/provider/dry_fractionation/dry_fractionation_provider.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_header_entity.dart';
import 'package:logsheet_app/core/widgets/custom_remark_field.dart';
import 'package:logsheet_app/core/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/features/quality_control/presentation/pages/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_edit_page.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/daily_quality_composite_fractionation/daily_quality_composite_fractionation_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class DryFractionationDetailPage extends StatefulWidget {
  DryFractionationDetailPage({super.key, required this.data});

  final DryFractionationHeaderEntity data;

  @override
  State<DryFractionationDetailPage> createState() =>
      _DryFractionationDetailPageState();
}

class _DryFractionationDetailPageState
    extends State<DryFractionationDetailPage> {
  final TextEditingController remarkController = TextEditingController();
  final PageController detailPageControllers = PageController();
  late DryFractionationHeaderEntity _data;
  @override
  @override
  void initState() {
    super.initState();
    _data = widget.data;
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
    final userProvider = context.read<UserProvider>();
    return Consumer<AnalyticalResultIncomingMaterialByVesselProvider>(
      builder: (
        BuildContext context,
        AnalyticalResultIncomingMaterialByVesselProvider provider,
        Widget? child,
      ) {
        return (provider.isLoadingEdit)
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
                          CustomInfoCard(
                            'Date',
                            formatDatetoString(_data.date, 'dd MMMM yyyy') ??
                                '-',
                          ),
                        ],
                      ),
                    ),

                    CustomSectionCard('General Information', [
                      CustomSectionCardData('ID', _data.id),
                      CustomSectionCardData('Company', _data.company ?? '-'),
                      CustomSectionCardData('Plant', _data.plant ?? '-'),
                      CustomSectionCardData(
                        'Crystallizer',
                        _data.crystallizer ?? '-',
                      ),
                    ]),

                    CustomSectionCard('Process Parameters', [
                      CustomSectionCardData(
                        'Feed Oil IV',
                        '${_data.feedOilIv ?? '-'}',
                      ),
                      CustomSectionCardData(
                        'Initial Oil Level',
                        '${_data.initialOilLevel ?? '-'}',
                      ),
                      CustomSectionCardData(
                        'Filling Start',
                        formatTimeOfDay(_data.fillingStartTime) ?? '-',
                      ),
                      CustomSectionCardData(
                        'Filling End',
                        formatTimeOfDay(_data.fillingEndTime) ?? '-',
                      ),
                      CustomSectionCardData(
                        'Cooling Start Temp',
                        '${_data.coolingStartTemp ?? '-'}',
                      ),
                      CustomSectionCardData(
                        'Cooling Start Time',
                        formatTimeOfDay(_data.coolingStartTime),
                      ),
                      CustomSectionCardData(
                        'Agitator Speed',
                        '${_data.agitatorSpeed ?? '-'}',
                      ),
                      CustomSectionCardData(
                        'Water Pump Pres',
                        '${_data.waterPumpPres ?? '-'}',
                      ),
                    ]),

                    SizedBox(height: 12.0),
                    if (_data.details.isNotEmpty) ...[
                      CustomSectionCard('Details', [
                        // Indikator Halaman (Dots)
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: SmoothPageIndicator(
                              controller: detailPageControllers,
                              count: _data.details.length,
                              effect: const WormEffect(
                                dotHeight: 8,
                                dotWidth: 8,
                                activeDotColor: Color(0xFFAB2F2B),
                                dotColor: Colors.grey,
                              ),
                              onDotClicked: (index) {
                                detailPageControllers.animateToPage(
                                  index,
                                  duration: const Duration(milliseconds: 300),
                                  curve: Curves.easeInOut,
                                );
                              },
                            ),
                          ),
                        ),

                        // Expandable Page View
                        ExpandablePageView.builder(
                          controller: detailPageControllers,
                          itemCount: _data.details.length,
                          itemBuilder: (context, index) {
                            final detail = _data.details[index];
                            return _buildDetailItem(detail, index);
                          },
                        ),
                      ]),
                    ] else
                      CustomSectionCard('Details', [
                        Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("No details available."),
                        ),
                      ]),

                    CustomSectionCard('Metadata & Remarks', [
                      CustomSectionCardData(
                        'Posting Date',
                        formatDatetoString(_data.postingDate, 'dd-MM-yyyy') ??
                            '-',
                      ),
                      CustomSectionCardData('Remarks', _data.remarks ?? '-'),
                      CustomSectionCardData('Flag', _data.flag),
                    ]),

                    CustomSectionCard('Status & History', [
                      CustomSectionCardData('Entried By', _data.entryBy ?? '-'),
                      CustomSectionCardData(
                        'Entry Date',
                        formatDatetoString(_data.entryDate, 'dd-MM-yyyy') ??
                            '-',
                      ),
                      const Divider(),
                      CustomSectionCardData(
                        'Prepared By',
                        _data.preparedBy ?? '-',
                      ),
                      CustomSectionCardData(
                        'Prepared Date',
                        formatDatetoString(_data.preparedDate, 'dd-MM-yyyy') ??
                            '-',
                      ),
                      CustomSectionCardData(
                        'Prepared Status',
                        _data.preparedStatus ?? '-',
                      ),
                      CustomSectionCardData(
                        'Prepared Remarks',
                        _data.preparedStatusRemarks ?? '-',
                      ),
                      const Divider(),
                      CustomSectionCardData(
                        'Approved By',
                        _data.approvedBy ?? '-',
                      ),
                      CustomSectionCardData(
                        'Approved Date',
                        formatDatetoString(_data.approvedDate, 'dd-MM-yyyy') ??
                            '-',
                      ),
                      CustomSectionCardData(
                        'Approved Status',
                        _data.approvedStatus ?? '-',
                      ),
                      CustomSectionCardData(
                        'Approved Remarks',
                        _data.approvedStatusRemarks ?? '-',
                      ),
                    ]),

                    CustomSectionCard('Form Info', [
                      CustomSectionCardData('Form No', _data.formNo ?? '-'),
                      CustomSectionCardData(
                        'Date Issued',
                        formatDatetoString(_data.dateIssued, 'dd-MM-yyyy') ??
                            '-',
                      ),
                      CustomSectionCardData(
                        'Revision No',
                        _data.revisionNo ?? '-',
                      ),
                      CustomSectionCardData(
                        'Revision Date',
                        formatDatetoString(_data.revisionDate, 'dd-MM-yyyy') ??
                            '-',
                      ),
                    ]),
                  ],
                ),
              ),
            );
      },
    );
  }

  Widget _buildDetailItem(DryFractionationDetailEntity detail, int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            "Filtration Cycle #${detail.filtrationCycleNumber}",
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        const Divider(),
        CustomSectionCardData(
          'Filtration Date',
          formatDatetoString(_data.date, 'dd MMMM yyyy') ?? '',
        ),
        CustomSectionCardData(
          'Filtration Temp',
          '${detail.filtrationTemp ?? '-'}',
        ),
        CustomSectionCardData(
          'Time Start',
          formatTimeOfDay(detail.timeStartFiltration),
        ),
        CustomSectionCardData(
          'Time End',
          formatTimeOfDay(detail.timeEndFiltration) ?? '-',
        ),
        CustomSectionCardData('Load', '${detail.load ?? '-'}'),

        const SizedBox(height: 8),
        const Text(
          "Olein Analysis",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
        ),
        const Divider(height: 4),
        CustomSectionCardData('Olein IV', '${detail.oleinIv ?? '-'}'),
        CustomSectionCardData('Olein CP', '${detail.oleinCp ?? '-'}'),
        CustomSectionCardData('Olein FFA', '${detail.oleinFfa ?? '-'}'),
        CustomSectionCardData('Olein Color', '${detail.oleinColorRed ?? '-'}'),

        const SizedBox(height: 8),
        const Text(
          "Stearin Analysis",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueGrey),
        ),
        const Divider(height: 4),
        CustomSectionCardData('Stearin IV', '${detail.stearinIv ?? '-'}'),
        CustomSectionCardData('Stearin FFA', '${detail.stearinFfa ?? '-'}'),
        CustomSectionCardData(
          'Stearin Color',
          '${detail.stearinColorRed ?? '-'}',
        ),
        CustomSectionCardData('Stearin PV', '${detail.stearinPv ?? '-'}'),
      ],
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
        if (_data?.preparedStatus == null && _data.isCompleted == false)
          IconButton(
            onPressed: () async {
              final result = await Navigator.push<
                DryFractionationHeaderEntity
              >(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          DryFractionationEditPage(
                            data: _data!,
                          ),
                ),
              );
              if (!mounted) return;
              if (result != null) {
                setState(() {
                  _data = result;
                });
              }
            },
            icon: const Icon(Icons.edit),
          ),
          if (_data?.preparedStatus == null && _data.isCompleted == false)
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
                          id: _data.id ?? '',
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

  Future<bool> _approveRejectReport(String status) async {
    final user = context.read<UserProvider>();

    var isSuccess = await context
        .read<AnalyticalResultIncomingMaterialByVesselProvider>()
        .updateApproveRejectReport(
          id: _data.id,
          userName: user.currentUser!.username,
          status: status,
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
