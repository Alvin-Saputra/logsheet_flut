import 'dart:developer';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/core/widgets/custom_date_field.dart';
import 'package:logsheet_app/core/widgets/custom_section_card.dart';
import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/product_provider.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_outgoing_shipment_product_by_truck/analytical_result_outgoing_shipment_product_by_truck_detail_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_outgoing_shipment_product_by_truck/analytical_result_outgoing_shipment_product_by_truck_header_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/daily_quality_composite_fractionation/daily_quality_composite_fractionation_entity.dart';
import 'package:logsheet_app/core/widgets/custom_hour_picker.dart';
import 'package:logsheet_app/core/widgets/custom_remark_field.dart';
import 'package:logsheet_app/core/widgets/custom_save_button.dart';
import 'package:logsheet_app/core/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/core/widgets/custom_text_field.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/business_unit_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/data_form_no_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/plant_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/value_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_outgoing_shipment_product_by_truck/analytical_result_outgoing_shipment_product_by_truck_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/daily_quality_composite_fractionation/daily_quality_composite_fractionation_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AnalyticalResultOutgoingShipmentProductByTruckInputPage
    extends StatefulWidget {
  const AnalyticalResultOutgoingShipmentProductByTruckInputPage({super.key});

  @override
  State<AnalyticalResultOutgoingShipmentProductByTruckInputPage>
  createState() =>
      _AnalyticalResultOutgoingShipmentProductByTruckInputPageState();
}

