import 'dart:developer';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/core/widgets/custom_section_title.dart';
import 'package:logsheet_app/core/widgets/section_card.dart';
import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
import 'package:logsheet_app/core/widgets/custom_date_field.dart';
import 'package:logsheet_app/core/widgets/custom_save_button.dart';
import 'package:logsheet_app/core/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/core/widgets/custom_text_field.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/business_unit_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/data_form_no_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/plant_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/value_provider.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/certificate_of_analysis_incoming_plant_chemical_ingredient_detail_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/certificate_of_analysis_incoming_plant_chemical_ingredient_header_entity.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_incoming_material_by_truck/analytical_result_incoming_material_by_truck_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/certificate_of_analysis_incoming_plant_chemical_ingredient_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CertificateOfAnalysisIncomingPlantChemicalIngredientInputPage
    extends StatefulWidget {
  const CertificateOfAnalysisIncomingPlantChemicalIngredientInputPage({
    super.key,
  });

  @override
  State<CertificateOfAnalysisIncomingPlantChemicalIngredientInputPage>
  createState() =>
      _CertificateOfAnalysisIncomingPlantChemicalIngredientInputPageState();
}

class _CertificateOfAnalysisIncomingPlantChemicalIngredientInputPageState
    extends
        State<CertificateOfAnalysisIncomingPlantChemicalIngredientInputPage> {
  final _formKey = GlobalKey<FormState>();
  // --- Controllers for Material Info ---
  final TextEditingController gradeController = TextEditingController();
  final TextEditingController packingController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController noDocController = TextEditingController();

  // --- Controllers for Vehicle Info ---
  final TextEditingController vehicleController = TextEditingController();
  final TextEditingController lotNoController = TextEditingController();

  // --- Date Controllers ---
  final TextEditingController tanggalPengirimanController =
      TextEditingController();
  final TextEditingController productionDateController =
      TextEditingController();
  final TextEditingController expiredDateController = TextEditingController();

  DataFormNoEntity? formData;
  String? selectedMaterial;

  List<Map<String, dynamic>> detailControllers = [];
  List<String> parameters = [
    'Moisture',
    'pH',
    'Bulk Density',
    'ACIDITY',
    'PASSING MESH',
    'SURFACE AREA',
    'PORE VOLUME',
  ];

  final PageController pageControllers = PageController();

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<ValueProvider>().fetchOilTypes();
    });

    for (int i = 0; i < parameters.length; i++) {
      detailControllers.add({
        'parameter_name': parameters[i],
        'actual_min': TextEditingController(),
        'actual_max': TextEditingController(),
        'standard_min': TextEditingController(),
        'standard_max': TextEditingController(),
        'method': TextEditingController(),
      });
    }
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
                  "Analytical_Result_Of_Incoming_Material_By_Truck",
            )
            .first;
    return AppBar(
      title: Text(
        "Analytical Result Incoming Material By Truck Input (${formData!.code})",
      ),
      actions: [],
    );
  }

  Widget _buildBody(BuildContext context) {
    return Padding(
      padding: EdgeInsetsGeometry.all(24.0),
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
                        hintText: 'Materials Tidak Ditemukan',
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
                      hintText: 'Pilih Material',
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
              const SizedBox(height: 12.0),
              CustomTextField(
                controller: gradeController,
                label: "Grade",
                icon: Icons.person_rounded,
                isNumeric: false,
              ),

              CustomTextField(
                controller: packingController,
                label: "Packing",
                icon: Icons.person_rounded,
                isNumeric: true,
              ),
              CustomTextField(
                controller: quantityController,
                label: "Quantity",
                icon: Icons.person_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: noDocController,
                label: "No Doc",
                icon: Icons.person_rounded,
                isNumeric: false,
              ),

              CustomDateField(
                controller: tanggalPengirimanController,
                label: 'Tanggal Pengiriman',
                icon: Icons.event,
              ),
              const SizedBox(height: 8),

              CustomTextField(
                controller: vehicleController,
                label: "Vehicle",
                icon: Icons.person_rounded,
                isNumeric: false,
              ),

              CustomTextField(
                controller: lotNoController,
                label: "Lot No",
                icon: Icons.person_rounded,
                isNumeric: false,
              ),

              CustomDateField(
                controller: productionDateController,
                label: 'Production Date',
                icon: Icons.event,
              ),
              const SizedBox(height: 16),

              CustomDateField(
                controller: expiredDateController,
                label: 'Expired Date',
                icon: Icons.event,
              ),
              const SizedBox(height: 8),

              ExpandablePageView.builder(
                controller: pageControllers,
                itemCount: parameters.length,
                itemBuilder: (context, pageIndex) {
                  final row = detailControllers[pageIndex];

                  return SectionCard(
                    title: parameters[pageIndex],
                    children: [
                      CustomTextField(
                        controller: row['actual_min']!,
                        label: "actual min",
                        icon: Icons.person_rounded,
                        isNumeric: false,
                      ),

                      CustomTextField(
                        controller: row['actual_max']!,
                        label: "actual max",
                        icon: Icons.person_rounded,
                        isNumeric: false,
                      ),

                      CustomTextField(
                        controller: row['standard_max']!,
                        label: "standard min",
                        icon: Icons.person_rounded,
                        isNumeric: false,
                      ),

                      CustomTextField(
                        controller: row['standard_min']!,
                        label: "standard max",
                        icon: Icons.person_rounded,
                        isNumeric: false,
                      ),
                      CustomTextField(
                        controller: row['method']!,
                        label: "Method",
                        icon: Icons.person_rounded,
                        isNumeric: false,
                      ),
                    ],
                  );
                },
              ),
              SizedBox(height: 24.0),
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

              const SizedBox(height: 24.0),

              Consumer<AnalyticalResultIncomingMaterialByTruckProvider>(
                builder: (
                  BuildContext context,
                  AnalyticalResultIncomingMaterialByTruckProvider provider,
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

                          if (selectedMaterial == null) {
                            showSnackBar("Oil Type wajib dipilih", context);
                            return;
                          }

                          if (tanggalPengirimanController.text == "") {
                            showSnackBar("Tanggal Wajib dipilih", context);
                            return;
                          }

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

  Future<bool> _insertData() async {
    final plant = context.read<PlantProvider>().currentPlant;
    final user = context.read<UserProvider>();
    final businessUnit =
        context.read<BusinessUnitProvider>().currentBusinessUnit;

    final details =
        detailControllers.map((item) {
          return CertificateOfAnalysisIncomingPlantChemicalIngredientDetailEntity(
            id: "",
            idHdr: "",
            parameter: item['parameter_name'],
            actualMin: parseDouble(item['actual_min'].text),
            actualMax: parseDouble(item['actual_max'].text),
            standardMin: parseDouble(item['standard_min'].text),
            standardMax: parseDouble(item['standard_max'].text),
            method: item['method'].text,
          );
        }).toList();

    try {
      final header =
          CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderEntity(
            id: '',
            noDoc: noDocController.text,
            product: selectedMaterial,
            grade: gradeController.text,
            packing: packingController.text,
            quantity: parseDouble(quantityController.text) ?? 0,
            tanggalPengiriman: parseDateFormatFromController(
              tanggalPengirimanController.text,
            ),
            vehicle: vehicleController.text,
            lotNo: lotNoController.text,
            productionDate: parseDateFormatFromController(
              productionDateController.text,
            ),
            expiredDate: parseDateFormatFromController(
              expiredDateController.text,
            ),
            issueBy: null,
            issueDate: null,
            details: details,
          );

      final isSuccess = await context
          .read<CertificateOfAnalysisIncomingPlantChemicalIngredientProvider>()
          .insertReport(headerInput: header, menuId: formData?.isMenu ?? '');

      return isSuccess;
    } catch (e) {
      debugPrint("Error inserting Analytical Incoming Material By Vessel: $e");
      return false;
    }
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
}
