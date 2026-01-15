import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';
import 'package:logsheet_app/core/widgets/custom_app_bar.dart';
import 'package:logsheet_app/core/widgets/custom_date_field.dart';
import 'package:logsheet_app/core/widgets/custom_hour_minute_field.dart';
import 'package:logsheet_app/core/widgets/custom_hour_minute_picker.dart';
import 'package:logsheet_app/core/widgets/custom_save_button.dart';
import 'package:logsheet_app/core/widgets/custom_text.dart';
import 'package:logsheet_app/core/widgets/custom_text_field.dart';
import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/data_form_no_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/value_provider.dart';
import 'package:logsheet_app/features/production/data/model/dry_fractionation/local/dry_fractionation_detail_entity.dart';
import 'package:logsheet_app/features/production/data/model/dry_fractionation/local/dry_fractionation_header_entity.dart';
import 'package:logsheet_app/features/production/presentation/pages/dry_fractionation/dry_fractionation_input_item.dart';
import 'package:logsheet_app/features/production/presentation/provider/dry_fractionation/dry_fractionation_provider.dart';
import 'package:provider/provider.dart';

class DryFractionationEditPage extends StatefulWidget {
  const DryFractionationEditPage({super.key, required this.data});

  final DryFractionationHeaderEntity data;

  @override
  State<DryFractionationEditPage> createState() =>
      _DryFractionationEditPageState();
}

class _DryFractionationEditPageState extends State<DryFractionationEditPage> {
  DataFormNoEntity? formData;
  final TextEditingController dateController = TextEditingController();
  final TextEditingController feedOilIvController = TextEditingController();

  final TextEditingController initialOilLevelController =
      TextEditingController();
  final TextEditingController coolingStartTempController =
      TextEditingController();
  final TextEditingController agitatorSpeedController = TextEditingController();
  final TextEditingController waterPumpPresController = TextEditingController();

  String? selectedCrystallizer;
  TimeOfDay? selectedFillingStartTime;
  TimeOfDay? selectedFillingEndTime;
  TimeOfDay?
  selectedCoolingStartTime; // Variabel ini ada tapi belum dipakai sebelumnya

  List<DryFractionationInputItem> inputItems = [];
  void _addNewRow() {
    setState(() {
      inputItems.add(DryFractionationInputItem());
    });
  }

  // Fungsi Hapus Row
  void _removeRow(int index) {
    setState(() {
      inputItems.removeAt(index);
    });
  }

  @override
  void initState() {
    super.initState();
    if (widget.data.id.isNotEmpty) {
      _populateData();
    } else {
      // Jika mode Create Baru, set tanggal hari ini & tambah 1 baris kosong
      dateController.text =
          formatDatetoString(DateTime.now(), 'dd-MM-yyyy') ?? '';
      _addNewRow();
    }
  }

