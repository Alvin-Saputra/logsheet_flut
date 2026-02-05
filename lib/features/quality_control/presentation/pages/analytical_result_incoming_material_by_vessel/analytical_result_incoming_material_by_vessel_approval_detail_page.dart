import 'dart:developer';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/app_roles.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_header_entity.dart';
import 'package:logsheet_app/core/widgets/custom_remark_field.dart';
import 'package:logsheet_app/core/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/daily_quality_composite_fractionation/daily_quality_composite_fractionation_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AnalyticalResultIncomingMaterialByVesseApprovalDetailPage
    extends StatefulWidget {
  AnalyticalResultIncomingMaterialByVesseApprovalDetailPage({
    super.key,
    required this.data,
  });

  final AnalyticalResultIncomingMaterialByVesselHeaderEntity data;

  @override
  State<AnalyticalResultIncomingMaterialByVesseApprovalDetailPage>
  createState() =>
      _AnalyticalResultIncomingMaterialByVesseApprovalDetailPageState();
}

class _AnalyticalResultIncomingMaterialByVesseApprovalDetailPageState
    extends State<AnalyticalResultIncomingMaterialByVesseApprovalDetailPage> {
  final TextEditingController remarkController = TextEditingController();
  final PageController detailPageControllers = PageController();
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {});
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
                          _buildInfoCard(
                            'Date',
                            _formatDateString(
                              widget.data.transactionDate.toString(),
                            ),
                          ),
                        ],
                      ),
                    ),

                    _buildSection('General Information', [
                      _buildDataRow('ID', widget.data.id ?? ''),
                    ]),

                    _buildSection('Analytical Information', [
                      _buildDataRow('Material', widget.data.material ?? '-'),
                      _buildDataRow(
                        'Arrival',
                        formatDatetoString(widget.data.arrival, "yyyy-MM-dd") ??
                            '-',
                      ),
                      _buildDataRow(
                        'Quantity',
                        widget.data.quantity?.toString() ?? '-',
                      ),
                      _buildDataRow('Supplier', widget.data.supplier ?? '-'),
                      _buildDataRow("Ship's Name", widget.data.shipName ?? '-'),
                      _buildDataRow(
                        'Contract/DO No',
                        widget.data.contractDoNomor ?? '-',
                      ),
                      _buildDataRow('FFA', widget.data.ffa?.toString() ?? '-'),
                      _buildDataRow('M&I', widget.data.mni?.toString() ?? '-'),
                      _buildDataRow(
                        'Dobi',
                        widget.data.dobi?.toString() ?? '-',
                      ),
                      _buildDataRow(
                        'Others',
                        widget.data.others?.toString() ?? '-',
                      ),
                    ]),

                    SizedBox(height: 12.0),
                    if (widget.data.details.isNotEmpty) ...[
                      _buildSection('Details', [
                        Center(
                          child: SmoothPageIndicator(
                            controller:
                                detailPageControllers, // Gunakan satu controller untuk semua
                            count: widget.data.details.length,
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
                            itemCount: widget.data.details.length,
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
                                  _buildSection("Palka S", [
                                    _buildDataRow(
                                      'Palka S No',
                                      widget.data.details[pageIndex].palkaSNo
                                              ?.toString() ??
                                          '-',
                                    ),
                                    _buildDataRow(
                                      'Palka S FFA',
                                      widget.data.details[pageIndex].palkaSFfa
                                              ?.toString() ??
                                          '-',
                                    ),
                                    _buildDataRow(
                                      'Palka S IV',
                                      widget.data.details[pageIndex].palkaSIv
                                              ?.toString() ??
                                          '-',
                                    ),
                                    _buildDataRow(
                                      'Palka S M&I',
                                      widget.data.details[pageIndex].palkaSMni
                                              ?.toString() ??
                                          '-',
                                    ),
                                    _buildDataRow(
                                      'Palka S Dobi',
                                      widget.data.details[pageIndex].palkaSDobi
                                              ?.toString() ??
                                          '-',
                                    ),
                                  ]),

                                  const SizedBox(height: 8),
                                  const Divider(),

                                  // --- Section PALKA S ---
                                  _buildSection("Palka C", [
                                    _buildDataRow(
                                      'Palka C No',
                                      widget.data.details[pageIndex].palkaCNo
                                              ?.toString() ??
                                          '-',
                                    ),
                                    _buildDataRow(
                                      'Palka C FFA',
                                      widget.data.details[pageIndex].palkaCFfa
                                              ?.toString() ??
                                          '-',
                                    ),
                                    _buildDataRow(
                                      'Palka C IV',
                                      widget.data.details[pageIndex].palkaCIv
                                              ?.toString() ??
                                          '-',
                                    ),
                                    _buildDataRow(
                                      'Palka C M&I',
                                      widget.data.details[pageIndex].palkaCMni
                                              ?.toString() ??
                                          '-',
                                    ),
                                    _buildDataRow(
                                      'Palka C Dobi',
                                      widget.data.details[pageIndex].palkaCDobi
                                              ?.toString() ??
                                          '-',
                                    ),
                                  ]),

                                  const SizedBox(height: 8),
                                  const Divider(),

                                  // --- FORM PALKA P ---
                                  _buildSection("Palka P", [
                                    _buildDataRow(
                                      'Palka P No',
                                      widget.data.details[pageIndex].palkaPNo
                                              ?.toString() ??
                                          '-',
                                    ),
                                    _buildDataRow(
                                      'Palka P FFA',
                                      widget.data.details[pageIndex].palkaPFfa
                                              ?.toString() ??
                                          '-',
                                    ),
                                    _buildDataRow(
                                      'Palka P IV',
                                      widget.data.details[pageIndex].palkaPIv
                                              ?.toString() ??
                                          '-',
                                    ),
                                    _buildDataRow(
                                      'Palka P M&I',
                                      widget.data.details[pageIndex].palkaPMni
                                              ?.toString() ??
                                          '-',
                                    ),
                                    _buildDataRow(
                                      'Palka P Dobi',
                                      widget.data.details[pageIndex].palkaPDobi
                                              ?.toString() ??
                                          '-',
                                    ),
                                  ]),
                                ],
                              );
                            },
                          ),
                        ),
                      ]),
                    ] else ...[
                      // 2. Fallback if no data exists
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            "Tidak ada detail data",
                            style: TextStyle(color: Colors.grey),
                          ),
                        ),
                      ),
                    ],

                    _buildSection('Palka Component Analysis Result', [
                      _buildDataRow(
                        'FFA (as Palmitic) %',
                        widget.data.hasilAnalisaFfa.toString() ?? '',
                      ),
                      _buildDataRow(
                        'IV (Wijs), grl2/100gr',
                        widget.data.hasilAnalisaIv.toString() ?? '',
                      ),
                      _buildDataRow(
                        'Moisture %',
                        widget.data.hasilAnalisaMoisture.toString() ?? '',
                      ),
                      _buildDataRow(
                        'DOBI',
                        widget.data.hasilAnalisaDobi.toString() ?? '',
                      ),
                      _buildDataRow(
                        "PV, meqO2/kg",
                        widget.data.hasilAnalisaAnv.toString() ?? '',
                      ),
                    ]),

                    _buildSection('Remarks', [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.data?.remarks ?? '',
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
                        if (widget.data.preparedStatus == "Approved" &&
                            widget.data.approvedStatus == "Approved") ...[
                          Text(
                            "Checklist Approved",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                        ] else if (widget.data.preparedStatus == "Rejected" ||
                            widget.data.approvedStatus == "Rejected") ...[
                          Text(
                            "Checklist Rejected",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ] else if (AppRoles.qualityControlManagerApproval
                            .contains(userProvider.currentUser?.role)) ...[
                          if (widget.data.preparedStatus == "Approved" &&
                              widget.data.approvedStatus == null) ...[
                            Text('Approved Status:'),
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
                          ] else if (widget.data.preparedStatus == null) ...[
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
                          if (widget.data.approvedStatus == null) ...[
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
    );
  }

  Future<bool> _approveRejectReport(String status) async {
    final user = context.read<UserProvider>();

    var isSuccess = await context
        .read<AnalyticalResultIncomingMaterialByVesselProvider>()
        .updateApproveRejectReport(
          id: widget.data.id,
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
