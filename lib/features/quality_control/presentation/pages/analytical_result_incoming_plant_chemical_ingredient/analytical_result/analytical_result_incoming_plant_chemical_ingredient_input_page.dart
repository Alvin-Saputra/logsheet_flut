import 'dart:developer';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/widgets/custom_autocomplete.dart';
import 'package:logsheet_app/core/widgets/custom_radio_button.dart';
import 'package:logsheet_app/core/widgets/section_card.dart';
import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
import 'package:logsheet_app/core/widgets/custom_date_field.dart';
import 'package:logsheet_app/core/widgets/custom_save_button.dart';
import 'package:logsheet_app/core/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/core/widgets/custom_text_field.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/data_form_no_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/value_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_incoming_material_by_truck/analytical_result_incoming_material_by_truck_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AnalyticalResultIncomingPlantChemicalIngredientInputPage
    extends StatefulWidget {
  const AnalyticalResultIncomingPlantChemicalIngredientInputPage({super.key});

  @override
  State<AnalyticalResultIncomingPlantChemicalIngredientInputPage>
  createState() =>
      _AnalyticalResultIncomingPlantChemicalIngredientInputPageState();
}

class _AnalyticalResultIncomingPlantChemicalIngredientInputPageState
    extends State<AnalyticalResultIncomingPlantChemicalIngredientInputPage> {
  final _formKey = GlobalKey<FormState>();
  // --- Controllers for Material Info ---
  final TextEditingController dateController = TextEditingController();
  final TextEditingController quantityController = TextEditingController();
  final TextEditingController analystController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController policeNumberController = TextEditingController();
  final TextEditingController batchController = TextEditingController();
  final TextEditingController expDateController = TextEditingController();

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
        'result_min': TextEditingController(),
        'result_max': TextEditingController(),
        'specification_min': TextEditingController(),
        'specification_max': TextEditingController(),
        'status': true,
        'remark': TextEditingController(),
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
              CustomDateField(
                controller: dateController,
                label: 'Date',
                icon: Icons.event,
              ),
              SizedBox(height: 12.0),
              _materialDropdown(context),
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
                isNumeric: true,
              ),

              CustomAutocomplete(listofData: ["Value 1", "Value 2"]),

              SizedBox(height: 12.0),
              CustomTextField(
                controller: supplierController,
                label: "Supplier",
                icon: Icons.person_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: policeNumberController,
                label: "Police Number",
                icon: Icons.person_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: batchController,
                label: "Batch/Lot",
                icon: Icons.person_rounded,
                isNumeric: true,
              ),
              CustomDateField(
                controller: expDateController,
                label: 'Exp Date',
                icon: Icons.event,
              ),
              SizedBox(height: 12),
              CustomRadioButton(),

              SizedBox(height: 8),

              ExpandablePageView.builder(
                controller: pageControllers,
                itemCount: parameters.length,
                itemBuilder: (context, pageIndex) {
                  final row = detailControllers[pageIndex];

                  return SectionCard(
                    title: parameters[pageIndex],
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

  Widget _materialDropdown(BuildContext context) {
    return Consumer<ValueProvider>(
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
                  child: Text("${item.name}", style: TextStyle(fontSize: 14)),
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
    );
  }
}