  void _populateData() {
    final data = widget.data;

    // --- 1. POPULATE HEADER ---

    // Date (Convert DateTime ke String format dd-MM-yyyy)
    if (data.date != null) {
      dateController.text =
          formatDatetoString(DateTime.now(), 'dd-MM-yyyy') ?? '';
    }

    // Dropdown
    selectedCrystallizer = data.crystallizer;

    // Numeric Fields (Pastikan handle null dengan '??')
    feedOilIvController.text = data.feedOilIv?.toString() ?? '';
    initialOilLevelController.text = data.initialOilLevel?.toString() ?? '';
    coolingStartTempController.text = data.coolingStartTemp?.toString() ?? '';
    agitatorSpeedController.text = data.agitatorSpeed?.toString() ?? '';
    waterPumpPresController.text = data.waterPumpPres?.toString() ?? '';

    // Time Pickers (Entity Anda sudah TimeOfDay, jadi tinggal assign)
    selectedFillingStartTime = data.fillingStartTime;
    selectedFillingEndTime = data.fillingEndTime;
    selectedCoolingStartTime = data.coolingStartTime;

    // --- 2. POPULATE DETAILS ---

    if (data.details.isNotEmpty) {
      // Bersihkan list bawaan jika ada
      inputItems.clear();

      for (var detail in data.details) {
        // Buat object Input Item baru (yang berisi controller2 kosong)
        var item = DryFractionationInputItem();
        item.id = detail.id;
        // Isi controller di dalam item tersebut dengan data detail
        item.filtrationTempController.text =
            detail.filtrationTemp?.toString() ?? '';
        item.loadController.text = detail.load?.toString() ?? '';
        item.oleinIvController.text = detail.oleinIv?.toString() ?? '';
        item.oleinCpController.text = detail.oleinCp?.toString() ?? '';
        item.oleinFfaController.text = detail.oleinFfa?.toString() ?? '';
        item.oleinColorRedController.text =
            detail.oleinColorRed?.toString() ?? '';
        item.stearinIvController.text = detail.stearinIv?.toString() ?? '';
        item.stearinFfaController.text = detail.stearinFfa?.toString() ?? '';
        item.stearinColorRedController.text =
            detail.stearinColorRed?.toString() ?? '';
        item.stearinPvController.text = detail.stearinPv?.toString() ?? '';

        // Isi TimeOfDay untuk detail
        item.timeStartFiltration = detail.timeStartFiltration;
        item.timeEndFiltration = detail.timeEndFiltration;

        // Masukkan item yang sudah terisi ke list utama
        inputItems.add(item);
      }
    } else {
      // Jika header ada tapi detail kosong (jarang terjadi), kasih 1 baris kosong
      _addNewRow();
    }

    // Trigger rebuild UI agar data tampil
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    formData =
        context
            .read<DataFormNoProvider>()
            .dataFormNoList
            .where((form) => form.isMenu == "Logsheet_Dry_Fractionation")
            .first;
    return Scaffold(
      appBar: CustomAppBar(title: 'Dry Fractionation (${formData?.code})'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Dry Fractionation Data',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            // --- DATE ---
            CustomText(
              text: "Date",
              size: 16,
              weight: FontWeight.w600,
              color: Colors.black,
            ),
            const SizedBox(height: 8.0),
            CustomDateField(
              controller: dateController,
              label: 'Date',
              icon: Icons.event,
            ),

            const SizedBox(height: 16.0),

            // --- CRYSTALLIZER ---
            CustomText(
              text: "Crystallizer",
              size: 16,
              weight: FontWeight.w600,
              color: Colors.black,
            ),
            const SizedBox(height: 8.0),
            Consumer<ValueProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  ); // Disederhanakan untuk contoh
                }
                if (provider.tankSourceList.isEmpty) {
                  return TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF0ECE9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'CR List tidak ditemukan.',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(Icons.warning_amber_rounded),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () async {
                          await context
                              .read<ValueProvider>()
                              .fetchTankSourceLists();
                        },
                      ),
                    ),
                  );
                }
                return DropdownButtonFormField(
                  value: selectedCrystallizer,
                  items:
                      provider.tankSourceList
                          .where((element) => element.category == "CR")
                          .map((tank) {
                            return DropdownMenuItem(
                              value: tank.code,
                              child: Text("${tank.code} | ${tank.name}"),
                            );
                          })
                          .toList(),
                  onChanged:
                      (value) => setState(() => selectedCrystallizer = value),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Select Crystallizer',
                  ),
                );
              },
            ),

            const SizedBox(height: 16.0),

            // --- FEED OIL IV ---
            CustomText(
              text: "Feed Oil IV",
              size: 16,
              weight: FontWeight.w600,
              color: Colors.black,
            ),
            const SizedBox(height: 8.0),
            CustomTextField(
              controller: feedOilIvController,
              label: 'Feed Oil IV',
              icon: Icons.place_rounded,
              isNumeric: true,
            ),

            const SizedBox(height: 16.0),

            // --- FILLING START TIME ---
            CustomText(
              text: "Filling Time",
              size: 16,
              weight: FontWeight.w600,
              color: Colors.black,
            ),
            const SizedBox(height: 8.0),
            CustomHourMinuteField(
              selectedTime: selectedFillingStartTime,
              onTap:
                  () =>
                      _showHourPicker(context, selectedFillingStartTime, (val) {
                        setState(() {
                          selectedFillingStartTime = val;
                        });
                      }),
              hint: "Filling Start Time",
            ),

            const SizedBox(height: 8.0),
            CustomHourMinuteField(
              selectedTime: selectedFillingEndTime,
              onTap:
                  () => _showHourPicker(context, selectedFillingEndTime, (val) {
                    setState(() {
                      selectedFillingEndTime = val;
                    });
                  }),
              hint: "Filling End Time",
            ),

            const SizedBox(height: 12.0),

            // --- INITIAL OIL LEVEL ---
            CustomText(
              text: "Initial Oil Level",
              size: 16,
              weight: FontWeight.w600,
              color: Colors.black,
            ),
            const SizedBox(height: 8.0),
            CustomTextField(
              controller: initialOilLevelController,
              label: "Initial Oil Level",
              icon: Icons.place_rounded,
              isNumeric: true,
            ),

            const SizedBox(height: 8.0),

            // --- COOLING START TEMP ---
            CustomText(
              text: "Cooling Start Temp",
              size: 16,
              weight: FontWeight.w600,
              color: Colors.black,
            ),
            const SizedBox(height: 8.0),
            CustomTextField(
              controller: coolingStartTempController,
              label: "Cooling Start Temp",
              icon: Icons.place_rounded,
              isNumeric: true,
            ),

            const SizedBox(height: 8.0),

            // --- COOLING START TIME ---
            CustomText(
              text: "Cooling Start Time",
              size: 16,
              weight: FontWeight.w600,
              color: Colors.black,
            ),
            const SizedBox(height: 8.0),
            CustomHourMinuteField(
              selectedTime: selectedCoolingStartTime,
              onTap:
                  () =>
                      _showHourPicker(context, selectedCoolingStartTime, (val) {
                        setState(() {
                          selectedCoolingStartTime = val;
                        });
                      }),
            ),

            const SizedBox(height: 16.0),

            // --- AGITATOR SPEED ---
            CustomText(
              text: "Agitator Speed (HZ)",
              size: 16,
              weight: FontWeight.w600,
              color: Colors.black,
            ),
            const SizedBox(height: 8.0),
            CustomTextField(
              controller: agitatorSpeedController,
              label: "Agitator Speed",
              icon: Icons.place_rounded,
              isNumeric: true,
            ),

            const SizedBox(height: 8.0),

            // --- WATER PUMP PRESS ---
            CustomText(
              text: "Water Pump Press",
              size: 16,
              weight: FontWeight.w600,
              color: Colors.black,
            ),
            const SizedBox(height: 8.0),
            CustomTextField(
              controller: waterPumpPresController,
              label: "Water Pump Press",
              icon: Icons.place_rounded,
              isNumeric: true,
            ),

            const SizedBox(height: 24.0),
            const Divider(thickness: 2),
            const SizedBox(height: 16.0),

            // --- TITLE DETAILS ---
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Text(
                  'Dry Fractionation Details',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // --- LIST DETAILS ---
            ...List.generate(inputItems.length, (index) {
              return Card(
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 24),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    // Header Card
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
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
                            "Set Data #${index + 1}",
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          if (inputItems.length > 1)
                            InkWell(
                              onTap: () => _removeRow(index),
                              child: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                            ),
                        ],
                      ),
                    ),
                    // Content Card
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // 1. Filtration Temp
                          CustomText(
                            text: "Filtration Temp",
                            size: 16,
                            weight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 8.0),
                          CustomTextField(
                            controller:
                                inputItems[index].filtrationTempController,
                            label: "Filtration Temp",
                            icon: Icons.thermostat,
                            isNumeric: true,
                          ),
                          const SizedBox(height: 8.0),

                          // 2. Load
                          CustomText(
                            text: "Load",
                            size: 16,
                            weight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 8.0),
                          CustomTextField(
                            controller: inputItems[index].loadController,
                            label: "Load",
                            icon: Icons.thermostat,
                            isNumeric: true,
                          ),
                          const SizedBox(height: 8.0),

                          // 3. Olein IV
                          CustomText(
                            text: "Olein IV",
                            size: 16,
                            weight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 8.0),
                          CustomTextField(
                            controller: inputItems[index].oleinIvController,
                            label: "Olein IV",
                            icon: Icons.thermostat,
                            isNumeric: true,
                          ),
                          const SizedBox(height: 8.0),

                          // 4. Olein CP
                          CustomText(
                            text: "Olein CP",
                            size: 16,
                            weight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 8.0),
                          CustomTextField(
                            controller: inputItems[index].oleinCpController,
                            label: "Olein CP",
                            icon: Icons.thermostat,
                            isNumeric: true,
                          ),
                          const SizedBox(height: 8.0),

                          // 5. Olein FFA
                          CustomText(
                            text: "Olein FFA",
                            size: 16,
                            weight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 8.0),
                          CustomTextField(
                            controller: inputItems[index].oleinFfaController,
                            label: "Olein FFA",
                            icon: Icons.thermostat,
                            isNumeric: true,
                          ),
                          const SizedBox(height: 8.0),

                          // 6. Olein Color Red
                          CustomText(
                            text: "Olein Color Red",
                            size: 16,
                            weight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 8.0),
                          CustomTextField(
                            controller:
                                inputItems[index].oleinColorRedController,
                            label: "Olein Color Red",
                            icon: Icons.thermostat,
                            isNumeric: true,
                          ),
                          const SizedBox(height: 8.0),

                          // 7. Stearin IV
                          CustomText(
                            text: "Stearin IV",
                            size: 16,
                            weight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 8.0),
                          CustomTextField(
                            controller: inputItems[index].stearinIvController,
                            label: "Stearin IV",
                            icon: Icons.thermostat,
                            isNumeric: true,
                          ),
                          const SizedBox(height: 8.0),

                          // 8. Stearin FFA
                          CustomText(
                            text: "Stearin FFA",
                            size: 16,
                            weight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 8.0),
                          CustomTextField(
                            controller: inputItems[index].stearinFfaController,
                            label: "Stearin FFA",
                            icon: Icons.thermostat,
                            isNumeric: true,
                          ),
                          const SizedBox(height: 8.0),

                          // 9. Stearin Color Red
                          CustomText(
                            text: "Stearin Color Red",
                            size: 16,
                            weight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 8.0),
                          CustomTextField(
                            controller:
                                inputItems[index].stearinColorRedController,
                            label: "Stearin Color Red",
                            icon: Icons.thermostat,
                            isNumeric: true,
                          ),
                          const SizedBox(height: 8.0),

                          // 10. Stearin PV
                          CustomText(
                            text: "Stearin PV",
                            size: 16,
                            weight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 8.0),
                          CustomTextField(
                            controller: inputItems[index].stearinPvController,
                            label: "Stearin PV",
                            icon: Icons.thermostat,
                            isNumeric: true,
                          ),
                          const SizedBox(height: 8.0),

                          // 11. Time Start Filtration
                          CustomText(
                            text: "Time Start Filtration",
                            size: 16,
                            weight: FontWeight.w600,
                            color: Colors.black,
                          ),
                          const SizedBox(height: 8.0),
                          CustomHourMinuteField(
                            selectedTime: inputItems[index].timeStartFiltration,
                            onTap:
                                () => _showHourPicker(
                                  context,
                                  inputItems[index].timeStartFiltration,
                                  (val) {
                                    setState(() {
                                      inputItems[index].timeStartFiltration =
                                          val;
                                    });
                                  },
                                ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),

            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 24),
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

            CustomSaveButton(onPressed: _onSubmit),
            const SizedBox(height: 30), // Extra space bottom
          ],
        ),
      ),
    );
  }

  // --- PERBAIKAN FUNGSI _showHourPicker ---
  void _showHourPicker(
    BuildContext context,
    TimeOfDay? selectedTime,
    Function(TimeOfDay) onTimeSelected,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: CustomHourMinutePicker(
              selectedTime: selectedTime,
              onTimeSelected: (time) {
                onTimeSelected(time);
                // If you want the dialog to close immediately after selection, uncomment the line below:
                // Navigator.of(context).pop();
              },
            ),
          ),
        );
      },
    );
  }

  Future<void> _onSubmit() async {
    // 1. Validasi Dasar (Contoh sederhana)

    // 2. Mapping Details (List InputItem -> List Entity)
    List<DryFractionationDetailEntity> detailEntities = [];

    for (int i = 0; i < inputItems.length; i++) {
      var item = inputItems[i];

      detailEntities.add(
        DryFractionationDetailEntity(
          id: item.id ?? '',
          filtrationCycleNumber: i + 1, // Otomatis 1, 2, 3...
          // Asumsi inputItems menyimpan DateTime di variabel terpisah atau parsing controller
          filtrationDate:
              DateTime.now(), // Sebaiknya ambil dari inputItems[i].selectedDate jika ada
          filtrationTemp: parseDouble(item.filtrationTempController.text),
          timeStartFiltration: item.timeStartFiltration, // Konversi disini
          timeEndFiltration: item.timeEndFiltration, // Konversi disini
          load: parseDouble(item.loadController.text),
          oleinIv: parseDouble(item.oleinIvController.text),
          oleinCp: parseDouble(item.oleinCpController.text),
          oleinFfa: parseDouble(item.oleinFfaController.text),
          oleinColorRed: parseDouble(item.oleinColorRedController.text),
          stearinIv: parseDouble(item.stearinIvController.text),
          stearinFfa: parseDouble(item.stearinFfaController.text),
          stearinColorRed: parseDouble(item.stearinColorRedController.text),
          stearinPv: parseDouble(item.stearinPvController.text),
          idHdr: '',
        ),
      );
    }

    // 3. Mapping Header
    DryFractionationHeaderEntity headerData = DryFractionationHeaderEntity(
      id: widget.data.id.isNotEmpty ? widget.data.id : '',
      date: changeStringDateFormat(
        dateController.text,
        'dd-MM-yyyy',
        'yyyy-MM-dd',
        returnDateTime: true,
      ),
      postingDate: DateTime.now(), // Atau sama dengan date
      company: "PS", // Hardcode atau ambil dari User Session
      plant: "PS21", // Hardcode atau ambil dari User Session
      crystallizer: selectedCrystallizer,
      feedOilIv: parseDouble(feedOilIvController.text),
      initialOilLevel: parseDouble(initialOilLevelController.text),
      fillingStartTime: selectedFillingStartTime,
      fillingEndTime: selectedFillingEndTime,
      coolingStartTemp: parseDouble(coolingStartTempController.text),
      coolingStartTime: selectedCoolingStartTime,
      agitatorSpeed: parseInt(agitatorSpeedController.text),
      waterPumpPres: parseDouble(waterPumpPresController.text),
      remarks: "", // Tambahkan controller remarks jika perlu
      details: detailEntities,
      flag: '',
      entryBy: '',
      entryDate: null,
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
      isCompleted: false,
    );

    // 4. Panggil Provider
    final provider = Provider.of<DryFractionationProvider>(
      context,
      listen: false,
    );

    // Asumsi provider Anda memiliki parameter menuId
    final isSuccess = await provider.updateReport(
      headerInput: headerData,
      menuId: formData?.id.toString() ?? '0',
    );

    if (mounted) {
      if (isSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Data berhasil disimpan!")),
        );
        Navigator.pop(context); // Kembali ke halaman sebelumnya
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "Gagal menyimpan data ${provider.errorMessage}" ??
                  "Gagal menyimpan data",
            ),
          ),
        );
      }
    }
  }
}
