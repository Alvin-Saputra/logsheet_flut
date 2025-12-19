import 'dart:developer';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/core/widgets/custom_confirmation_dialog.dart';
import 'package:logsheet_app/core/widgets/custom_info_card.dart';
import 'package:logsheet_app/core/widgets/custom_remark_field.dart';
import 'package:logsheet_app/core/widgets/custom_section_card.dart';
import 'package:logsheet_app/core/widgets/custom_section_card_data.dart';
import 'package:logsheet_app/core/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/analytical_with_certificate_of_analysis_header_entity.dart';
import 'package:logsheet_app/features/quality_control/presentation/pages/analytical_result_incoming_plant_chemical_ingredient/analytical_result/analytical_result_incoming_plant_chemical_ingredient_edit_page.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_incoming_plant_chemical_ingredient/analytical_result/analytical_result_incoming_plant_chemical_ingredient_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/daily_quality_composite_fractionation/daily_quality_composite_fractionation_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AnalyticalResultIncomingPlantChemicalIngredientApprovalDetailPage
    extends StatefulWidget {
  AnalyticalResultIncomingPlantChemicalIngredientApprovalDetailPage({
    super.key,
    required this.data,
  });

  final AnalyticalWithCertificateOfAnalysisHeaderEntity data;

  @override
  State<AnalyticalResultIncomingPlantChemicalIngredientApprovalDetailPage>
  createState() =>
      _AnalyticalResultIncomingPlantChemicalIngredientApprovalDetailPageState();
}

