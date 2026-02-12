import 'dart:developer';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_header_entity.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/daily_quality_composite_fractionation/daily_quality_composite_fractionation_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AnalyticalResultIncomingMaterialByVesselReportDetailPage
    extends StatefulWidget {
  AnalyticalResultIncomingMaterialByVesselReportDetailPage({
    super.key,
    required this.data,
  });

  final AnalyticalResultIncomingMaterialByVesselHeaderEntity data;

  @override
  State<AnalyticalResultIncomingMaterialByVesselReportDetailPage>
  createState() =>
      _AnalyticalResultIncomingMaterialByVesselReportDetailPageState();
}

class _AnalyticalResultIncomingMaterialByVesselReportDetailPageState
    extends State<AnalyticalResultIncomingMaterialByVesselReportDetailPage> {
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
                      _buildDataRow(
                        "Totox",
                        widget.data.hasilAnalisaTotox?.toString() ?? '-',
                      ),
                      _buildDataRow(
                        "Carotex",
                        widget.data.hasilAnalisaCarotex?.toString() ?? '-',
                      ),
                      _buildDataRow(
                        "Mineral Oil",
                        widget.data.hasilAnalisaMineralOil?.toString() ?? '-',
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
            Consumer<AnalyticalResultIncomingMaterialByVesselProvider>(
              builder: (
                BuildContext context,
                AnalyticalResultIncomingMaterialByVesselProvider provider,
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
                            parentContext
                                .read<
                                  AnalyticalResultIncomingMaterialByVesselProvider
                                >();

                        final isSuccess = await provider.deleteReport(
                          id: widget.data.id ?? '',
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
