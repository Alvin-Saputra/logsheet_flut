import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_fuel/analytical_result/analytical_result_incoming_plant_fuel_detail_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_fuel/analytical_result/analytical_result_incoming_plant_fuel_header_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_fuel/report_of_analysis/report_of_analysis_incoming_plant_fuel_detail_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_plant_fuel/report_of_analysis/report_of_analysis_incoming_plant_fuel_header_entity.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_incoming_plant_fuel/analytical_result_incoming_plant_fuel_provider.dart';
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

  final TextEditingController reportNoController = TextEditingController();
  final TextEditingController shipperController = TextEditingController();
  final TextEditingController buyerController = TextEditingController();
  final TextEditingController dateReceivedController = TextEditingController();
  final TextEditingController dateAnalyzedStartController =
      TextEditingController();
  final TextEditingController dateAnalyzedEndController =
      TextEditingController();
  final TextEditingController dateReportedController = TextEditingController();
  final TextEditingController labSampleIdController = TextEditingController();
  final TextEditingController customerSampleIdController =
      TextEditingController();
  final TextEditingController sealNoController = TextEditingController();
  final TextEditingController weightofReceivedSampleController =
      TextEditingController();
  final TextEditingController topSizeofReceivedSampleController =
      TextEditingController();

  final TextEditingController hardGrooveGrindabilityIndexController =
      TextEditingController();

  String? roaSelectedMaterial;

  final PageController roaPageControllers = PageController();

  List<Map<String, dynamic>> roaDetailControllers = [];
  List<String> roaParameters = [
    'Total Moisture',
    'Moisture in The Analysis Sample',
    'Ash Content',
    'Volatile Matter',
    'Fixed Carbon',
    'Total Sulphur',
    'Gross Calorific Value',
    'Gross Calorific Value',
  ];

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<ValueProvider>().fetchOilTypes();
    });

    for (int i = 0; i < analyticalParameters.length; i++) {
      analyticalDetailControllers.add({
        'parameter_name': analyticalParameters[i],
        'result': TextEditingController(),
        'specification': TextEditingController(),
        'status': true,
        'remark': TextEditingController(),
      });
    }

    for (int i = 0; i < roaParameters.length; i++) {
      roaDetailControllers.add({
        'parameter_name': roaParameters[i],
        'unit': TextEditingController(),
        'basis': TextEditingController(),
        'result': TextEditingController(),
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
                  "Analytical_Result_of_Incoming_Plant_Fuel_Solar_Coal",
            )
            .first;
    return AppBar(
      title: Text(
        "Analytical Result of Incoming Plant Fuel Solar Input (${formData!.code})",
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
              _buildRoaInput(),
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

              Consumer<AnalyticalResultIncomingPlantFuelProvider>(
                builder: (
                  BuildContext context,
                  AnalyticalResultIncomingPlantFuelProvider provider,
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
                            showSnackBar(
                              "Material Type wajib dipilih",
                              context,
                            );
                            return;
                          }

                          // if (tanggalPengirimanController.text == "") {
                          //   showSnackBar("Tanggal Wajib dipilih", context);
                          //   return;
                          // }
                          if (!_validateDetailRows(context, "ROA")) return;

                          if (!_validateDetailRows(context, "Analytical"))
                            return;

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

  Widget _materialDropdown({
    required BuildContext context,
    required String? selectedValue,
    required Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      items:
          ['Solar', 'Coal'].map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text("${item}", style: const TextStyle(fontSize: 14)),
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
                  controller: row['result']!,
                  label: "Result",
                  icon: Icons.person_rounded,
                  isNumeric: true,
                  isRequired: true,
                ),

                CustomTextField(
                  controller: row['specification']!,
                  label: "Specification",
                  icon: Icons.person_rounded,
                  isNumeric: true,
                  isRequired: true,
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

  Widget _buildRoaInput() {
    return Column(
      children: [
        // Di dalam _buildCoaInput()
        const SizedBox(height: 12.0),
        CustomTextField(
          controller: reportNoController,
          label: "Report No",
          icon: Icons.person_rounded,
          isNumeric: false,
        ),

        CustomTextField(
          controller: shipperController,
          label: "Shipper",
          icon: Icons.person_rounded,
          // isNumeric: true,
        ),

        CustomTextField(
          controller: buyerController,
          label: "Buyer",
          icon: Icons.person_rounded,
          // isNumeric: true,
        ),

        CustomDateField(
          controller: dateReceivedController,
          label: 'Date Received',
          icon: Icons.event,
        ),
        const SizedBox(height: 16),

        CustomDateField(
          controller: dateAnalyzedStartController,
          label: 'Date Analyzed Start',
          icon: Icons.event,
        ),
        const SizedBox(height: 8),

        CustomDateField(
          controller: dateAnalyzedEndController,
          label: 'Date Analyzed End',
          icon: Icons.event,
        ),
        const SizedBox(height: 8),

        CustomDateField(
          controller: dateReportedController,
          label: 'Date Analyzed Reported',
          icon: Icons.event,
        ),

        const SizedBox(height: 8),

        CustomTextField(
          controller: labSampleIdController,
          label: "Lab Sample ID",
          icon: Icons.person_rounded,
          // isNumeric: true,
        ),

        CustomTextField(
          controller: customerSampleIdController,
          label: "Customer Sample ID",
          icon: Icons.person_rounded,
          // isNumeric: true,
        ),

        CustomTextField(
          controller: sealNoController,
          label: "Seal No",
          icon: Icons.person_rounded,
          // isNumeric: true,
        ),

        CustomTextField(
          controller: weightofReceivedSampleController,
          label: "Weight of Received Sample",
          icon: Icons.person_rounded,
          isNumeric: true,
        ),
        CustomTextField(
          controller: topSizeofReceivedSampleController,
          label: "Top Size of Received Sample",
          icon: Icons.person_rounded,
          isNumeric: true,
        ),

        CustomTextField(
          controller: hardGrooveGrindabilityIndexController,
          label: "Hard Groove Grindability Index",
          icon: Icons.person_rounded,
          isNumeric: true,
        ),

        ExpandablePageView.builder(
          controller: roaPageControllers,
          itemCount: roaParameters.length,
          itemBuilder: (context, pageIndex) {
            final row = roaDetailControllers[pageIndex];

            return SectionCard(
              title: roaParameters[pageIndex],
              children: [
                CustomTextField(
                  controller: row['unit']!,
                  label: "Unit",
                  icon: Icons.person_rounded,
                  isNumeric: false,
                  isRequired: true,
                ),

                CustomTextField(
                  controller: row['basis']!,
                  label: "Basis",
                  icon: Icons.person_rounded,
                  isNumeric: false,
                  isRequired: true,
                ),

                CustomTextField(
                  controller: row['result']!,
                  label: "Result",
                  icon: Icons.person_rounded,
                  isNumeric: true,
                  isRequired: true,
                ),
              ],
            );
          },
        ),
        SizedBox(height: 24.0),
        // Center(
        //   child: SmoothPageIndicator(
        //     controller:
        //         roaPageControllers, // Gunakan satu controller untuk semua
        //     count: coaDetailControllers.length,
        //     effect: const WormEffect(
        //       dotHeight: 8,
        //       dotWidth: 8,
        //       activeDotColor: Colors.blue, // Sesuaikan warna tema Anda
        //       dotColor: Colors.grey,
        //     ),
        //     onDotClicked: (index) {
        //       roaPageControllers.animateToPage(
        //         index,
        //         duration: const Duration(milliseconds: 300),
        //         curve: Curves.easeInOut,
        //       );
        //     },
        //   ),
        // ),
      ],
    );
  }

  Future<bool> _insertData() async {
    final plant = context.read<PlantProvider>().currentPlant;
    final user = context.read<UserProvider>();
    final businessUnit =
        context.read<BusinessUnitProvider>().currentBusinessUnit;

    try {
      final analyticalDetails =
          analyticalDetailControllers.map((item) {
            return AnalyticalResultIncomingPlantFuelDetailEntity(
              id: '',
              idHdr: '',
              specification: parseDouble(item['specification'].text) ?? 0,

              statusOk: item['status'] == true ? 'Y' : 'N',
              parameter: item['parameter_name'],
              result: parseDouble(item['result'].text) ?? 0,
              remark: item['remark'].text,
              deletedAt: null,
            );
          }).toList();

      final roaDetails =
          roaDetailControllers.map((item) {
            return ReportOfAnalysisIncomingPlantFuelDetailEntity(
              id: "",
              idHdr: "",
              parameter: item['parameter_name'],
              unit: item['unit'].text ?? '',
              basis: item['basis'].text ?? '',
              result: parseDouble(item['result'].text) ?? 0,
            );
          }).toList();

      final analyticalHeader = AnalyticalResultIncomingPlantFuelHeaderEntity(
        id: '',
        idRoa: '',
        company: businessUnit?.buCode ?? '',
        plant: plant?.code ?? '',
        material: analyticalSelectedMaterial ?? '',
        quantity: parseDouble(quantityController.text) ?? 0,
        analyst: analystController.text,
        supplier: supplierController.text,
        policeNo: policeNumberController.text,
        entryBy: user.currentUser?.username ?? '',
        entryDate: DateTime.now(),
        preparedBy: '',
        preparedDate: null,
        preparedStatus: '',
        preparedStatusRemarks: '',
        approvedBy: '',
        approvedDate: null,
        approvedStatus: '',
        approvedStatusRemarks: '',
        updatedBy: '',
        updatedDate: null,
        formNo: '',
        dateIssued: null,
        revisionNo: '',
        revisionDate: null,
        details: analyticalDetails,
        date: changeStringDateFormat(
          dateController.text,
          'dd-MM-yyyy',
          'yyyy-MM-dd',
          returnDateTime: true,
        ),
      );

      final roaHeader = ReportOfAnalysisIncomingPlantFuelHeaderEntity(
        id: '',
        details: roaDetails,
        reportNo: reportNoController.text,
        shipper: shipperController.text,
        buyer: buyerController.text,
        dateReceived:
            dateReceivedController.text != ''
                ? changeStringDateFormat(
                  dateReceivedController.text,
                  'dd-MM-yyyy',
                  'yyyy-MM-dd',
                  returnDateTime: true,
                )
                : null,
        dateAnalyzedStart: changeStringDateFormat(
          dateAnalyzedStartController.text,
          'dd-MM-yyyy',
          'yyyy-MM-dd',
          returnDateTime: true,
        ),
        dateAnalyzedEnd: changeStringDateFormat(
          dateAnalyzedEndController.text,
          'dd-MM-yyyy',
          'yyyy-MM-dd',
          returnDateTime: true,
        ),
        dateReported: changeStringDateFormat(
          dateReportedController.text,
          'dd-MM-yyyy',
          'yyyy-MM-dd',
          returnDateTime: true,
        ),
        labSampleId: labSampleIdController.text,
        customerSampleId: customerSampleIdController.text,
        sealNo: sealNoController.text,
        weightofReceivedSample:
            parseDouble(weightofReceivedSampleController.text) ?? 0,
        topSizeofReceivedSample:
            parseDouble(topSizeofReceivedSampleController.text) ?? 0,
        authorizedBy: user.currentUser?.username ?? '',
        authorizedDate: DateTime.now(),
        hardGrooveGrindabilityIndex:
            parseDouble(hardGrooveGrindabilityIndexController.text) ?? 0,
      );

      final isSuccess = await context
          .read<AnalyticalResultIncomingPlantFuelProvider>()
          .insertReport(
            reportOfAnalysisHeaderInput: roaHeader,
            analyticalResultHeaderInput: analyticalHeader,
          );

      return isSuccess;

      // return true;
    } catch (e) {
      debugPrint("Error inserting Analytical Incoming Plant Fuel: $e");
      return false;
    }
  }

  bool _validateDetailRows(BuildContext context, String fromDetails) {
    // Tentukan key mana saja yang WAJIB diisi
    // Sesuaikan string ini dengan key yang Anda buat di function generateDetailRows

    if (fromDetails != "ROA") {
      final List<String> mandatoryKeys = ['unit', 'basis', 'result'];

      for (int i = 0; i < roaDetailControllers.length; i++) {
        final row = roaDetailControllers[i];
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
          roaPageControllers.animateToPage(
            i,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );

          // 2. Tampilkan pesan
          showSnackBar(
            "Detail ke-${i + 1} Report of Analysis belum lengkap.",
            context,
          );

          return false; // Validasi gagal
        }
      }
      return true; // Validasi sukses
    }

    if (fromDetails != "Analytical") {
      final List<String> mandatoryKeys = ['result', 'specification'];

      for (int i = 0; i < analyticalDetailControllers.length; i++) {
        final row = analyticalDetailControllers[i];
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
          analyticalPageControllers.animateToPage(
            i,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeIn,
          );

          // 2. Tampilkan pesan
          showSnackBar(
            "Detail ke-${i + 1} Analytical belum lengkap.",
            context,
          );

          return false; // Validasi gagal
        }
      }
      return true; // Validasi sukses
    } else {
      return true;
    }
  }
}
