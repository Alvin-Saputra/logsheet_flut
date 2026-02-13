import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_truck/analytical_result_incoming_material_by_truck_header_entity.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/daily_quality_composite_fractionation/daily_quality_composite_fractionation_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AnalyticalResultIncomingMaterialByTruckReportDetailPage
    extends StatefulWidget {
  AnalyticalResultIncomingMaterialByTruckReportDetailPage({
    super.key,
    required this.data,
  });

  final AnalyticalResultIncomingMaterialByTruckHeaderEntity data;

  @override
  State<AnalyticalResultIncomingMaterialByTruckReportDetailPage>
  createState() =>
      _AnalyticalResultIncomingMaterialByTruckReportDetailPageState();
}

class _AnalyticalResultIncomingMaterialByTruckReportDetailPageState
    extends State<AnalyticalResultIncomingMaterialByTruckReportDetailPage> {
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
                            'Transaction Date',
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
                      _buildDataRow('Material', widget.data.material ?? ''),
                      _buildDataRow(
                        'Arrival',
                        formatDatetoString(
                              widget.data.arrival!,
                              'dd-MM-yyyy',
                            ) ??
                            '',
                      ),

                      _buildDataRow('Supplier', widget.data.supplier ?? ''),
                      _buildDataRow(
                        "Vessel/Vehicle",
                        widget.data.vesselVehicle ?? '',
                      ),
                      _buildDataRow(
                        'Contract/DO No',
                        widget.data.contractDoNomor ?? '',
                      ),
                      _buildDataRow('FFA', widget.data.ssFfa.toString() ?? ''),
                      _buildDataRow('M&I', widget.data.ssMni.toString() ?? ''),
                      _buildDataRow('Others', widget.data.ssOthers ?? ''),
                    ]),

                    SizedBox(height: 12.0),
                    _buildSection('Details', [
                      // 1. Check if details exist before building the pager
                      if (widget.data.details.isNotEmpty) ...[
                        Center(
                          child: SmoothPageIndicator(
                            controller: detailPageControllers,
                            count: widget.data.details.length,
                            effect: const WormEffect(
                              dotHeight: 8,
                              dotWidth: 8,
                              activeDotColor: Colors.blue,
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
                        const SizedBox(height: 12.0),
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
                                  _buildSection("Details", [
                                    _buildDataRow(
                                      'No',
                                      widget.data.details[pageIndex].no
                                          .toString(),
                                    ),
                                    _buildDataRow(
                                      'Sampling Date',
                                      formatDatetoString(
                                            widget
                                                .data
                                                .details[pageIndex]
                                                .samplingDate!,
                                            'dd-MM-yyyy',
                                          ) ??
                                          '',
                                    ),
                                    _buildDataRow(
                                      'Police No',
                                      widget.data.details[pageIndex].policeNo ??
                                          '',
                                    ),
                                    _buildDataRow(
                                      'FFA',
                                      widget.data.details[pageIndex].pFfa
                                          .toString(),
                                    ),
                                    _buildDataRow(
                                      'Moisture',
                                      widget.data.details[pageIndex].pMoisture
                                          .toString(),
                                    ),
                                    _buildDataRow(
                                      'IV',
                                      widget.data.details[pageIndex].pIv
                                          .toString(),
                                    ),
                                    _buildDataRow(
                                      'DOBI',
                                      widget.data.details[pageIndex].pDobi
                                          .toString(),
                                    ),
                                    _buildDataRow(
                                      'PV',
                                      widget.data.details[pageIndex].pPv
                                          .toString(),
                                    ),
                                    _buildDataRow(
                                      'Color R',
                                      widget.data.details[pageIndex].pColorR
                                          .toString(),
                                    ),
                                    _buildDataRow(
                                      'Color Y',
                                      widget.data.details[pageIndex].pColorY
                                          .toString(),
                                    ),
                                    _buildDataRow(
                                      'Analis',
                                      widget.data.details[pageIndex].analis ??
                                          '',
                                    ),
                                    _buildDataRow(
                                      'Remarks',
                                      widget.data.details[pageIndex].remarks ??
                                          '',
                                    ),
                                  ]),
                                ],
                              );
                            },
                          ),
                        ),
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
        'Analytical Result Incoming Material By Truck Detail',
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
