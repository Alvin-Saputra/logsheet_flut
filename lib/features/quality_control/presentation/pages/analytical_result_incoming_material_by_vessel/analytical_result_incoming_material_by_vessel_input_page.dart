import 'dart:developer';

import 'package:expandable_page_view/expandable_page_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_detail_entity.dart';
import 'package:logsheet_app/features/quality_control/data/model/analytical_result_incoming_material_by_vessel/analytical_result_incoming_material_by_vessel_header_entity.dart';
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

  final TextEditingController remarkController = TextEditingController();

  List<Map<String, TextEditingController>> detailControllers = [];
  DataFormNoEntity? formData;
  String? selectedOilType;
  int? numberOfRows;

  final PageController palkaSControllers = PageController();
  final PageController palkaCControllers = PageController();
  final PageController palkaPControllers = PageController();

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
            .where((form) => form.isMenu == "Change_Product_Checklist")
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
                      hintText: 'Loading Oil Types...',
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
                      hintText: 'Oil Types Tidak Ditemukan.',
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
                  value: selectedOilType,
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
                      selectedOilType = value;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF0ECE9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Pilih Work Center',
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
              label: 'Tanggal',
              icon: Icons.event,
            ),
            const SizedBox(height: 8),
            CustomTextField(
              controller: quantityController,
              label: 'Quantity',
              icon: Icons.storage_rounded,
              isNumeric: true,
            ),
            CustomTextField(
              controller: supplierController,
              label: 'Supplier',
              icon: Icons.person_rounded,
              isNumeric: false,
            ),
            CustomTextField(
              controller: shipNameController,
              label: "Ship's Name",
              icon: Icons.person_rounded,
              isNumeric: false,
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

            CustomRemarkField(controller: remarkController),
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
                        final bool isSuccess = await _insertData();
                        if (isSuccess) {
                          showSnackBar("Berhasil menyimpan data", context);
                          Navigator.of(context).pop();
                        } else {
                          showSnackBar("Gagal meyimpan data", context);
                        }
                      },
                    );
              },
            ),
          ],
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
                    palkaSControllers, // Gunakan satu controller untuk semua
                count: detailControllers.length,
                effect: const WormEffect(
                  dotHeight: 8,
                  dotWidth: 8,
                  activeDotColor: Colors.blue, // Sesuaikan warna tema Anda
                  dotColor: Colors.grey,
                ),
                onDotClicked: (index) {
                  palkaSControllers.animateToPage(
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
              controller: palkaSControllers, // Cukup satu controller utama
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
                          controller: row['palka_s_no']!,
                          label: "Palka S No",
                          icon: Icons.numbers,
                        ),
                        CustomTextField(
                          controller: row['palka_s_ffa']!,
                          label: "Palka S FFA",
                          icon: Icons.science,
                        ),
                        CustomTextField(
                          controller: row['palka_s_iv']!,
                          label: "Palka S IV",
                          icon: Icons.science,
                        ),
                        CustomTextField(
                          controller: row['palka_s_dobi']!,
                          label: "Palka S Dobi",
                          icon: Icons.science,
                        ),
                        CustomTextField(
                          controller: row['palka_s_mni']!,
                          label: "Palka S MNI",
                          icon: Icons.science,
                        ),
                      ]),

                      const SizedBox(height: 16),
                      const Divider(),

                      // --- FORM PALKA C ---
                      _buildSection("Palka C", [
                        CustomTextField(
                          controller: row['palka_c_no']!,
                          label: "Palka C No",
                          icon: Icons.numbers,
                        ),
                        CustomTextField(
                          controller: row['palka_c_ffa']!,
                          label: "Palka C FFA",
                          icon: Icons.science,
                        ),
                        CustomTextField(
                          controller: row['palka_c_iv']!,
                          label: "Palka C IV",
                          icon: Icons.science,
                        ),
                        CustomTextField(
                          controller: row['palka_c_dobi']!,
                          label: "Palka C Dobi",
                          icon: Icons.science,
                        ),
                        CustomTextField(
                          controller: row['palka_c_mni']!,
                          label: "Palka C MNI",
                          icon: Icons.science,
                        ),
                      ]),

                      const SizedBox(height: 16),
                      const Divider(),

                      // --- FORM PALKA P (Tambahkan jika diperlukan) ---
                      _buildSection("Palka P", [
                        CustomTextField(
                          controller: row['palka_p_no']!,
                          label: "Palka P No",
                          icon: Icons.numbers,
                        ),
                        CustomTextField(
                          controller: row['palka_p_ffa']!,
                          label: "Palka P FFA",
                          icon: Icons.science,
                        ),
                        CustomTextField(
                          controller: row['palka_p_iv']!,
                          label: "Palka P IV",
                          icon: Icons.science,
                        ),
                        CustomTextField(
                          controller: row['palka_p_dobi']!,
                          label: "Palka P Dobi",
                          icon: Icons.science,
                        ),
                        CustomTextField(
                          controller: row['palka_p_mni']!,
                          label: "Palka P MNI",
                          icon: Icons.science,
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
      final header = AnalyticalResultIncomingMaterialByVesselHeaderEntity(
        id: '',
        company: businessUnit?.buCode ?? '',
        plant: plant?.code ?? '',
        transactionDate: formattedDateEntry,
        material: selectedOilType ?? '',
        arrival: formattedDateEntry,
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
      );

      final detail =
          detailControllers.map((row) {
            return AnalyticalResultIncomingMaterialByVesselDetailEntity(
              id: "",
              idHdr: "",

              palkaSNo: parseDouble(row['palka_s_no']!.text),
              palkaSFfa: parseDouble(row['palka_s_ffa']!.text),
              palkaSIv: parseDouble(row['palka_s_iv']!.text),
              palkaSDobi: parseDouble(row['palka_s_dobi']!.text),
              palkaSMni: parseDouble(row['palka_s_mni']!.text),

              palkaCNo: parseDouble(row['palka_c_no']!.text),
              palkaCFfa: parseDouble(row['palka_c_ffa']!.text),
              palkaCIv: parseDouble(row['palka_c_iv']!.text),
              palkaCDobi: parseDouble(row['palka_c_dobi']!.text),
              palkaCMni: parseDouble(row['palka_c_mni']!.text),

              palkaPNo: parseDouble(row['palka_p_no']!.text),
              palkaPFfa: parseDouble(row['palka_p_ffa']!.text),
              palkaPIv: parseDouble(row['palka_p_iv']!.text),
              palkaPDobi: parseDouble(row['palka_p_dobi']!.text),
              palkaPMni: parseDouble(row['palka_p_mni']!.text),
            );
          }).toList();

      final isSuccess = await context
          .read<AnalyticalResultIncomingMaterialByVesselProvider>()
          .insertAnalyticalResultIncomingMaterialByVessel(
            headerInput: header,
            detailInput: detail,
            plantCode: plant?.code ?? '',
          );

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