class _AnalyticalResultOutgoingShipmentProductByTruckInputPageState
    extends State<AnalyticalResultOutgoingShipmentProductByTruckInputPage> {
  DataFormNoEntity? formData;
  String? selectedBpToTank;
  String? selectedProduct;
  bool isLoading = false;
  bool breakTest = false;
  int? numberOfRows;

  final TextEditingController shipsTankController = TextEditingController();
  final TextEditingController noPoliceController = TextEditingController();
  final TextEditingController ffaController = TextEditingController();
  final TextEditingController mniController = TextEditingController();
  final TextEditingController ivController = TextEditingController();
  final TextEditingController loviBondColorRedController =
      TextEditingController();
  final TextEditingController loviBondColorYellowController =
      TextEditingController();
  final TextEditingController pvController = TextEditingController();
  final TextEditingController otherController = TextEditingController();
  final TextEditingController remarkController = TextEditingController();
  final TextEditingController loadingDateController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController shipsNameController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();
  final TextEditingController loadPortController = TextEditingController();

  final PageController pageControllers = PageController();

  List<Map<String, TextEditingController>> detailControllers = [];

  // final TextEditingController dateEntryController = TextEditingController();

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      // await context.read<ProductProvider>().fetchProducts();
      await context.read<ValueProvider>().fetchOilTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: const Color(0xFFEFF3F9),
      appBar: _buildAppBar(),
      body: _buildBody(),
    );
  }

  AppBar _buildAppBar() {
    formData =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where(
              (form) =>
                  form.isMenu == "Daily_Quality_Composite_Fractionation" &&
                  form.isActive == "T",
            )
            .first;

    log("${formData!.code}");
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 1,
      iconTheme: const IconThemeData(color: Color(0xFF655F5B)),
      title: Text(
        'Quality Report - ${formData!.code}',
        style: TextStyle(
          color: Color(0xFF655F5B),
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      actions: [IconButton(icon: const Icon(Icons.refresh), onPressed: () {})],
    );
  }

  Widget _buildBody() {
    return SafeArea(
      child: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                CustomDateField(
                  controller: loadingDateController,
                  label: 'Loading Date',
                  icon: Icons.event,
                ),
                SizedBox(height: 8.0),
                _productDropdown(
                  context: context,
                  selectedValue: selectedProduct,
                  onChanged: (String? value) {
                    setState(() {
                      selectedProduct = value;
                    });
                  },
                ),
                SizedBox(height: 8.0),
                CustomTextField(
                  controller: quantityController,
                  label: "Quantity",
                  icon: Icons.storage_rounded,
                ),

                CustomTextField(
                  controller: shipsNameController,
                  label: "Ship's Name",
                  icon: Icons.directions_ferry,
                ),

                CustomTextField(
                  controller: destinationController,
                  label: "Destination",
                  icon: Icons.place_rounded,
                ),

                CustomTextField(
                  controller: loadPortController,
                  label: "Load Port",
                  icon: Icons.pivot_table_chart_rounded,
                ),

                _detailGeneratorSection(),
                if (detailControllers.isNotEmpty) _detailFormList(),

                const SizedBox(height: 24),
                Consumer<AnalyticalResultOutgoingShipmentProductByTruckProvider>(
                  builder: (
                    BuildContext context,
                    AnalyticalResultOutgoingShipmentProductByTruckProvider provider,
                    Widget? child,
                  ) {
                    return (provider.isLoadingInput)
                        ? Center(child: CircularProgressIndicator())
                        : CustomSaveButton(
                          onPressed: () async {
                            final bool isSuccess;
                            isSuccess =
                                await _insertReport();
                            if (isSuccess == true) {
                              showSnackBar(
                                "Berhasil menyimpan data",
                                this.context,
                              );
                              Navigator.of(this.context).pop();
                            } else {
                              showSnackBar("Gagal menyimpan data", this.context);
                            }
                          },
                        );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _productDropdown({
    required BuildContext context,
    required String? selectedValue,
    required Function(String?) onChanged,
  }) {
    return Consumer<ValueProvider>(
      builder: (context, provider, child) {
        if (provider.isOilTypeLoading) {
          return DropdownButtonFormField<String>(
            value: null,
            items: const [],
            onChanged: null,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF0ECE9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              hintText: 'Loading Materials...',
              prefixIcon: const Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
          );
        }

        if (provider.oilTypeLists.isEmpty) {
          return TextFormField(
            readOnly: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFF0ECE9),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none,
              ),
              hintText: 'Materials Tidak Ditemukan',
              prefixIcon: const Padding(
                padding: EdgeInsets.all(12.0),
                child: Icon(Icons.warning_amber_rounded),
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () => context.read<ValueProvider>().fetchOilTypes(),
              ),
            ),
          );
        }

        return DropdownButtonFormField<String>(
          value: selectedValue,
          items:
              provider.oilTypeLists.map((item) {
                return DropdownMenuItem<String>(
                  value: item.name,
                  child: Text(
                    "${item.name}",
                    style: const TextStyle(fontSize: 14),
                  ),
                );
              }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            labelText: 'Product',
            filled: true,
            fillColor: const Color(0xFFF0ECE9),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            hintText: 'Pilih Material',
            prefixIcon: Icon(Icons.domain_rounded),
          ),
        );
      },
    );
  }

  void generateDetailRows(int count) {
    detailControllers.clear();

    for (int i = 0; i < count; i++) {
      detailControllers.add({
        'ships_tank_no': TextEditingController(),
        'no_police': TextEditingController(),
        'ffa': TextEditingController(),
        'mni': TextEditingController(),
        'iv': TextEditingController(),
        'lovibond_color_red': TextEditingController(),
        'lovibond_color_yellow': TextEditingController(),
        'pv': TextEditingController(),
        'other': TextEditingController(),
        'remark': TextEditingController(),
      });
    }

    setState(() {});
  }

  Widget _detailGeneratorSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Berapa detail yang ingin diinput?",
          style: TextStyle(fontSize: 14),
        ),
        SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: Container(
                width: 80,
                child: TextField(
                  keyboardType: TextInputType.number,
                  onChanged: (v) {
                    numberOfRows = int.tryParse(v);
                  },
                  decoration: InputDecoration(
                    hintText: "0",
                    filled: true,
                    fillColor: Colors.grey[200],
                  ),
                ),
              ),
            ),
            SizedBox(width: 12),
            ElevatedButton(
              onPressed: () {
                if (numberOfRows == null || numberOfRows! <= 0) return;
                generateDetailRows(numberOfRows!);
              },
              child: Text("Generate"),
            ),
          ],
        ),
      ],
    );
  }

  Widget _detailFormList() {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: SmoothPageIndicator(
                controller:
                    pageControllers, // Gunakan satu controller untuk semua
                count: detailControllers.length,
                effect: const WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.blue, // Sesuaikan warna tema Anda
                  dotColor: Colors.grey,
                ),
                onDotClicked: (index) {
                  pageControllers.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),

            SizedBox(height: 6),

            ExpandablePageView.builder(
              controller: pageControllers, // Cukup satu controller utama
              itemCount: detailControllers.length,
              itemBuilder: (context, pageIndex) {
                final row = detailControllers[pageIndex];

                // Bungkus semua form (S, C, P) dalam satu Column scrollable
                return SingleChildScrollView(
                  physics:
                      const NeverScrollableScrollPhysics(), // Biar tidak bentrok scrollnya
                  child: Column(
                    children: [
                      Text(
                        "Detail Data Ke - ${pageIndex + 1}",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(height: 12),

                      CustomSectionCard("Details Input", [
                        CustomTextField(
                          controller: row['ships_tank_no']!,
                          label: "Ship's Tank No",
                          icon: Icons.directions_ferry,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: row['no_police']!,
                          label: 'No Police',
                          icon: Icons.scoreboard,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: row['ffa']!,
                          label: 'FFA (%)',
                          icon: Icons.opacity,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: row['mni']!,
                          label: 'M&I (%)',
                          icon: Icons.opacity,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: row['iv']!,
                          label: 'IV (grl2/100gr)',
                          icon: Icons.opacity,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: row['lovibond_color_red']!,
                          label: 'Lovibond Color Red (R)',
                          icon: Icons.palette,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: row['lovibond_color_yellow']!,
                          label: 'Lovibond Color Yellow (Y)',
                          icon: Icons.color_lens_rounded,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: row['pv']!,
                          label: 'PV',
                          icon: Icons.opacity,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: row['other']!,
                          label: 'Other',
                          icon: Icons.more_horiz,
                          isNumeric: true,
                        ),
                        CustomRemarkField(controller: row['remark']!),
                      ]),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> _insertReport() async {
    final plant = context.read<PlantProvider>().currentPlant;
    final user = context.read<UserProvider>();

    try {
      final detail =
          detailControllers.map((row) {
            return AnalyticalResultOutgoingShipmentProductByTruckDetailEntity(
              id: "",
              idHdr: "",
              shipsTank: row['ships_tank_no']?.text ?? '',
              noPolice: row['no_police']?.text ?? '',
              ffa: parseDouble(row['ffa']) ?? 0,
              mni: parseDouble(row['mni']) ?? 0,
              iv: parseDouble(row['iv']) ?? 0,
              lovibondColorRed: parseDouble(row['lovibond_color_red']) ?? 0,
              lovibondColorYellow:
                  parseDouble(row['lovibond_color_yellow']) ?? 0,
              pv: parseDouble(row['pv']) ?? 0,
              other: row['other']?.text ?? '',
              remark: row['remark']?.text ?? '',
            );
          }).toList();

      final report = AnalyticalResultOutgoingShipmentProductByTruckHeaderEntity(
        id: '',
        loadingDate: changeStringDateFormat(
          loadingDateController.text,
          'dd-MM-yyyy',
          'yyyy-MM-dd HH:mm:ss',
          returnDateTime: true,
          withTime: true,
        ),
        productName: selectedProduct ?? '',
        quantity: parseDouble(quantityController.text) ?? 0,
        shipsName: shipsNameController.text ?? '',
        destination: destinationController.text ?? '',
        loadPort: loadPortController.text ?? '',
        entryBy: null,
        entryDate: null,
        correctedBy: null,
        correctedDate: null,
        correctedStatus: null,
        correctedStatusRemarks: null,
        approvedBy: null,
        approvedDate: null,
        approvedStatus: null,
        approvedStatusRemarks: null,
        updatedBy: null,
        updatedDate: null,
        formNo: formData?.code,
        dateIssued: formData?.dateIssued,
        revisionNo: formData?.revisionNo.toString(),
        revisionDate: formData?.revisionDate,

        details: detail,
      );

      final isSuccess = await context
          .read<AnalyticalResultOutgoingShipmentProductByTruckProvider>()
          .insertReport(headerInput: report);

      return isSuccess;
    } catch (e) {
      debugPrint("Error inserting Daily Quality Composite Fractionation: $e");
      return false;
    }
  }
}
