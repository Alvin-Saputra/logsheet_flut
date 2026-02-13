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
import 'package:logsheet_app/features/quality_control/presentation/pages/analytical_result_outgoing_shipment_product_by_vessel/analytical_result_outgoing_shipment_product_by_vessel_detail_input_item.dart';
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

  final TextEditingController remarkController = TextEditingController();

  List<Map<String, TextEditingController>> detailControllers = [];
  DataFormNoEntity? formData;

  int? numberOfRows;

  final PageController palkaPageControllers = PageController();

  List<AnalyticalResultOutgoingShipmentProductByVesselDetailInputItem>
  inputItems = [];

  void _addNewRow() {
    setState(() {
      inputItems.add(
        AnalyticalResultOutgoingShipmentProductByVesselDetailInputItem(),
      );
    });
  }

  // Fungsi Hapus Row
  void _removeRow(int index) {
    setState(() {
      inputItems.removeAt(index);
    });
  }

  @override
  initState() {
    super.initState();
    _addNewRow();
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
                  "Analytical_Result_of_Outgoing_Shipment_By_Vessel",
            )
            .first;
    return AppBar(
      title: Text(
        "Analytical Result of OutGoing Shipment By Vessel Input(${formData!.code})",
      ),
      actions: [],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              CustomSectionCard("General Data", [
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
                    // Set initial value to first item if not already selected
                    if (selectedProductName == null &&
                        provider.oilTypeLists.isNotEmpty) {
                      WidgetsBinding.instance.addPostFrameCallback((_) {
                        setState(() {
                          selectedProductName =
                              provider.oilTypeLists.first.name;
                        });
                      });
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
              ]),

              // _detailGeneratorSection(),
              ...List.generate(inputItems.length, (index) {
                return _detailFormList(inputItems, index);
              }),

              Container(
                width: double.infinity,

                child: OutlinedButton.icon(
                  onPressed: _addNewRow,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.all(16),
                    side: const BorderSide(color: Colors.redAccent, width: 2),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.add_circle_outline, size: 28),
                  label: const Text(
                    "Tambah Set Data Details",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              CustomSectionCard("Hasil Analisa", [
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
              ]),

              CustomRemarkField(controller: remarkController),
              SizedBox(height: 16.0),
              Consumer<AnalyticalResultOutgoingShipmentProductByVesselProvider>(
                builder: (
                  BuildContext context,
                  AnalyticalResultOutgoingShipmentProductByVesselProvider
                  provider,
                  Widget? child,
                ) {
                  return (provider.isLoadingInput)
                      ? Center(child: CircularProgressIndicator())
                      : CustomSaveButton(
                        onPressed: () async {
                          // Form validation
                          // if (!_formKey.currentState!.validate()) {
                          //   showSnackBar("Mohon lengkapi semua field", context);
                          //   return;
                          // }

                          // if (selectedProductName == null) {
                          //   showSnackBar("Oil Type wajib dipilih", context);
                          //   return;
                          // }

                          // if (samplingDateController.text == "") {
                          //   showSnackBar("Tanggal Wajib dipilih", context);
                          //   return;
                          // }

                          // if (numberOfRows == 0 || numberOfRows == null) {
                          //   showSnackBar("Wajib Generate Details", context);
                          //   return;
                          // }

                          // if (!_validateDetailRows(context)) return;

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

  Widget _detailFormList(
    List<AnalyticalResultOutgoingShipmentProductByVesselDetailInputItem>
    inputItems,
    int index,
  ) {
    return Card(
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.blueGrey[50],
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Set Data Detail Palka #${index + 1}",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  if (inputItems.length > 1)
                    InkWell(
                      onTap: () => _removeRow(index),
                      child: const Icon(Icons.delete, color: Colors.red),
                    ),
                ],
              ),
            ),
            SizedBox(height: 6),

            // --- FORM PALKA S ---
            CustomSectionCard("Palka S", [
              CustomTextField(
                controller: inputItems[index].palkaSffa,
                label: "Palka S FFA",
                icon: Icons.science,
                isNumeric: true,
                isRequired: true,
              ),
              CustomTextField(
                controller: inputItems[index].palkaSiv,
                label: "Palka S IV",
                icon: Icons.science,
                isNumeric: true,
              ),
              CustomTextField(
                controller: inputItems[index].palkaSColour,
                label: "Palka S Colour",
                icon: Icons.science,
                isNumeric: true,
              ),
              CustomTextField(
                controller: inputItems[index].palkaSPv,
                label: "Palka S PV",
                icon: Icons.science,
                isNumeric: true,
                isRequired: true,
              ),
              CustomTextField(
                controller: inputItems[index].palkaSMni,
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
                controller: inputItems[index].palkaPffa,
                label: "Palka P FFA",
                icon: Icons.science,
                isNumeric: true,
                isRequired: true,
              ),
              CustomTextField(
                controller: inputItems[index].palkaPiv,
                label: "Palka P IV",
                icon: Icons.science,
                isNumeric: true,
              ),
              CustomTextField(
                controller: inputItems[index].palkaPColour,
                label: "Palka P Colour",
                icon: Icons.science,
                isNumeric: true,
              ),
              CustomTextField(
                controller: inputItems[index].palkaPPv,
                label: "Palka P PV",
                icon: Icons.science,
                isNumeric: true,
                isRequired: true,
              ),
              CustomTextField(
                controller: inputItems[index].palkaPMni,
                label: "Palka S M&I",
                icon: Icons.science,
                isNumeric: true,
                isRequired: true,
              ),
            ]),
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
      List<AnalyticalResultOutgoingShipmentProductByVesselDetailEntity>
      detailEntities = [];

      for (int i = 0; i < inputItems.length; i++) {
        var item = inputItems[i];

        detailEntities.add(
          AnalyticalResultOutgoingShipmentProductByVesselDetailEntity(
            id: '',
            idHdr: '',
            palkaSPalka: i + 1,
            palkaSFfa: parseDouble(item.palkaSffa.text),
            palkaSIv: parseDouble(item.palkaSiv.text),
            palkaSColour: parseDouble(item.palkaSColour.text),
            palkaSPv: parseDouble(item.palkaSPv.text),
            palkaSMni: parseDouble(item.palkaSMni.text),
            palkaPPalka: i + 1,
            palkaPFfa: parseDouble(item.palkaPffa.text),
            palkaPIv: parseDouble(item.palkaPiv.text),
            palkaPColour: parseDouble(item.palkaPColour.text),
            palkaPPv: parseDouble(item.palkaPColour.text),
            palkaPMni: parseDouble(item.palkaPMni.text),
          ),
        );
      }

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
            quantity: parseDouble(quantityController.text),
            hasilAnalisaFfa: parseDouble(hasilAnalisaFfaController.text),
            hasilAnalisaIv: parseDouble(hasilAnalisaIvController.text),
            hasilAnalisaMoisture: parseDouble(
              hasilAnalisaMoistureController.text,
            ),
            hasilAnalisaPv: parseDouble(hasilAnalisaPvController.text),
            hasilAnalisaColorR: parseDouble(hasilAnalisaColourController.text),
            hasilAnalisaSMP: parseDouble(hasilAnalisaSmpController.text),
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
            details: detailEntities,
            remark: remarkController.text,
          );

      final isSuccess = await context
          .read<AnalyticalResultOutgoingShipmentProductByVesselProvider>()
          .insertReport(headerInput: header);

      return isSuccess;
    } catch (e) {
      debugPrint("Error inserting Analytical Incoming Material By Vessel: $e");
      return false;
    }
  }

  // bool _validateDetailRows(BuildContext context) {
  //   // Tentukan key mana saja yang WAJIB diisi
  //   // Sesuaikan string ini dengan key yang Anda buat di function generateDetailRows
  //   final List<String> mandatoryKeys = [
  //     'palka_s_ffa',
  //     'palka_s_mni',
  //     'palka_c_ffa',
  //     'palka_c_mni',
  //     'palka_p_ffa',
  //     'palka_p_mni',
  //   ];

  //   for (int i = 0; i < detailControllers.length; i++) {
  //     final row = detailControllers[i];
  //     bool isPageValid = true;

  //     // Cek hanya key yang ada di list mandatoryKeys
  //     for (final key in mandatoryKeys) {
  //       // Pastikan key ada di map dan text-nya kosong
  //       if (row[key] != null && row[key]!.text.trim().isEmpty) {
  //         isPageValid = false;
  //         break; // Stop loop, halaman ini sudah invalid
  //       }
  //     }

  //     if (!isPageValid) {
  //       // 1. Pindahkan PageView ke halaman yang error
  //       palkaPageControllers.animateToPage(
  //         i,
  //         duration: const Duration(milliseconds: 300),
  //         curve: Curves.easeIn,
  //       );

  //       // 2. Tampilkan pesan
  //       showSnackBar(
  //         "Detail ke-${i + 1} belum lengkap. FFA dan MNI wajib diisi.",
  //         context,
  //       );

  //       return false; // Validasi gagal
  //     }
  //   }
  //   return true; // Validasi sukses
  // }
}
