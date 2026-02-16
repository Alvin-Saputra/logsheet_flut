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
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AnalyticalResultIncomingMaterialByVesselInputPage extends StatefulWidget {
  const AnalyticalResultIncomingMaterialByVesselInputPage({super.key});

  @override
  State<AnalyticalResultIncomingMaterialByVesselInputPage> createState() =>
      _AnalyticalResultIncomingMaterialByVesselInputPageState();
}

class _AnalyticalResultIncomingMaterialByVesselInputPageState
    extends State<AnalyticalResultIncomingMaterialByVesselInputPage> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyDetails = GlobalKey<FormState>();
  final TextEditingController dateEntryController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController shipNameController = TextEditingController();
  final TextEditingController contractDoController = TextEditingController();

  final TextEditingController ffaController = TextEditingController();
  final TextEditingController miController = TextEditingController();
  final TextEditingController dobiController = TextEditingController();
  final TextEditingController othersController = TextEditingController();

  final TextEditingController hasilAnalisaFfaController =
      TextEditingController();
  final TextEditingController hasilAnalisaIvController =
      TextEditingController();
  final TextEditingController hasilAnalisaMoistureController =
      TextEditingController();
  final TextEditingController hasilAnalisaDobiController =
      TextEditingController();
  final TextEditingController hasilAnalisaPvController =
      TextEditingController();
  final TextEditingController hasilAnalisaAnvController =
      TextEditingController();
  final TextEditingController hasilAnalisaTotoxController =
      TextEditingController();
  final TextEditingController hasilAnalisaCarotexController =
      TextEditingController();
  final TextEditingController hasilAnalisaMineralOilController =
      TextEditingController();

  final TextEditingController remarkController = TextEditingController();

  List<Map<String, TextEditingController>> detailControllers = [];
  DataFormNoEntity? formData;
  String? selectedMaterial;
  int? numberOfRows;

  final PageController palkaPageControllers = PageController();

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final valueProvider = context.read<ValueProvider>();
      await valueProvider.fetchOilTypes();

      if (mounted && valueProvider.oilTypeLists.isNotEmpty) {
        setState(() {
          selectedMaterial = valueProvider.oilTypeLists.first.name;
        });
      }
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
        "Analytical Result Of Incoming Material By Vessel (${formData!.code})",
      ),
      actions: [],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Form(
      key: _formKey,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomSectionCard('General Data', [
                Column(
                  children: [
                    SizedBox(height: 4.0),
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
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
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
                          value: selectedMaterial,
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
                              selectedMaterial = value;
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
                            labelText: 'Materials',
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
                      controller: dateEntryController,
                      label: 'Arrival',
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
                      controller: supplierController,
                      label: 'Supplier',
                      icon: Icons.person_rounded,
                      isNumeric: false,
                      isRequired: true,
                    ),
                    CustomTextField(
                      controller: shipNameController,
                      label: "Ship's Name",
                      icon: Icons.person_rounded,
                      isNumeric: false,
                      isRequired: true,
                    ),
                    CustomTextField(
                      controller: contractDoController,
                      label: "Contract/D.O Nomor",
                      icon: Icons.person_rounded,
                      isNumeric: false,
                    ),
          
                    CustomTextField(
                      controller: ffaController,
                      label: "FFA (%)",
                      icon: Icons.person_rounded,
                      isNumeric: true,
                    ),
          
                    CustomTextField(
                      controller: miController,
                      label: "M&I (%)",
                      icon: Icons.person_rounded,
                      isNumeric: true,
                    ),
          
                    CustomTextField(
                      controller: dobiController,
                      label: "Dobi (%)",
                      icon: Icons.person_rounded,
                      isNumeric: true,
                    ),
          
                    CustomTextField(
                      controller: othersController,
                      label: "Others",
                      icon: Icons.person_rounded,
                      isNumeric: false,
                    ),
                  ],
                ),
              ]),
              CustomSectionCard('Hasil Analisa Komposit Palka', [
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                    
                  ],
                ),
          
                CustomTextField(
                  controller: hasilAnalisaFfaController,
                  label: "FFA",
                  icon: Icons.person_rounded,
                  isNumeric: true,
                ),
          
                CustomTextField(
                  controller: hasilAnalisaIvController,
                  label: "IV",
                  icon: Icons.person_rounded,
                  isNumeric: true,
                ),
          
                CustomTextField(
                  controller: hasilAnalisaMoistureController,
                  label: "Moisture",
                  icon: Icons.person_rounded,
                  isNumeric: true,
                ),
          
                CustomTextField(
                  controller: hasilAnalisaDobiController,
                  label: "Dobi",
                  icon: Icons.person_rounded,
                  isNumeric: true,
                ),
          
                CustomTextField(
                  controller: hasilAnalisaPvController,
                  label: "PV",
                  icon: Icons.person_rounded,
                  isNumeric: true,
                ),
          
                CustomTextField(
                  controller: hasilAnalisaAnvController,
                  label: "AnV",
                  icon: Icons.person_rounded,
                  isNumeric: true,
                ),
                CustomTextField(
                  controller: hasilAnalisaTotoxController,
                  label: "Totox",
                  icon: Icons.person_rounded,
                  isNumeric: true,
                ),
                CustomTextField(
                  controller: hasilAnalisaCarotexController,
                  label: "Carotex",
                  icon: Icons.person_rounded,
                  isNumeric: true,
                ),
                CustomTextField(
                  controller: hasilAnalisaMineralOilController,
                  label: "Mineral oil",
                  icon: Icons.person_rounded,
                  isNumeric: true,
                ),
              ]),
          
              CustomSectionCard('Detail Data', [
                _detailGeneratorSection(),
                if (detailControllers.isNotEmpty) _detailFormList(),
              ]),
          
              CustomSectionCard('Remarks', [
                CustomRemarkField(controller: remarkController),
              ]),
          
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
                          // if (!_formKey.currentState!.validate()) {
                          //   showSnackBar("Mohon lengkapi semua field", context);
                          //   return;
                          // }
          
                          if (selectedMaterial == null) {
                            showSnackBar("Oil Type wajib dipilih", context);
                            return;
                          }
          
                          if (dateEntryController.text == "") {
                            showSnackBar("Tanggal Wajib dipilih", context);
                            return;
                          }
          
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
        'palka_s_dobi': TextEditingController(),
        'palka_s_mni': TextEditingController(),

        'palka_c_no': TextEditingController(),
        'palka_c_ffa': TextEditingController(),
        'palka_c_iv': TextEditingController(),
        'palka_c_dobi': TextEditingController(),
        'palka_c_mni': TextEditingController(),

        'palka_p_no': TextEditingController(),
        'palka_p_ffa': TextEditingController(),
        'palka_p_iv': TextEditingController(),
        'palka_p_dobi': TextEditingController(),
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
                      _buildSection("Palka S", [
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
                          controller: row['palka_s_dobi']!,
                          label: "Palka S Dobi",
                          icon: Icons.science,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: row['palka_s_mni']!,
                          label: "Palka S MNI",
                          icon: Icons.science,
                          isNumeric: true,
                          isRequired: true,
                        ),
                      ]),

                      const SizedBox(height: 16),
                      const Divider(),

                      // --- FORM PALKA C ---
                      _buildSection("Palka C", [
                        CustomTextField(
                          controller: row['palka_c_ffa']!,
                          label: "Palka C FFA",
                          icon: Icons.science,
                          isNumeric: true,
                          isRequired: true,
                        ),
                        CustomTextField(
                          controller: row['palka_c_iv']!,
                          label: "Palka C IV",
                          icon: Icons.science,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: row['palka_c_dobi']!,
                          label: "Palka C Dobi",
                          icon: Icons.science,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: row['palka_c_mni']!,
                          label: "Palka C MNI",
                          icon: Icons.science,
                          isNumeric: true,
                          isRequired: true,
                        ),
                      ]),

                      const SizedBox(height: 16),
                      const Divider(),

                      _buildSection("Palka P", [
                        CustomTextField(
                          controller: row['palka_p_ffa']!,
                          label: "Palka P FFA",
                          icon: Icons.science,
                          isNumeric: true,
                          isRequired: true,
                        ),
                        CustomTextField(
                          controller: row['palka_p_iv']!,
                          label: "Palka P IV",
                          icon: Icons.science,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: row['palka_p_dobi']!,
                          label: "Palka P Dobi",
                          icon: Icons.science,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: row['palka_p_mni']!,
                          label: "Palka P MNI",
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

    final formattedDateEntry = parseDateFormatFromController(
      dateEntryController.text,
    );

    try {
      final detail =
          detailControllers.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;
            return AnalyticalResultIncomingMaterialByVesselDetailEntity(
              id: "",
              idHdr: "",

              palkaSNo: index + 1,
              palkaSFfa: parseDouble(row['palka_s_ffa']!.text),
              palkaSIv: parseDouble(row['palka_s_iv']!.text),
              palkaSDobi: parseDouble(row['palka_s_dobi']!.text),
              palkaSMni: parseDouble(row['palka_s_mni']!.text),

              palkaCNo: index + 1,

              palkaCFfa: parseDouble(row['palka_c_ffa']!.text),
              palkaCIv: parseDouble(row['palka_c_iv']!.text),
              palkaCDobi: parseDouble(row['palka_c_dobi']!.text),
              palkaCMni: parseDouble(row['palka_c_mni']!.text),

              palkaPNo: index + 1,
              palkaPFfa: parseDouble(row['palka_p_ffa']!.text),
              palkaPIv: parseDouble(row['palka_p_iv']!.text),
              palkaPDobi: parseDouble(row['palka_p_dobi']!.text),
              palkaPMni: parseDouble(row['palka_p_mni']!.text),
            );
          }).toList();

      final header = AnalyticalResultIncomingMaterialByVesselHeaderEntity(
        id: '',
        company: businessUnit?.buCode ?? '',
        plant: plant?.code ?? '',
        transactionDate: formattedDateEntry,
        material: selectedMaterial ?? '',
        arrival: changeStringDateFormat(
          dateEntryController.text,
          'dd-MM-yyyy',
          'yyyy-MM-dd HH:mm:ss',
          returnDateTime: true,
        ),
        quantity: parseDouble(quantityController.text),
        supplier: supplierController.text,
        shipName: shipNameController.text,
        contractDoNomor: contractDoController.text,
        ffa: parseDouble(ffaController.text),
        mni: parseDouble(miController.text),
        dobi: parseDouble(dobiController.text),
        others: othersController.text,
        hasilAnalisaFfa: parseDouble(hasilAnalisaFfaController.text),
        hasilAnalisaIv: parseDouble(hasilAnalisaIvController.text),
        hasilAnalisaMoisture: parseDouble(hasilAnalisaMoistureController.text),
        hasilAnalisaDobi: parseDouble(hasilAnalisaDobiController.text),
        hasilAnalisaPv: parseDouble(hasilAnalisaPvController.text),
        hasilAnalisaAnv: parseDouble(hasilAnalisaAnvController.text),
        hasilAnalisaTotox: parseDouble(hasilAnalisaTotoxController.text),
        hasilAnalisaCarotex: parseDouble(hasilAnalisaCarotexController.text),
        hasilAnalisaMineralOil: parseDouble(
          hasilAnalisaMineralOilController.text,
        ),
        remarks: remarkController.text,

        flag: 'T',
        entryBy: user.currentUser?.username ?? '',
        entryDate: DateTime.now(),
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
          .read<AnalyticalResultIncomingMaterialByVesselProvider>()
          .insertReport(headerInput: header, menudId: formData?.isMenu ?? '');

      return isSuccess;
    } catch (e) {
      debugPrint("Error inserting Analytical Incoming Material By Vessel: $e");
      return false;
    }
  }

  bool _validateDetailRows(BuildContext context) {
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

  DateTime? parseDateFormatFromController(String? selectedDate) {
    final date = DateTime.now();

    if (selectedDate == null || selectedDate.isEmpty) return null;
    try {
      // UI format = "dd-MM-yyyy"
      final inputFormat = DateFormat('dd-MM-yyyy');
      final dateTime = inputFormat.parse(selectedDate);

      // langsung return objek DateTime (bukan String)

      final combinedDateTime = DateTime(
        dateTime.year,
        dateTime.month,
        dateTime.day,
        date.hour,
        date.minute,
        date.second,
      );

      return combinedDateTime;
    } catch (e) {
      log('Date parse error: $e');
      return null;
    }
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
}
