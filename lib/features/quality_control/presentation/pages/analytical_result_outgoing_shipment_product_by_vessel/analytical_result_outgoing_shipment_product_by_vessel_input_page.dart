import 'dart:developer';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/core/widgets/custom_section_card.dart';
import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_detail_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_header_entity.dart';
import 'package:logsheet_app/core/widgets/custom_date_field.dart';
import 'package:logsheet_app/core/widgets/custom_remark_field.dart';
import 'package:logsheet_app/core/widgets/custom_save_button.dart';
import 'package:logsheet_app/core/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/core/widgets/custom_text_field.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/business_unit_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/data_form_no_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/plant_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/value_provider.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_outgoing_shipment_product_by_vessel/analytical_result_outgoing_shipment_product_by_vessel_detail_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_outgoing_shipment_product_by_vessel/analytical_result_outgoing_shipment_product_by_vessel_header_entity.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_outgoing_shipment_product_by_vessel/analytical_result_outgoing_shipment_product_by_vessel_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AnalyticalResultOutgoingShipmentProductByVesselInputPage
    extends StatefulWidget {
  const AnalyticalResultOutgoingShipmentProductByVesselInputPage({super.key});

  @override
  State<AnalyticalResultOutgoingShipmentProductByVesselInputPage>
  createState() =>
      _AnalyticalResultOutgoingShipmentProductByVesselInputPageState();
}

