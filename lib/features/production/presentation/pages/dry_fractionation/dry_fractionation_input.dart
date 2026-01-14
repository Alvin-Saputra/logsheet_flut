import 'package:flutter/material.dart';
import 'package:logsheet_app/core/widgets/custom_app_bar.dart';
import 'package:logsheet_app/core/widgets/custom_date_field.dart';
import 'package:logsheet_app/core/widgets/custom_hour_field.dart';
import 'package:logsheet_app/core/widgets/custom_hour_minute_field.dart';
import 'package:logsheet_app/core/widgets/custom_hour_picker.dart';
import 'package:logsheet_app/core/widgets/custom_text_field.dart';
import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/value_provider.dart';
import 'package:provider/provider.dart';

class DryFractionationInputPage extends StatefulWidget {
  const DryFractionationInputPage({super.key, required this.dataForm});
  final DataFormNoEntity? dataForm;

  @override
  State<DryFractionationInputPage> createState() =>
      _DryFractionationInputPageState();
}

class _DryFractionationInputPageState extends State<DryFractionationInputPage> {
  final TextEditingController dateController = TextEditingController();
  final TextEditingController feedOilIvController = TextEditingController();

  final TextEditingController initialOilLevelController =
      TextEditingController();
  final TextEditingController coolingStartTempController =
      TextEditingController();
  final TextEditingController coolingStartTimeController =
      TextEditingController();
  final TextEditingController agitatorSpeedController = TextEditingController();
  final TextEditingController waterPumpPresController = TextEditingController();

  String? selectedCrystallizer;
  int? selectedFillingStartTime;
  int? selectedFillingEndTime;
  int?
  selectedCoolingStartTime; // Variabel ini ada tapi belum dipakai sebelumnya

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: CustomAppBar(
        title: 'Daily Production - Fractionation (${widget.dataForm?.code})',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomDateField(
              controller: dateController,
              label: 'Date',
              icon: Icons.event,
            ),
            const SizedBox(height: 8.0),
            Consumer<ValueProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
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
                      hintText: 'Loading CR...',
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
                  decoration: const InputDecoration(
                    hintText: 'Crystallizer/Batch',
                    labelText: 'Crystallizer/Batch',
                    labelStyle: TextStyle(
                      color: Color(0xFF655F5B),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 8.0),
            CustomTextField(
              controller: feedOilIvController,
              label: 'Feed Oil IV',
              icon: Icons.place_rounded,
              isNumeric: true,
            ),
            // const SizedBox(height: 8.0), // Menambah jarak agar rapi
            // --- INPUT 1: FILLING START TIME ---
            InkWell(
              onTap:
                  () =>
                      _showHourPicker(context, selectedFillingStartTime, (val) {
                        setState(() {
                          selectedFillingStartTime = val;
                        });
                      }),
              child: InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF0ECE9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(
                    Icons.access_time,
                    color: Color(0xFF655F5B),
                  ),
                  labelText: "Start Time", // Menambahkan label agar jelas
                ),
                child: Text(
                  selectedFillingStartTime != null
                      ? '${selectedFillingStartTime.toString().padLeft(2, '0')}:00'
                      : 'Pilih Start Time',
                  style: TextStyle(
                    color:
                        selectedFillingStartTime != null
                            ? const Color(0xFF655F5B)
                            : Colors.grey.shade600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8.0), // Jarak antar input
            // --- INPUT 2: FILLING END TIME (Perbaikan Logika) ---
            InkWell(
              onTap:
                  () => _showHourPicker(
                    context,
                    selectedFillingEndTime, // Menggunakan variabel EndTime
                    (val) {
                      setState(() {
                        selectedFillingEndTime = val; // Set ke variabel EndTime
                      });
                    },
                  ),
              child: InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF0ECE9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(
                    Icons.access_time,
                    color: Color(0xFF655F5B),
                  ),
                  labelText: "End Time", // Menambahkan label agar jelas
                ),
                child: Text(
                  selectedFillingEndTime != null
                      ? '${selectedFillingEndTime.toString().padLeft(2, '0')}:00'
                      : 'Pilih End Time',
                  style: TextStyle(
                    color:
                        selectedFillingEndTime != null
                            ? const Color(0xFF655F5B)
                            : Colors.grey.shade600,
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.0),
            CustomTextField(
              controller: initialOilLevelController,
              label: "Initial Oil Level Controller",
              icon: Icons.place_rounded,
              isNumeric: true,
            ),

            CustomTextField(
              controller: coolingStartTempController,
              label: "Cooling Start Temp",
              icon: Icons.place_rounded,
              isNumeric: true,
            ),

            InkWell(
              onTap:
                  () =>
                      _showHourPicker(context, selectedCoolingStartTime, (val) {
                        setState(() {
                          selectedCoolingStartTime = val;
                        });
                      }),
              child: InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF0ECE9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  prefixIcon: const Icon(
                    Icons.access_time,
                    color: Color(0xFF655F5B),
                  ),
                  labelText: "Start Time", // Menambahkan label agar jelas
                ),
                child: Text(
                  selectedCoolingStartTime != null
                      ? '${selectedCoolingStartTime.toString().padLeft(2, '0')}:00'
                      : 'Pilih Start Time',
                  style: TextStyle(
                    color:
                        selectedCoolingStartTime != null
                            ? const Color(0xFF655F5B)
                            : Colors.grey.shade600,
                  ),
                ),
              ),
            ),

            CustomTextField(
              controller: agitatorSpeedController,
              label: "Agitatator Speed (HZ)",
              icon: Icons.place_rounded,
              isNumeric: true,
            ),

             CustomTextField(
              controller: waterPumpPresController,
              label: "Water Pump Press",
              icon: Icons.place_rounded,
              isNumeric: true,
            ),
          ],
        ),
      ),
    );
  }

  // --- PERBAIKAN FUNGSI _showHourPicker ---
  void _showHourPicker(
    BuildContext context,
    int? selectedHour,
    ValueChanged<int> onSelected,
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
            child: CustomHourPicker(
              selectedHour: selectedHour,
              onHourSelected: (hour) {
                // 1. Panggil callback untuk update state di parent
                onSelected(hour);

                // 2. Tutup dialog setelah memilih
                // Navigator.of(dialogContext).pop();
              },
            ),
          ),
        );
      },
    );
  }
}
