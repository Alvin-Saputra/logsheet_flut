import 'dart:developer';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/core/widgets/custom_confirmation_dialog.dart';
import 'package:logsheet_app/core/widgets/custom_info_card.dart';
import 'package:logsheet_app/core/widgets/custom_section_card.dart';
import 'package:logsheet_app/core/widgets/custom_section_card_data.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_truck/analytical_result_incoming_material_by_truck_header_entity.dart';
import 'package:logsheet_app/core/widgets/custom_remark_field.dart';
import 'package:logsheet_app/core/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_outgoing_shipment_product_by_truck/analytical_result_outgoing_shipment_product_by_truck_header_entity.dart';
import 'package:logsheet_app/features/quality_control/presentation/pages/analytical_result_incoming_material_by_truck/analytical_result_incoming_material_by_truck_edit_page.dart';
import 'package:logsheet_app/features/quality_control/presentation/pages/analytical_result_outgoing_shipment_product_by_truck/analytical_result_outgoing_shipment_product_by_truck_edit_page.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_outgoing_shipment_product_by_truck/analytical_result_outgoing_shipment_product_by_truck_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/daily_quality_composite_fractionation/daily_quality_composite_fractionation_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AnalyticalResultOutgoingShipmentProductByTruckListDetailPage
    extends StatefulWidget {
  AnalyticalResultOutgoingShipmentProductByTruckListDetailPage({
    super.key,
    required this.data,
  });

  final AnalyticalResultOutgoingShipmentProductByTruckHeaderEntity data;

  @override
  State<AnalyticalResultOutgoingShipmentProductByTruckListDetailPage>
  createState() =>
      _AnalyticalResultOutgoingShipmentProductByTruckListDetailPageState();
}