class _AnalyticalResultOutgoingShipmentProductByVesselInputPageState
    extends State<AnalyticalResultOutgoingShipmentProductByVesselInputPage> {
  final _formKey = GlobalKey<FormState>();
  // final _formKeyDetails = GlobalKey<FormState>();

  String? selectedProductName;
  final TextEditingController samplingDateController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController vesselNameController = TextEditingController();
  final TextEditingController shipperController = TextEditingController();
  final TextEditingController destinationController = TextEditingController();

  final TextEditingController hasilAnalisaFfaController =
      TextEditingController();
  final TextEditingController hasilAnalisaIvController =
      TextEditingController();
  final TextEditingController hasilAnalisaMoistureController =
      TextEditingController();
  final TextEditingController hasilAnalisaColourController =
      TextEditingController();
  final TextEditingController hasilAnalisaPvController =
      TextEditingController();
  final TextEditingController hasilAnalisaSmpController =
      TextEditingController();

  List<Map<String, TextEditingController>> detailControllers = [];
  DataFormNoEntity? formData;

  int? numberOfRows;

  final PageController palkaPageControllers = PageController();

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<ValueProvider>().fetchOilTypes();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: _buildAppBar(), body: _buildBody(context));
  }

  AppBar _buildAppBar() {
    formData =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where(
              (form) =>
                  form.isMenu ==
                  "Analytical_Result_Of_Incoming_Material_By_Vessel",
            )
            .first;
    return AppBar(
      title: Text(
        "Analytical Result Incoming Material By Vessel Input (${formData!.code})",
      ),
      actions: [],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(16.0),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Consumer<ValueProvider>(
                builder: (context, provider, child) {
                  if (provider.isOilTypeLoading) {
                    // Return a disabled dropdown with a loading indicator or message
                    return DropdownButtonFormField<String>(
                      value: null,
                      items: [],
                      onChanged: null, // Disable the dropdown
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
                        hintText: 'Materials Tidak Ditemukan.',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(Icons.warning_amber_rounded),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () {
                            context.read<ValueProvider>().fetchOilTypes();
                          },
                        ),
                      ),
                    );
                  }
                  return DropdownButtonFormField<String>(
                    value: selectedProductName,
                    items:
                        provider.oilTypeLists.map((item) {
                          return DropdownMenuItem<String>(
                            value: item.name,
                            child: Text(
                              "${item.name}",
                              style: TextStyle(fontSize: 14),
                            ),
                          );
                        }).toList(),
                    onChanged: (value) {
                      setState(() {
                        selectedProductName = value;
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF0ECE9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Pilih Materials',
                      prefixIcon: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: SvgPicture.asset(
                          'assets/icons/oil-refinery-tanks.svg',
                          height: 24,
                          width: 24,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 8),
              CustomDateField(
                controller: samplingDateController,
                label: 'Sampling Date',
                icon: Icons.event,
              ),
              const SizedBox(height: 8),
              CustomTextField(
                controller: quantityController,
                label: 'Quantity',
                icon: Icons.storage_rounded,
                isNumeric: true,
                isRequired: true,
              ),
              CustomTextField(
                controller: vesselNameController,
                label: 'Vessel Name',
                icon: Icons.person_rounded,
                isNumeric: false,
                isRequired: true,
              ),
              CustomTextField(
                controller: shipperController,
                label: "Shipper Name",
                icon: Icons.person_rounded,
                isNumeric: false,
                isRequired: true,
              ),
              CustomTextField(
                controller: destinationController,
                label: "Destination",
                icon: Icons.person_rounded,
                isNumeric: false,
              ),

              _detailGeneratorSection(),
              if (detailControllers.isNotEmpty) _detailFormList(),

              const SizedBox(height: 8.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "Hasil Analisa Komposite Palka",
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                ],
              ),

              CustomTextField(
                controller: hasilAnalisaFfaController,
                label: "FFA (As Palmitic %)",
                icon: Icons.person_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: hasilAnalisaIvController,
                label: "IV gr2/100gr",
                icon: Icons.person_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: hasilAnalisaMoistureController,
                label: "Moisture (%)",
                icon: Icons.person_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: hasilAnalisaColourController,
                label: "Color (R)",
                icon: Icons.person_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: hasilAnalisaPvController,
                label: "PV (meqO2/kg)",
                icon: Icons.person_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: hasilAnalisaSmpController,
                label: "SMP",
                icon: Icons.person_rounded,
                isNumeric: true,
              ),

              Consumer<AnalyticalResultIncomingMaterialByVesselProvider>(
                builder: (
                  BuildContext context,
                  AnalyticalResultIncomingMaterialByVesselProvider provider,
                  Widget? child,
                ) {
                  return (provider.isLoadingInput)
                      ? Center(child: CircularProgressIndicator())
                      : CustomSaveButton(
                        onPressed: () async {
                          // Form validation
                          if (!_formKey.currentState!.validate()) {
                            showSnackBar("Mohon lengkapi semua field", context);
                            return;
                          }

                          if (selectedProductName == null) {
                            showSnackBar("Oil Type wajib dipilih", context);
                            return;
                          }

                          if (samplingDateController.text == "") {
                            showSnackBar("Tanggal Wajib dipilih", context);
                            return;
                          }

                          if (numberOfRows == 0 || numberOfRows == null) {
                            showSnackBar("Wajib Generate Details", context);
                            return;
                          }

                          if (!_validateDetailRows(context)) return;

                          final bool isSuccess = await _insertData();

                          if (isSuccess) {
                            showSnackBar("Berhasil menyimpan data", context);
                            Navigator.of(context).pop();
                          } else {
                            showSnackBar("Gagal menyimpan data", context);
                          }
                        },
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void generateDetailRows(int count) {
    detailControllers.clear();

    for (int i = 0; i < count; i++) {
      detailControllers.add({
        'palka_s_no': TextEditingController(),
        'palka_s_ffa': TextEditingController(),
        'palka_s_iv': TextEditingController(),
        'palka_s_colour': TextEditingController(),
        'palka_s_pv': TextEditingController(),
        'palka_s_mni': TextEditingController(),

        'palka_p_no': TextEditingController(),
        'palka_p_ffa': TextEditingController(),
        'palka_p_iv': TextEditingController(),
        'palka_p_colour': TextEditingController(),
        'palka_p_pv': TextEditingController(),
        'palka_p_mni': TextEditingController(),
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
                    palkaPageControllers, // Gunakan satu controller untuk semua
                count: detailControllers.length,
                effect: const WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.blue, // Sesuaikan warna tema Anda
                  dotColor: Colors.grey,
                ),
                onDotClicked: (index) {
                  palkaPageControllers.animateToPage(
                    index,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                  );
                },
              ),
            ),
            // Text(
            //   "Detail ${index + 1}",
            //   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            // ),
            // SizedBox(height: 12),

            // // PALKA S
            // Text("Palka S", style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 6),

            ExpandablePageView.builder(
              controller: palkaPageControllers, // Cukup satu controller utama
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

                      // --- FORM PALKA S ---
                      CustomSectionCard("Palka S", [
                        CustomTextField(
                          controller: row['palka_s_no']!,
                          label: "Palka S No",
                          icon: Icons.numbers,
                          isRequired: true,
                        ),
                        CustomTextField(
                          controller: row['palka_s_ffa']!,
                          label: "Palka S FFA",
                          icon: Icons.science,
                          isNumeric: true,
                          isRequired: true,
                        ),
                        CustomTextField(
                          controller: row['palka_s_iv']!,
                          label: "Palka S IV",
                          icon: Icons.science,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: row['palka_s_colour']!,
                          label: "Palka S Colour",
                          icon: Icons.science,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: row['palka_s_pv']!,
                          label: "Palka S PV",
                          icon: Icons.science,
                          isNumeric: true,
                          isRequired: true,
                        ),
                        CustomTextField(
                          controller: row['palka_s_mni']!,
                          label: "Palka S M&I",
                          icon: Icons.science,
                          isNumeric: true,
                          isRequired: true,
                        ),
                      ]),

                      const SizedBox(height: 16),
                      const Divider(),

                      CustomSectionCard("Palka P", [
                        CustomTextField(
                          controller: row['palka_p_no']!,
                          label: "Palka S No",
                          icon: Icons.numbers,
                          isRequired: true,
                        ),
                        CustomTextField(
                          controller: row['palka_p_ffa']!,
                          label: "Palka S FFA",
                          icon: Icons.science,
                          isNumeric: true,
                          isRequired: true,
                        ),
                        CustomTextField(
                          controller: row['palka_p_iv']!,
                          label: "Palka S IV",
                          icon: Icons.science,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: row['palka_p_colour']!,
                          label: "Palka S Colour",
                          icon: Icons.science,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: row['palka_p_pv']!,
                          label: "Palka S PV",
                          icon: Icons.science,
                          isNumeric: true,
                          isRequired: true,
                        ),
                        CustomTextField(
                          controller: row['palka_p_mni']!,
                          label: "Palka S M&I",
                          icon: Icons.science,
                          isNumeric: true,
                          isRequired: true,
                        ),
                      ]),
                    ],
                  ),
                );
              },
            ),

            // SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Future<bool> _insertData() async {
    final plant = context.read<PlantProvider>().currentPlant;
    final user = context.read<UserProvider>();
    final businessUnit =
        context.read<BusinessUnitProvider>().currentBusinessUnit;

    try {
      final detail =
          detailControllers.map((row) {
            return AnalyticalResultOutgoingShipmentProductByVesselDetailEntity(
              id: "",
              idHdr: "",
                palkaSPalka: parseDouble(row['palka_s_no']!.text),
                palkaSFfa: parseDouble(row['palka_s_ffa']!.text),
                palkaSIv: parseDouble(row['palka_s_iv']!.text),
                palkaSColour: parseDouble(row['palka_s_colour']!.text),
                palkaSPv: parseDouble(row['palka_s_pv']!.text),
                palkaSMni: parseDouble(row['palka_s_mni']!.text),
                palkaPPalka: parseDouble(row['palka_p_no']!.text),
                palkaPFfa: parseDouble(row['palka_p_ffa']!.text),
                palkaPIv: parseDouble(row['palka_p_iv']!.text),
                palkaPColour: parseDouble(row['palka_p_colour']!.text),
                palkaPPv: parseDouble(row['palka_p_pv']!.text),
                palkaPMni: parseDouble(row['palka_p_mni']!.text),
            );
          }).toList();

      final header =
          AnalyticalResultOutgoingShipmentProductByVesselHeaderEntity(
            id: '',
            company: businessUnit?.buCode ?? '',
            plant: plant?.code ?? '',
            productName: selectedProductName ?? '',
            samplingDate: changeStringDateFormat(
              samplingDateController.text,
              'dd-MM-yyyy',
              'yyyy-MM-dd HH:mm:ss',
              returnDateTime: true,
            ),
            shipper: shipperController.text,
            destination: destinationController.text,
            vesselName: vesselNameController.text,
            quantity: parseDouble(quantityController.text) ?? 0,
            hasilAnalisaFfa: parseDouble(hasilAnalisaFfaController.text) ?? 0,
            hasilAnalisaIv: parseDouble(hasilAnalisaIvController.text) ?? 0,
            hasilAnalisaMoisture:
                parseDouble(hasilAnalisaMoistureController.text) ?? 0,
            hasilAnalisaPv: parseDouble(hasilAnalisaPvController.text) ?? 0,
            hasilAnalisaColorR:
                parseDouble(hasilAnalisaColourController.text) ?? 0,
            hasilAnalisaSMP: parseDouble(hasilAnalisaSmpController.text) ?? 0,
            entryBy: user.currentUser?.username ?? '',
            entryDate: null,
            preparedBy: null,
            preparedDate: null,
            preparedStatus: null,
            preparedStatusRemarks: null,
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

      // final isSuccess = await context
      //     .read<AnalyticalResultIncomingMaterialByVesselProvider>()
      //     .insertAnalyticalResultIncomingMaterialByVessel(
      //       headerInput: header,
      //       detailInput: detail,
      //       plantCode: plant?.code ?? '',
      //     );

      final isSuccess = await context
          .read<AnalyticalResultOutgoingShipmentProductByVesselProvider>()
          .insertReport(headerInput: header);

      return isSuccess;
      return true;
    } catch (e) {
      debugPrint("Error inserting Analytical Incoming Material By Vessel: $e");
      return false;
    }
  }

  bool _validateDetailRows(BuildContext context) {
    // Tentukan key mana saja yang WAJIB diisi
    // Sesuaikan string ini dengan key yang Anda buat di function generateDetailRows
    final List<String> mandatoryKeys = [
      'palka_s_ffa',
      'palka_s_mni',
      'palka_c_ffa',
      'palka_c_mni',
      'palka_p_ffa',
      'palka_p_mni',
    ];

    for (int i = 0; i < detailControllers.length; i++) {
      final row = detailControllers[i];
      bool isPageValid = true;

      // Cek hanya key yang ada di list mandatoryKeys
      for (final key in mandatoryKeys) {
        // Pastikan key ada di map dan text-nya kosong
        if (row[key] != null && row[key]!.text.trim().isEmpty) {
          isPageValid = false;
          break; // Stop loop, halaman ini sudah invalid
        }
      }

      if (!isPageValid) {
        // 1. Pindahkan PageView ke halaman yang error
        palkaPageControllers.animateToPage(
          i,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeIn,
        );

        // 2. Tampilkan pesan
        showSnackBar(
          "Detail ke-${i + 1} belum lengkap. FFA dan MNI wajib diisi.",
          context,
        );

        return false; // Validasi gagal
      }
    }
    return true; // Validasi sukses
  }
}
