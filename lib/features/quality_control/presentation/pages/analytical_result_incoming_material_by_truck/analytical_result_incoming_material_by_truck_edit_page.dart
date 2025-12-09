import 'dart:developer';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
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
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_truck/analytical_result_incoming_material_by_truck_detail_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/local/analytical_result_incoming_material_by_truck/analytical_result_incoming_material_by_truck_header_entity.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_incoming_material_by_truck/analytical_result_incoming_material_by_truck_provider.dart';
import 'package:logsheet_app/features/quality_control/presentation/provider/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_provider.dart';
import 'package:provider/provider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class AnalyticalResultIncomingMaterialByTruckEditPage extends StatefulWidget {
  const AnalyticalResultIncomingMaterialByTruckEditPage({
    super.key,
    required this.data,
  });

  final AnalyticalResultIncomingMaterialByTruckHeaderEntity data;

  @override
  State<AnalyticalResultIncomingMaterialByTruckEditPage> createState() =>
      _AnalyticalResultIncomingMaterialByTruckEditPageState();
}

class _AnalyticalResultIncomingMaterialByTruckEditPageState
    extends State<AnalyticalResultIncomingMaterialByTruckEditPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController dateEntryController = TextEditingController();
  final TextEditingController supplierController = TextEditingController();
  final TextEditingController vesselVehicleController = TextEditingController();
  final TextEditingController contractDoController = TextEditingController();

  final TextEditingController ssFfaController = TextEditingController();
  final TextEditingController ssMniController = TextEditingController();
  final TextEditingController ssOthersController = TextEditingController();

  List<Map<String, TextEditingController>> detailControllers = [];
  DataFormNoEntity? formData;
  String? selectedMaterial;
  int? numberOfRows;

  final PageController pageControllers = PageController();

  late AnalyticalResultIncomingMaterialByTruckHeaderEntity updatedData;

  @override
  initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      await context.read<ValueProvider>().fetchOilTypes();

      setState(() {
        if (widget.data.material != null && widget.data.material!.isNotEmpty) {
          selectedMaterial = widget.data.material;
        } else {
          selectedMaterial = null;
        }
        dateEntryController.text = formatDatetoString(
          widget.data.arrival!,
          'dd-MM-yyyy',
        );

        supplierController.text = widget.data.supplier ?? '';
        contractDoController.text = widget.data.contractDoNomor ?? '';
        vesselVehicleController.text = widget.data.vesselVehicle ?? '';
        ssFfaController.text = widget.data.ssFfa.toString();
        ssMniController.text = widget.data.ssMni.toString();
        ssOthersController.text = widget.data.ssOthers ?? '';

        generateDetailRows(widget.data.details.length);
        print(widget.data.details.length);
        print(widget.data.details[0]);
        // print(widget.data.details[1]);

        var detail1 = widget.data.details[0];
        // var detail2 = widget.data.details[1];

        // log("detail index 1: ${widget.data.details[1]}");

        for (int i = 0; i < widget.data.details.length; i++) {
          detailControllers[i]['no']?.text =
              widget.data.details[i].no.toString();

          detailControllers[i]['sampling_date']?.text = formatDatetoString(
            widget.data.details[i].samplingDate!,
            'dd-MM-yyyy',
          );

          detailControllers[i]['police_no']?.text =
              widget.data.details[i].policeNo.toString();

          detailControllers[i]['p_ffa']?.text =
              widget.data.details[i].pFfa.toString();

          detailControllers[i]['p_moisture']?.text =
              widget.data.details[i].pMoisture.toString();

          detailControllers[i]['p_iv']?.text =
              widget.data.details[i].pIv.toString();

          detailControllers[i]['p_pv']?.text =
              widget.data.details[i].pPv.toString();

          detailControllers[i]['p_dobi']?.text =
              widget.data.details[i].pDobi.toString();

          detailControllers[i]['p_color_r']?.text =
              widget.data.details[i].pColorR.toString();

          detailControllers[i]['p_color_y']?.text =
              widget.data.details[i].pColorY.toString();

          detailControllers[i]['analis']?.text =
              widget.data.details[i].analis ?? '';

          detailControllers[i]['remark']?.text =
              widget.data.details[i].remarks ?? '';
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
        "Analytical Result Incoming Material By Truck Edit (${formData!.code})",
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
              const SizedBox(height: 8),
              CustomDateField(
                controller: dateEntryController,
                label: 'Arrival Date',
                icon: Icons.event,
              ),
              const SizedBox(height: 8),

              CustomTextField(
                controller: contractDoController,
                label: "Contract/D.O Nomor",
                icon: Icons.person_rounded,
                isNumeric: false,
              ),

              CustomTextField(
                controller: supplierController,
                label: 'Supplier',
                icon: Icons.person_rounded,
                isNumeric: false,
                isRequired: true,
              ),

              CustomTextField(
                controller: vesselVehicleController,
                label: "Vessel/Vehicle",
                icon: Icons.person_rounded,
                isNumeric: false,
                isRequired: true,
              ),

              CustomTextField(
                controller: ssFfaController,
                label: "FFA (%)",
                icon: Icons.person_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: ssMniController,
                label: "M&I (%)",
                icon: Icons.person_rounded,
                isNumeric: true,
              ),

              CustomTextField(
                controller: ssOthersController,
                label: "Others",
                icon: Icons.person_rounded,
                isNumeric: false,
              ),

              if (detailControllers.isNotEmpty) _detailFormList(),

              const SizedBox(height: 8.0),

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

                          if (dateEntryController.text == "") {
                            showSnackBar("Tanggal Wajib dipilih", context);
                            return;
                          }

                          if (!_validateDetailRows(context)) return;

                          final bool isSuccess = await _updateData();

                          if (isSuccess) {
                            showSnackBar("Berhasil menyimpan data", context);
                            Navigator.of(context).pop(updatedData);
                          } else {
                            showSnackBar("Gagal menyimpan data", context);
                          }
                        },
                        label: "Update Data",
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
        'no': TextEditingController(),
        'sampling_date': TextEditingController(),
        'police_no': TextEditingController(),
        'p_ffa': TextEditingController(),
        'p_moisture': TextEditingController(),
        'p_iv': TextEditingController(),
        'p_pv': TextEditingController(),
        'p_dobi': TextEditingController(),
        'p_color_r': TextEditingController(),
        'p_color_y': TextEditingController(),
        'analis': TextEditingController(),
        'remark': TextEditingController(),
      });
    }

    setState(() {});
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

                return SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
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

                      _buildSection("Analytical Detail Input", [
                        CustomTextField(
                          controller: row['no']!,
                          label: "No",
                          icon: Icons.numbers,
                        ),
                        CustomDateField(
                          controller: row['sampling_date']!,
                          label: 'Sampling Date',
                          icon: Icons.event,
                        ),
                        SizedBox(height: 12.0),
                        CustomTextField(
                          controller: row['police_no']!,
                          label: "Police No",
                          icon: Icons.science,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: row['p_ffa']!,
                          label: "FFA",
                          icon: Icons.science,
                          isNumeric: true,
                        ),

                        CustomTextField(
                          controller: row['p_moisture']!,
                          label: "Moisture",
                          icon: Icons.science,
                          isNumeric: true,
                        ),
                        CustomTextField(
                          controller: row['p_iv']!,
                          label: "IV",
                          icon: Icons.science,
                          isNumeric: true,
                        ),

                        CustomTextField(
                          controller: row['p_dobi']!,
                          label: "DOBI",
                          icon: Icons.science,
                          isNumeric: true,
                        ),

                        CustomTextField(
                          controller: row['p_pv']!,
                          label: "PV",
                          icon: Icons.science,
                          isNumeric: true,
                        ),

                        CustomTextField(
                          controller: row['p_color_r']!,
                          label: "Color R",
                          icon: Icons.science,
                          isNumeric: true,
                        ),

                        CustomTextField(
                          controller: row['p_color_y']!,
                          label: "Color Y",
                          icon: Icons.science,
                          isNumeric: true,
                        ),

                        CustomTextField(
                          controller: row['analis']!,
                          label: "Analis",
                          icon: Icons.science,
                          isNumeric: false,
                        ),

                        CustomTextField(
                          controller: row['remark']!,
                          label: "Remarks",
                          icon: Icons.science,
                          isNumeric: false,
                        ),
                      ]),
                      // --- FORM PALKA P (Tambahkan jika diperlukan) ---
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

  Future<bool> _updateData() async {
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
            final oldDetail = widget.data.details[index];

            return AnalyticalResultIncomingMaterialByTruckDetailEntity(
              id: oldDetail.id,
              idHdr: oldDetail.idHdr,
              no: row['no']!.text,
              samplingDate: changeStringDateFormat(
                row['sampling_date']!.text,
                'dd-MM-yyyy',
                'yyyy-MM-dd HH:mm:ss',
                returnDateTime: true,
              ),
              policeNo: row['police_no']!.text,
              pFfa: parseDouble(row['p_ffa']!.text),
              pMoisture: parseDouble(row['p_moisture']!.text),
              pIv: parseDouble(row['p_iv']!.text),
              pDobi: parseDouble(row['p_dobi']!.text),
              pPv: parseDouble(row['p_pv']!.text),
              pColorR: parseDouble(row['p_color_r']!.text),
              pColorY: parseDouble(row['p_color_y']!.text),
              analis: row['analis']!.text,
              remarks: row['remark']!.text,
            );
          }).toList();

      final header = AnalyticalResultIncomingMaterialByTruckHeaderEntity(
        id: widget.data.id,
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
        supplier: supplierController.text,
        vesselVehicle: vesselVehicleController.text,
        contractDoNomor: contractDoController.text,
        ssFfa: parseDouble(ssFfaController.text),
        ssMni: parseDouble(ssMniController.text),
        ssOthers: ssOthersController.text,

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

      final isSuccess = await context
          .read<AnalyticalResultIncomingMaterialByTruckProvider>()
          .updateReport(headerInput: header, menuId: formData?.isMenu ?? '');
      updatedData = header;
      return isSuccess;
    } catch (e) {
      debugPrint("Error inserting Analytical Incoming Material By Vessel: $e");
      return false;
    }
  }

  bool _validateDetailRows(BuildContext context) {
    for (int i = 0; i < detailControllers.length; i++) {
      final row = detailControllers[i];

      for (final entry in row.entries) {
        if (entry.value.text.trim().isEmpty) {
          showSnackBar(
            // "Field ${entry.key} di detail ke-${i + 1} wajib diisi",
            "Semua Field Detail Wajib Diisi",
            context,
          );
          return false;
        }
      }
    }
    return true;
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