class _AnalyticalResultOutgoingShipmentProductByTruckListDetailPageState
    extends
        State<AnalyticalResultOutgoingShipmentProductByTruckListDetailPage> {
  final TextEditingController remarkController = TextEditingController();
  final PageController detailPageControllers = PageController();
  late AnalyticalResultOutgoingShipmentProductByTruckHeaderEntity _data;
  @override
  void initState() {
    super.initState();
    _data = widget.data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: Consumer<AnalyticalResultOutgoingShipmentProductByTruckProvider>(
        builder: (
          BuildContext context,
          AnalyticalResultOutgoingShipmentProductByTruckProvider value,
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
    return Consumer<AnalyticalResultOutgoingShipmentProductByTruckProvider>(
      builder: (
        BuildContext context,
        AnalyticalResultOutgoingShipmentProductByTruckProvider provider,
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
                        children: [CustomInfoCard('ID', _data.id)],
                      ),
                    ),

                    CustomSectionCard('Analytical Information', [
                      CustomSectionCardData('Company', _data.company),
                      CustomSectionCardData('Plant', _data.plant),
                      CustomSectionCardData(
                        'Product Name',
                        _data.productName ?? '',
                      ),
                      CustomSectionCardData(
                        'Loading Date',
                        formatDatetoString(_data.loadingDate, 'dd-MM-yyyy') ??
                            '',
                      ),

                      CustomSectionCardData(
                        'Quantity',
                        _data.quantity?.toString() ?? '-',
                      ),
                      CustomSectionCardData(
                        "Ship's Name",
                        _data.shipsName ?? '',
                      ),
                      CustomSectionCardData(
                        'Destination',
                        _data.destination ?? '',
                      ),
                      CustomSectionCardData('Load Port', _data.loadPort ?? ''),
                    ]),

                    SizedBox(height: 12.0),
                    CustomSectionCard(
                      'Details',
                      (_data.details.isEmpty)
                          ? [
                            const Padding(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: Text(
                                  'No detail data available',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                            ),
                          ]
                          : [
                            Center(
                              child: SmoothPageIndicator(
                                controller:
                                    detailPageControllers, // Gunakan satu controller untuk semua
                                count: _data.details.length,
                                effect: const WormEffect(
                                  dotHeight: 8,
                                  dotWidth: 8,
                                  activeDotColor:
                                      Colors.blue, // Sesuaikan warna tema Anda
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
                                itemCount: _data.details.length,
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

                                      // --- Section PALKA S ---
                                      CustomSectionCard("Details", [
                                        CustomSectionCardData(
                                          "Ship's Tank",
                                          _data.details[pageIndex].shipsTank ??
                                              '',
                                        ),
                                        CustomSectionCardData(
                                          'No Police',
                                          _data.details[pageIndex].noPolice ??
                                              '',
                                        ),
                                        CustomSectionCardData(
                                          'FFA (%)',
                                          parseDouble(
                                                _data.details[pageIndex].ffa,
                                              ).toString() ??
                                              '',
                                        ),
                                        CustomSectionCardData(
                                          'MNI (%)',
                                          parseDouble(
                                                _data.details[pageIndex].mni,
                                              ).toString() ??
                                              '',
                                        ),
                                        CustomSectionCardData(
                                          'IV (grl2/100gr)',
                                          parseDouble(
                                                _data.details[pageIndex].iv,
                                              ).toString() ??
                                              '',
                                        ),
                                        CustomSectionCardData(
                                          'LoviBond Color (Red)',
                                          parseDouble(
                                                _data
                                                    .details[pageIndex]
                                                    .lovibondColorRed,
                                              ).toString() ??
                                              '',
                                        ),
                                        CustomSectionCardData(
                                          'LoviBond Color (Yellow)',
                                          parseDouble(
                                                _data
                                                    .details[pageIndex]
                                                    .lovibondColorYellow,
                                              ).toString() ??
                                              '',
                                        ),
                                        CustomSectionCardData(
                                          'PV (meqO2/kg)',
                                          parseDouble(
                                                _data.details[pageIndex].pv,
                                              ).toString() ??
                                              '',
                                        ),
                                        CustomSectionCardData(
                                          'Other',
                                          _data.details[pageIndex].other ?? '',
                                        ),
                                        CustomSectionCardData(
                                          'remark',
                                          _data.details[pageIndex].remark ?? '',
                                        ),
                                      ]),
                                    ],
                                  );
                                },
                              ),
                            ),
                          ],
                    ),

                    if ((AppRoles.leadQC.contains(
                          userProvider.currentUser?.role,
                        )) ||
                        (AppRoles.qualityControlManagerApproval.contains(
                          userProvider.currentUser?.role,
                        )))
                      CustomSectionCard('Approval Actions', [
                        if (_data.correctedStatus == "Approved" &&
                            _data.approvedStatus == "Approved") ...[
                          Text(
                            "Checklist Approved",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ] else if (_data.correctedStatus == "Rejected" ||
                            _data.approvedStatus == "Rejected") ...[
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
                          if (_data.correctedStatus == null) ...[
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
                          ] else if (_data.correctedStatus != null &&
                              _data.approvedStatus == null) ...[
                            Text(
                              "Waiting Apprvoal From Manager QC...",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ],
                        ] else if (AppRoles.qualityControlManagerApproval
                            .contains(userProvider.currentUser?.role)) ...[
                          if (_data.approvedStatus == null) ...[
                            Text(
                              "Waiting Apprvoal From Leader QC...",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                          ] else if (_data.correctedStatus == "Approved" ||
                              _data.approvedStatus == "Rejected") ...[
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

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      title: const Text(
        'Analytical Result of Out Going Shipment Product By Truck Detail',
        style: TextStyle(color: Color(0xFF655F5B), fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      iconTheme: const IconThemeData(color: Colors.black),
      actions: [
        if (_data?.correctedStatus == null)
          IconButton(
            onPressed: () async {
              final result = await Navigator.push<
                AnalyticalResultOutgoingShipmentProductByTruckHeaderEntity
              >(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          AnalyticalResultOutgoingShipmentProductByTruckEditPage(
                            data: _data,
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

        IconButton(
          onPressed: () async {
            final provider =
                context
                    .read<
                      AnalyticalResultOutgoingShipmentProductByTruckProvider
                    >();

            customConfirmationDialog(
              context: context,
              title: 'Delete Report',
              message:
                  'Are you sure you want to delete this report? This action cannot be undone.',
              onConfirm: () async {
                final success = await provider.deleteReport(id: _data.id ?? '');

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
          icon: const Icon(Icons.delete_rounded, color: Colors.red),
        ),
      ],
    );
  }

  Future<bool> _approveRejectReport(String status) async {
    var isSuccess = await context
        .read<AnalyticalResultOutgoingShipmentProductByTruckProvider>()
        .updateApproveRejectReport(
          id: _data.id,
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
