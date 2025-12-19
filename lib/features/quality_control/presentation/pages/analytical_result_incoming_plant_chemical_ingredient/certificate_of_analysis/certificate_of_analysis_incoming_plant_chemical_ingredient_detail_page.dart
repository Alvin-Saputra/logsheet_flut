import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/certificate_of_analysis_incoming_plant_chemical_ingredient_header_entity.dart';
import 'package:logsheet_app/features/quality_control/presentation/pages/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/certificate_of_analysis_incoming_plant_chemical_ingredient_edit_page.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_incoming_material_by_truck/analytical_result_incoming_material_by_truck_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/daily_quality_composite_fractionation/daily_quality_composite_fractionation_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CertificateOfAnalysisIncomingPlantChemicalIngredientDetailPage
    extends StatefulWidget {
  CertificateOfAnalysisIncomingPlantChemicalIngredientDetailPage({
    super.key,
    required this.data,
  });

  final CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderEntity data;

  @override
  State<CertificateOfAnalysisIncomingPlantChemicalIngredientDetailPage>
  createState() =>
      _CertificateOfAnalysisIncomingPlantChemicalIngredientDetailPageState();
}

class _CertificateOfAnalysisIncomingPlantChemicalIngredientDetailPageState
    extends
        State<CertificateOfAnalysisIncomingPlantChemicalIngredientDetailPage> {
  final PageController detailPageControllers = PageController();
  late CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderEntity _data;
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
    return Consumer<AnalyticalResultIncomingMaterialByTruckProvider>(
      builder: (
        BuildContext context,
        AnalyticalResultIncomingMaterialByTruckProvider provider,
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
                            formatDatetoString(
                                  _data.tanggalPengiriman,
                                  'dd MMMM yyyy',
                                ) ??
                                '',
                          ),
                        ],
                      ),
                    ),

                    _buildSection('General Information', [
                      _buildDataRow('ID', _data.id ?? ''),
                    ]),

                    _buildSection('Analytical Information', [
                      _buildDataRow('Material', _data.product ?? ''),

                      _buildDataRow('Supplier', _data.grade ?? ''),
                      _buildDataRow("Vessel/Vehicle", _data.vehicle ?? ''),
                      _buildDataRow('Contract/DO No', _data.noDoc ?? ''),
                    ]),

                    SizedBox(height: 12.0),
                    _buildSection('Details', [
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

                                _buildSection("Details", [
                                  _buildDataRow(
                                    'No',
                                    [pageIndex].toString() ?? '',
                                  ),
                                  _buildDataRow(
                                    'Parameters',
                                    _data.details[pageIndex].parameter ?? '',
                                  ),

                                  _buildDataRow(
                                    'Actual Min',
                                    _data.details[pageIndex].actualMax
                                            .toString() ??
                                        '',
                                  ),

                                  _buildDataRow(
                                    'Actual Max',
                                    _data.details[pageIndex].actualMin
                                            .toString() ??
                                        '',
                                  ),

                                  _buildDataRow(
                                    'Standard Min',
                                    _data.details[pageIndex].standardMin
                                            .toString() ??
                                        '',
                                  ),

                                  _buildDataRow(
                                    'Actual Max',
                                    _data.details[pageIndex].standardMax
                                            .toString() ??
                                        '',
                                  ),

                                  _buildDataRow(
                                    'Method',
                                    _data.details[pageIndex].method
                                            .toString() ??
                                        '',
                                  ),
                                ]),
                              ],
                            );
                          },
                        ),
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
      actions: [
        IconButton(
          onPressed: () async {
            final result = await Navigator.push<
              CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderEntity
            >(
              context,
              MaterialPageRoute(
                builder:
                    (context) =>
                        CertificateOfAnalysisIncomingPlantChemicalIngredientEditPage(
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
      ],
    );
  }
}