class _AnalyticalResultIncomingPlantChemicalIngredientApprovalDetailPageState
    extends
        State<
          AnalyticalResultIncomingPlantChemicalIngredientApprovalDetailPage
        > {
  final PageController detailPageControllers = PageController();
  final TextEditingController remarkController = TextEditingController();
  late AnalyticalWithCertificateOfAnalysisHeaderEntity _data;

  final PageController mainPageController = PageController();
  int currentMainPage = 0;
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
    return Consumer<AnalyticalResultIncomingPlantChemicalIngredientProvider>(
      builder: (
        BuildContext context,
        AnalyticalResultIncomingPlantChemicalIngredientProvider provider,
        Widget? child,
      ) {
        return (provider.isLoadingEdit)
            ? const Center(child: CircularProgressIndicator())
            : SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 12.0,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          CustomInfoCard(
                            'Date',
                            formatDatetoString(
                                  _data.analytical.date,
                                  'dd MMMM yyyy',
                                ) ??
                                '',
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      SmoothPageIndicator(
                        controller: mainPageController,
                        count: 2,
                        effect: const WormEffect(
                          dotHeight: 8,
                          dotWidth: 8,
                          activeDotColor: Colors.blue,
                          dotColor: Colors.grey,
                        ),
                        onDotClicked: (index) {
                          mainPageController.animateToPage(
                            index,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        },
                      ),
                      const SizedBox(height: 12),
                      ExpandablePageView(
                        controller: mainPageController,
                        onPageChanged: (index) {
                          setState(() {
                            currentMainPage = index;
                          });
                        },
                        children: [
                          _buildAnalyticalPage(context),
                          _buildCoaPage(context),
                        ],
                      ),

                      if ((AppRoles.leadQC.contains(
                            userProvider.currentUser?.role,
                          )) ||
                          (AppRoles.qualityControlManagerApproval.contains(
                            userProvider.currentUser?.role,
                          )))
                        CustomSectionCard('Approval Actions', [
                          if (widget.data.analytical.preparedStatus ==
                                  "approved" &&
                              widget.data.analytical.approvedStatus ==
                                  "approved") ...[
                            Text(
                              "Checklist Approved",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ] else if (widget.data.analytical.preparedStatus ==
                                  "rejected" ||
                              widget.data.analytical.approvedStatus ==
                                  "rejected") ...[
                            Text(
                              "Checklist Rejected",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                          ] else if (AppRoles.qualityControlManagerApproval
                              .contains(userProvider.currentUser?.role)) ...[
                            if (widget.data.analytical.preparedStatus ==
                                    "approved" &&
                                widget.data.analytical.approvedStatus ==
                                    null) ...[
                              Text('Approved Status:'),
                              SizedBox(height: 8.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
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
                                                "approved",
                                              );
                                          if (isSuccess) {
                                            showSnackBar(
                                              "Berhasil Approve Checklist",
                                              this.context,
                                            );
                                            Navigator.of(this.context).pop();
                                            log("Sukses Approve");
                                          } else {
                                            showSnackBar(
                                              "Gagal Approve Checklist",
                                              this.context,
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
                            ] else if (widget.data.analytical.preparedStatus ==
                                null) ...[
                              Text(
                                "Waiting Approval From Leader QC...",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ] else if (AppRoles.leadQC.contains(
                            userProvider.currentUser?.role,
                          )) ...[
                            if (widget.data.analytical.approvedStatus ==
                                null) ...[
                              Text(
                                "Waiting Apprvoal From Manager QC...",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange,
                                ),
                              ),
                            ],
                          ],
                        ]),
                    ],
                  ),
                ),
              ),
            );
      },
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
        IconButton(
          icon: const Icon(Icons.delete_rounded, color: Colors.red),
          onPressed: () {
            final provider =
                context
                    .read<
                      AnalyticalResultIncomingPlantChemicalIngredientProvider
                    >();

            customConfirmationDialog(
              context: context,
              title: 'Delete Report',
              message:
                  'Are you sure you want to delete this report? This action cannot be undone.',
              onConfirm: () async {
                final success = await provider.deleteReport(
                  id: _data.analytical.id ?? '',
                );

                if (!context.mounted) return false;

                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Report deleted successfully.'),
                      backgroundColor: Colors.green,
                    ),
                  );
                  Navigator.of(context).pop(); // tutup halaman detail
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Failed to delete report.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
                return success;
              },
            );
          },
        ),

        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) =>
                        AnalyticalResultIncomingPlantChemicalIngredientEditPage(
                          data: widget.data,
                        ),
              ),
            );
          },
          icon: const Icon(Icons.edit_rounded, color: Colors.red),
        ),
      ],
    );
  }

  Widget _buildAnalyticalPage(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 36),
      child: Column(
        children: [
          CustomSectionCard('Analytical Information', [
            CustomSectionCardData('Material', _data.analytical.material ?? ''),
            CustomSectionCardData('Supplier', _data.analytical.supplier ?? ''),
          ]),

          _buildAnalyticalDetailPager(),
        ],
      ),
    );
  }

  Widget _buildCoaPage(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 36),
      child: Column(
        children: [
          CustomSectionCard('COA Information', [
            CustomSectionCardData('Material', _data.coa.product ?? ''),
            CustomSectionCardData('Supplier', _data.coa.lotNo ?? ''),
          ]),

          _buildCOADetailPager(),
        ],
      ),
    );
  }

  Widget _buildCOADetailPager() {
    return CustomSectionCard("COA Details", [
      Center(
        child: SmoothPageIndicator(
          controller:
              detailPageControllers, // Gunakan satu controller untuk semua
          count: widget.data.coa.details.length,
          effect: const WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Colors.blue, // Sesuaikan warna tema Anda
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

      SizedBox(height: 12.0),

      SizedBox(
        child: ExpandablePageView.builder(
          controller: detailPageControllers,
          itemCount: widget.data.coa.details.length,
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

                CustomSectionCard("Details", [
                  CustomSectionCardData(
                    'Parameters',
                    widget.data.coa.details[pageIndex].parameter.toString() ??
                        '',
                  ),
                  CustomSectionCardData(
                    'Actual Min',
                    widget.data.coa.details[pageIndex].actualMin.toString() ??
                        '',
                  ),
                  CustomSectionCardData(
                    'Actual Max',
                    widget.data.coa.details[pageIndex].actualMax.toString() ??
                        '',
                  ),
                  CustomSectionCardData(
                    'Standard Min',
                    widget.data.coa.details[pageIndex].standardMin.toString() ??
                        '',
                  ),
                  CustomSectionCardData(
                    'Standard Max',
                    widget.data.coa.details[pageIndex].standardMax.toString() ??
                        '',
                  ),
                  CustomSectionCardData(
                    'Method',
                    widget.data.coa.details[pageIndex].method.toString() ?? '',
                  ),
                ]),
              ],
            );
          },
        ),
      ),
    ]);
  }

  Widget _buildAnalyticalDetailPager() {
    return CustomSectionCard("Analytical Details", [
      Center(
        child: SmoothPageIndicator(
          controller:
              detailPageControllers, // Gunakan satu controller untuk semua
          count: widget.data.analytical.details.length,
          effect: const WormEffect(
            dotHeight: 8,
            dotWidth: 8,
            activeDotColor: Colors.blue, // Sesuaikan warna tema Anda
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

      SizedBox(height: 12.0),

      SizedBox(
        child: ExpandablePageView.builder(
          controller: detailPageControllers,
          itemCount: widget.data.analytical.details.length,
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

                CustomSectionCard("Details", [
                  CustomSectionCardData(
                    'Parameter',
                    widget.data.analytical.details[pageIndex].parameter
                            .toString() ??
                        '',
                  ),
                  CustomSectionCardData(
                    'Result Min',
                    widget.data.analytical.details[pageIndex].resultMin
                            .toString() ??
                        '',
                  ),
                  CustomSectionCardData(
                    'Result Max',
                    widget.data.analytical.details[pageIndex].resultMax
                            .toString() ??
                        '',
                  ),
                  CustomSectionCardData(
                    'Specification Min',
                    widget.data.analytical.details[pageIndex].specificationMin
                            .toString() ??
                        '',
                  ),
                  CustomSectionCardData(
                    'Specification Max',
                    widget.data.analytical.details[pageIndex].specificationMax
                            .toString() ??
                        '',
                  ),
                  CustomSectionCardData(
                    'Status',
                    (widget.data.analytical.details[pageIndex].statusOk) == 'y'
                        ? 'OK'
                        : 'Not OK',
                  ),
                  CustomSectionCardData(
                    'Remark',
                    widget.data.analytical.details[pageIndex].remark
                            .toString() ??
                        '',
                  ),
                ]),
              ],
            );
          },
        ),
      ),
    ]);
  }

  Future<bool> _approveRejectReport(String status) async {
    var isSuccess = await context
        .read<AnalyticalResultIncomingPlantChemicalIngredientProvider>()
        .updateApproveRejectReport(
          id: _data.analytical.id,
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
                        bool isSuccess = await _approveRejectReport("rejected");
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
}
