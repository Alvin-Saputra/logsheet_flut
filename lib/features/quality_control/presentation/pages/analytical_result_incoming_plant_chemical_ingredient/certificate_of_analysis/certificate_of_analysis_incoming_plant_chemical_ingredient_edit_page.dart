import 'dart:developer';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
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
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_incoming_plant_chemical_ingredient/certificate_of_analysis/certificate_of_analysis_incoming_plant_chemical_ingredient_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class CertificateOfAnalysisIncomingPlantChemicalIngredientEditPage
    extends StatefulWidget {
  const CertificateOfAnalysisIncomingPlantChemicalIngredientEditPage({
    super.key,
    required this.data,
  });

  final CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderEntity data;

  @override
  State<CertificateOfAnalysisIncomingPlantChemicalIngredientEditPage>
  createState() =>
      _CertificateOfAnalysisIncomingPlantChemicalIngredientEditPageState();
}

class _CertificateOfAnalysisIncomingPlantChemicalIngredientEditPageState
    extends
        State<CertificateOfAnalysisIncomingPlantChemicalIngredientEditPage> {
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

  late CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderEntity
  updatedData;

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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<ValueProvider>().fetchOilTypes();

      setState(() {
        if (widget.data.product != null && widget.data.product!.isNotEmpty) {
          selectedMaterial = widget.data.product;
          var oilTypeNames =
              context
                  .read<ValueProvider>()
                  .oilTypeLists
                  .map((item) => item.name)
                  .toList();
          if (!oilTypeNames.contains(widget.data.product)) {
            selectedMaterial = null;
          }
        } else {
          selectedMaterial = null;
        }
        tanggalPengirimanController.text =
            formatDatetoString(widget.data.tanggalPengiriman, 'dd-MM-yyyy') ??
            '';

        productionDateController.text =
            formatDatetoString(widget.data.productionDate, 'dd-MM-yyyy') ?? '';

        expiredDateController.text =
            formatDatetoString(widget.data.expiredDate, 'dd-MM-yyyy') ?? '';

        gradeController.text = widget.data.grade ?? '';
        packingController.text = widget.data.packing ?? '';
        quantityController.text = widget.data.quantity.toString();
        noDocController.text = widget.data.noDoc.toString();
        vehicleController.text = widget.data.vehicle.toString();
        lotNoController.text = widget.data.lotNo ?? '';

        print(widget.data.details.length);
        print(widget.data.details[0]);
        // print(widget.data.details[1]);

        var detail1 = widget.data.details[0];

        for (int i = 0; i < widget.data.details.length; i++) {
          // detailControllers[i]['parameter_name']?.text =
          //     widget.data.details[i].parameter;

          detailControllers[i]['actual_min']?.text =
              widget.data.details[i].actualMin.toString();

          detailControllers[i]['actual_max']?.text =
              widget.data.details[i].actualMax.toString();

          detailControllers[i]['standard_min']?.text =
              widget.data.details[i].standardMin.toString();

          detailControllers[i]['standard_max']?.text =
              widget.data.details[i].standardMax.toString();

          detailControllers[i]['method']?.text =
              widget.data.details[i].method ?? '';
        }
      });
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

              Consumer<
                CertificateOfAnalysisIncomingPlantChemicalIngredientProvider
              >(
                builder: (
                  BuildContext context,
                  CertificateOfAnalysisIncomingPlantChemicalIngredientProvider
                  provider,
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

                          final bool isSuccess = await _updateData();

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

  Future<bool> _updateData() async {
    final plant = context.read<PlantProvider>().currentPlant;
    final user = context.read<UserProvider>();
    final businessUnit =
        context.read<BusinessUnitProvider>().currentBusinessUnit;

    try {
      final detail =
          detailControllers.asMap().entries.map((entry) {
            final index = entry.key;
            final row = entry.value;
            final oldDetail = widget.data.details[index];

            return CertificateOfAnalysisIncomingPlantChemicalIngredientDetailEntity(
              id: oldDetail.id,
              idHdr: oldDetail.idHdr,
              parameter: detailControllers[index]['parameter_name'],
              actualMin: parseDouble(detailControllers[index]['actual_min'].text),
              actualMax: parseDouble(detailControllers[index]['actual_max'].text),
              standardMin: parseDouble(detailControllers[index]['standard_min'].text),
              standardMax: parseDouble(detailControllers[index]['standard_max'].text),
              method: detailControllers[index]['method'].text,
            );
          }).toList();

      final header =
          CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderEntity(
            id: widget.data.id,
            noDoc: noDocController.text,
            product: selectedMaterial,
            grade: gradeController.text,
            packing: packingController.text,
            quantity: parseDouble(quantityController.text) ?? 0,
            tanggalPengiriman: changeStringDateFormat(
              tanggalPengirimanController.text,
              'dd-MM-yyyy',
              'yyyy-MM-dd HH:mm:ss',
              returnDateTime: true,
            ),
            vehicle: vehicleController.text,
            lotNo: lotNoController.text,
            productionDate: changeStringDateFormat(
              productionDateController.text,
              'dd-MM-yyyy',
              'yyyy-MM-dd HH:mm:ss',
              returnDateTime: true,
            ),
            expiredDate: changeStringDateFormat(
              expiredDateController.text,
              'dd-MM-yyyy',
              'yyyy-MM-dd HH:mm:ss',
              returnDateTime: true,
            ),
            issueBy: '',
            issueDate: null,
            details: detail,
          );

      final isSuccess = await context
          .read<CertificateOfAnalysisIncomingPlantChemicalIngredientProvider>()
          .updateReport(headerInput: header, menuId: formData?.isMenu ?? '');
      updatedData = header;
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
