import 'dart:developer';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/core/widgets/custom_autocomplete.dart';
import 'package:logsheet_app/core/widgets/custom_radio_button.dart';
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
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/analytical_result/analytical_result_incoming_plant_chemical_ingredient_detail_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_chemical_ingredient/analytical_result/analytical_result_incoming_plant_chemical_ingredient_header_entity.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_incoming_plant_chemical_ingredient/analytical_result/analytical_result_incoming_plant_chemical_ingredient_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AnalyticalResultIncomingPlantFuelInputPage extends StatefulWidget {
  AnalyticalResultIncomingPlantFuelInputPage({super.key});

  @override
  State<AnalyticalResultIncomingPlantFuelInputPage> createState() =>
      _AnalyticalResultIncomingPlantFuelInputPageState();
}

class _AnalyticalResultIncomingPlantFuelInputPageState
    extends State<AnalyticalResultIncomingPlantFuelInputPage> {
  final _formKey = GlobalKey<FormState>();
  DataFormNoEntity? formData;

  final TextEditingController dateController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController noRefCoaController = TextEditingController();
  final TextEditingController analystController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController policeNumberController = TextEditingController();

  String? analyticalSelectedMaterial;

  List<Map<String, dynamic>> analyticalDetailControllers = [];
  List<String> analyticalParameters = [
    'Moisture Atas %',
    'Moisture Tengah %',
    'Moisture Bawah %',
    'Burn Test, minutes',
  ];

  final PageController analyticalPageControllers = PageController();

  // final TextEditingController gradeController = TextEditingController();
  // final TextEditingController packingController = TextEditingController();
  // final TextEditingController coaQuantityController = TextEditingController();
  // final TextEditingController noDocController = TextEditingController();

  // final TextEditingController vehicleController = TextEditingController();
  // final TextEditingController lotNoController = TextEditingController();

  // final TextEditingController tanggalPengirimanController =
  //     TextEditingController();
  // final TextEditingController productionDateController =
  //     TextEditingController();
  // final TextEditingController expiredDateController = TextEditingController();

  // String? coaSelectedMaterial;
  // List<Map<String, dynamic>> coaDetailControllers = [];
  // final PageController coaPageControllers = PageController();
  // List<String> coaParameters = [
  //   'Moisture',
  //   'pH',
  //   'Bulk Density',
  //   'ACIDITY',
  //   'PASSING MESH',
  //   'SURFACE AREA',
  //   'PORE VOLUME',
  // ];

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<ValueProvider>().fetchOilTypes();
    });

    for (int i = 0; i < analyticalParameters.length; i++) {
      analyticalDetailControllers.add({
        'parameter_name': analyticalParameters[i],
        'result_min': TextEditingController(),
        'result_max': TextEditingController(),
        'specification_min': TextEditingController(),
        'specification_max': TextEditingController(),
        'status': true,
        'remark': TextEditingController(),
      });
    }

    //   for (int i = 0; i < coaParameters.length; i++) {
    //     coaDetailControllers.add({
    //       'parameter_name': coaParameters[i],
    //       'actual_min': TextEditingController(),
    //       'actual_max': TextEditingController(),
    //       'standard_min': TextEditingController(),
    //       'standard_max': TextEditingController(),
    //       'method': TextEditingController(),
    //     });
    //   }
    // }
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
              Row(
                children: [
                  Text(
                    'Report of Analysis (ROA)',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 16.0),
              // _buildCoaInput(),
              SizedBox(height: 24.0),
              Divider(height: 2.0),
              SizedBox(height: 24.0),
              Row(
                children: [
                  Text(
                    'Analytical',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(height: 24.0),
              _buildAnalyticalInput(),

              Consumer<AnalyticalResultIncomingPlantChemicalIngredientProvider>(
                builder: (
                  BuildContext context,
                  AnalyticalResultIncomingPlantChemicalIngredientProvider
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

                          if (analyticalSelectedMaterial == null) {
                            showSnackBar("Oil Type wajib dipilih", context);
                            return;
                          }

                          // if (tanggalPengirimanController.text == "") {
                          //   showSnackBar("Tanggal Wajib dipilih", context);
                          //   return;
                          // }

                          final bool isSuccess = true;

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

  Widget _materialDropdown({
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
    );
  }

  // Helper untuk merapikan dekorasi agar tidak duplikasi kode

  Widget _buildAnalyticalInput() {
    return Column(
      children: [
        // ElevatedButton(
        //   onPressed: widget.onBack,
        //   child: const Text('Kembali ke COA'),
        // ),
        CustomDateField(
          controller: dateController,
          label: 'Date',
          icon: Icons.event,
        ),
        SizedBox(height: 12.0),
        _materialDropdown(
          context: context,
          selectedValue: analyticalSelectedMaterial,
          onChanged: (value) {
            setState(() {
              analyticalSelectedMaterial = value;
            });
          },
        ),
        SizedBox(height: 12.0),

        CustomTextField(
          controller: quantityController,
          label: "Quantity",
          icon: Icons.person_rounded,
          isNumeric: true,
        ),

        CustomTextField(
          controller: analystController,
          label: "Analyst",
          icon: Icons.person_rounded,
          isNumeric: false,
        ),

        SizedBox(height: 12.0),
        CustomTextField(
          controller: supplierController,
          label: "Supplier",
          icon: Icons.person_rounded,
          isNumeric: false,
        ),

        CustomTextField(
          controller: policeNumberController,
          label: "Police Number",
          icon: Icons.person_rounded,
          isNumeric: false,
        ),

        SizedBox(height: 12),

        ExpandablePageView.builder(
          controller: analyticalPageControllers,
          itemCount: analyticalParameters.length,
          itemBuilder: (context, pageIndex) {
            final row = analyticalDetailControllers[pageIndex];

            return SectionCard(
              title: analyticalParameters[pageIndex],
              children: [
                CustomTextField(
                  controller: row['result_min']!,
                  label: "Result Min",
                  icon: Icons.person_rounded,
                  isNumeric: true,
                ),

                CustomTextField(
                  controller: row['result_max']!,
                  label: "Result max",
                  icon: Icons.person_rounded,
                  isNumeric: true,
                ),

                CustomTextField(
                  controller: row['specification_min']!,
                  label: "Specification Min",
                  icon: Icons.person_rounded,
                  isNumeric: true,
                ),

                CustomTextField(
                  controller: row['specification_max']!,
                  label: "Specification Max",
                  icon: Icons.person_rounded,
                  isNumeric: true,
                ),
                CustomTextField(
                  controller: row['remark']!,
                  label: "Remark",
                  icon: Icons.person_rounded,
                  isNumeric: false,
                ),

                Row(
                  children: [
                    Checkbox(
                      value: row['status']!,
                      onChanged: (value) {
                        setState(() {
                          row['status'] = value!;
                        });
                      },
                    ),
                    Text("Status (OK)"),
                  ],
                ),
              ],
            );
          },
        ),
        SizedBox(height: 24.0),
        Center(
          child: SmoothPageIndicator(
            controller:
                analyticalPageControllers, // Gunakan satu controller untuk semua
            count: analyticalDetailControllers.length,
            effect: const WormEffect(
              dotHeight: 8,
              dotWidth: 8,
              activeDotColor: Colors.blue, // Sesuaikan warna tema Anda
              dotColor: Colors.grey,
            ),
            onDotClicked: (index) {
              analyticalPageControllers.animateToPage(
                index,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            },
          ),
        ),

        const SizedBox(height: 24.0),
      ],
    );
  }

  // Widget _buildCoaInput() {
  //   return Column(
  //     children: [
  //       // Di dalam _buildCoaInput()
  //       _materialDropdown(
  //         context: context,
  //         selectedValue: coaSelectedMaterial,
  //         onChanged: (value) {
  //           setState(() {
  //             coaSelectedMaterial = value;
  //           });
  //         },
  //       ),
  //       const SizedBox(height: 12.0),
  //       CustomTextField(
  //         controller: gradeController,
  //         label: "Grade",
  //         icon: Icons.person_rounded,
  //         isNumeric: false,
  //       ),

  //       CustomTextField(
  //         controller: packingController,
  //         label: "Packing",
  //         icon: Icons.person_rounded,
  //         // isNumeric: true,
  //       ),
  //       CustomTextField(
  //         controller: coaQuantityController,
  //         label: "Quantity",
  //         icon: Icons.person_rounded,
  //         isNumeric: true,
  //       ),

  //       CustomTextField(
  //         controller: noDocController,
  //         label: "No Doc",
  //         icon: Icons.person_rounded,
  //         isNumeric: false,
  //       ),

  //       CustomDateField(
  //         controller: tanggalPengirimanController,
  //         label: 'Tanggal Pengiriman',
  //         icon: Icons.event,
  //       ),
  //       const SizedBox(height: 8),

  //       CustomTextField(
  //         controller: vehicleController,
  //         label: "Vehicle",
  //         icon: Icons.person_rounded,
  //         isNumeric: false,
  //       ),

  //       CustomTextField(
  //         controller: lotNoController,
  //         label: "Lot No",
  //         icon: Icons.person_rounded,
  //         isNumeric: false,
  //       ),

  //       CustomDateField(
  //         controller: productionDateController,
  //         label: 'Production Date',
  //         icon: Icons.event,
  //       ),
  //       const SizedBox(height: 16),

  //       CustomDateField(
  //         controller: expiredDateController,
  //         label: 'Expired Date',
  //         icon: Icons.event,
  //       ),
  //       const SizedBox(height: 8),

  //       ExpandablePageView.builder(
  //         controller: coaPageControllers,
  //         itemCount: coaParameters.length,
  //         itemBuilder: (context, pageIndex) {
  //           final row = coaDetailControllers[pageIndex];

  //           return SectionCard(
  //             title: coaParameters[pageIndex],
  //             children: [
  //               CustomTextField(
  //                 controller: row['actual_min']!,
  //                 label: "Actual min",
  //                 icon: Icons.person_rounded,
  //                 isNumeric: true,
  //               ),

  //               CustomTextField(
  //                 controller: row['actual_max']!,
  //                 label: "Actual max",
  //                 icon: Icons.person_rounded,
  //                 isNumeric: true,
  //               ),

  //               CustomTextField(
  //                 controller: row['standard_max']!,
  //                 label: "Standard min",
  //                 icon: Icons.person_rounded,
  //                 isNumeric: true,
  //               ),

  //               CustomTextField(
  //                 controller: row['standard_min']!,
  //                 label: "Standard max",
  //                 icon: Icons.person_rounded,
  //                 isNumeric: true,
  //               ),
  //               CustomTextField(
  //                 controller: row['method']!,
  //                 label: "Method",
  //                 icon: Icons.person_rounded,
  //                 isNumeric: false,
  //               ),
  //             ],
  //           );
  //         },
  //       ),
  //       SizedBox(height: 24.0),
  //       Center(
  //         child: SmoothPageIndicator(
  //           controller:
  //               coaPageControllers, // Gunakan satu controller untuk semua
  //           count: coaDetailControllers.length,
  //           effect: const WormEffect(
  //             dotHeight: 8,
  //             dotWidth: 8,
  //             activeDotColor: Colors.blue, // Sesuaikan warna tema Anda
  //             dotColor: Colors.grey,
  //           ),
  //           onDotClicked: (index) {
  //             coaPageControllers.animateToPage(
  //               index,
  //               duration: const Duration(milliseconds: 300),
  //               curve: Curves.easeInOut,
  //             );
  //           },
  //         ),
  //       ),
  //     ],
  //   );
  // }

  // Future<bool> _insertData() async {
  //   final plant = context.read<PlantProvider>().currentPlant;
  //   final user = context.read<UserProvider>();
  //   final businessUnit =
  //       context.read<BusinessUnitProvider>().currentBusinessUnit;

  //   try {
  //     final analyticalDetails =
  //         analyticalDetailControllers.map((item) {
  //           return AnalyticalResultIncomingPlantChemicalIngredientDetailEntity(
  //             id: '',
  //             idHdr: '',
  //             specificationMin: parseDouble(item['specification_min'].text),
  //             specificationMax: parseDouble(item['specification_max'].text),
  //             statusOk: item['status'] == true ? 'Y' : 'N',
  //             parameter: item['parameter_name'],
  //             resultMin: parseDouble(item['result_min'].text),
  //             resultMax: parseDouble(item['result_max'].text),
  //             remark: item['remark'].text,
  //             deletedAt: null,
  //           );
  //         }).toList();

  //     final coaDetails =
  //         coaDetailControllers.map((item) {
  //           return CertificateOfAnalysisIncomingPlantChemicalIngredientDetailEntity(
  //             id: "",
  //             idHdr: "",
  //             parameter: item['parameter_name'],
  //             actualMin: parseDouble(item['actual_min'].text),
  //             actualMax: parseDouble(item['actual_max'].text),
  //             standardMin: parseDouble(item['standard_min'].text),
  //             standardMax: parseDouble(item['standard_max'].text),
  //             method: item['method'].text,
  //           );
  //         }).toList();

  //     final analyticalHeader =
  //         AnalyticalResultIncomingPlantChemicalIngredientHeaderEntity(
  //           id: '',
  //           idCoa: '',
  //           noRefCoa: noDocController.text,
  //           material: analyticalSelectedMaterial,
  //           quantity: parseDouble(quantityController.text),
  //           analyst: analystController.text,
  //           supplier: supplierController.text,
  //           policeNo: policeNumberController.text,
  //           batchLot: batchController.text,
  //           status: analyticalSelectedStatusValue,
  //           flag: 'T',
  //           entryBy: user.currentUser?.username ?? '',
  //           entryDate: DateTime.now(),
  //           preparedBy: '',
  //           preparedDate: null,
  //           preparedStatus: '',
  //           preparedStatusRemarks: '',
  //           approvedBy: '',
  //           approvedDate: null,
  //           approvedStatus: '',
  //           approvedStatusRemarks: '',
  //           updatedBy: '',
  //           updatedDate: null,
  //           formNo: '',
  //           dateIssued: null,
  //           revisionNo: '',
  //           revisionDate: null,
  //           details: analyticalDetails,
  //           date: changeStringDateFormat(
  //             dateController.text,
  //             'dd-MM-yyyy',
  //             'yyyy-MM-dd HH:mm:ss',
  //             returnDateTime: true,
  //           ),
  //           expDate: changeStringDateFormat(
  //             expDateController.text,
  //             'dd-MM-yyyy',
  //             'yyyy-MM-dd HH:mm:ss',
  //             returnDateTime: true,
  //           ),
  //         );

  //     final coaHeader =
  //         CertificateOfAnalysisIncomingPlantChemicalIngredientHeaderEntity(
  //           id: '',
  //           noDoc: noDocController.text,
  //           product: coaSelectedMaterial,
  //           grade: gradeController.text,
  //           packing: packingController.text,
  //           quantity: parseDouble(quantityController.text) ?? 0,
  //           tanggalPengiriman: changeStringDateFormat(
  //             tanggalPengirimanController.text,
  //             'dd-MM-yyyy',
  //             'yyyy-MM-dd HH:mm:ss',
  //             returnDateTime: true,
  //           ),

  //           vehicle: vehicleController.text,
  //           lotNo: lotNoController.text,
  //           productionDate: changeStringDateFormat(
  //             productionDateController.text,
  //             'dd-MM-yyyy',
  //             'yyyy-MM-dd HH:mm:ss',
  //             returnDateTime: true,
  //           ),
  //           expiredDate: changeStringDateFormat(
  //             expiredDateController.text,
  //             'dd-MM-yyyy',
  //             'yyyy-MM-dd HH:mm:ss',
  //             returnDateTime: true,
  //           ),
  //           issueBy: null,
  //           issueDate: null,
  //           details: coaDetails,
  //         );

  //     final isSuccess = await context
  //         .read<AnalyticalResultIncomingPlantChemicalIngredientProvider>()
  //         .insertReport(
  //           certificateOfAnalysisHeaderInput: coaHeader,
  //           analyticalResultHeaderInput: analyticalHeader,
  //         );

  //     return isSuccess;

  //     // return true;
  //   } catch (e) {
  //     debugPrint("Error inserting Analytical Incoming Material By Vessel: $e");
  //     return false;
  //   }
  // }
}
