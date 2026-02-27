import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:logsheet_app/features/master_data/data/model/master/tank_entity.dart';
import 'package:logsheet_app/core/widgets/custom_hour_field.dart';
import 'package:logsheet_app/core/widgets/custom_hour_minute_field.dart';
import 'package:logsheet_app/core/widgets/custom_section_title.dart';
import 'package:logsheet_app/core/widgets/custom_text_field.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/crystallizer_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/product_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/value_provider.dart';
import 'package:provider/provider.dart';

class FraSectionRbdpoRolRps extends StatefulWidget {
  final TimeOfDay? selectedTimeAwal;
  final TimeOfDay? selectedTimeAkhir;
  final VoidCallback onTimeTapAwal;
  final VoidCallback onTimeTapAkhir;
  final TextEditingController flowmeterAwalController;
  final TextEditingController flowmeterAkhirController;
  final TextEditingController flowmeterTotalController;
  final List<TankEntity> dummyTanks;
  String? selectedOil;
  String? selectedTank;
  String? selectedCrystallizer;
  final Function(String?) onTankChanged;
  final Function(String?) onCrystallizerChanged;
  final Function(String?) onOilRmChanged;

  final Function(bool?) onUseTankFromLastShiftChangedRm;
  bool showCheckboxUseTankFromLastShiftChangedRm;

  final Function(bool?) onUseTankFromLastRowRm;
  bool showCheckboxUseTankFromLastRowRm;

  FraSectionRbdpoRolRps({
    super.key,
    required this.dummyTanks,
    required this.selectedTank,
    required this.onTankChanged,
    required this.selectedTimeAwal,
    required this.selectedTimeAkhir,
    // required this.selectedHourAwal,
    // required this.selectedHourAkhir,
    required this.onTimeTapAwal,
    required this.onTimeTapAkhir,
    required this.flowmeterAwalController,
    required this.flowmeterAkhirController,
    required this.flowmeterTotalController,
    required this.onCrystallizerChanged,
    required this.onOilRmChanged,
    required this.selectedOil,
    required this.selectedCrystallizer,
    required this.onUseTankFromLastShiftChangedRm,
    this.showCheckboxUseTankFromLastShiftChangedRm = false,
    required this.onUseTankFromLastRowRm,
    this.showCheckboxUseTankFromLastRowRm = false,
  });

  @override
  State<FraSectionRbdpoRolRps> createState() => _FraSectionRbdpoRolRpsState();
}

class _FraSectionRbdpoRolRpsState extends State<FraSectionRbdpoRolRps> {
  bool isCheckedLastShiftTank = false;
  bool isCheckedLastRow = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CustomSectionTitle(title: 'RBDPO/ROL/RPS'),
            (widget.showCheckboxUseTankFromLastShiftChangedRm)
                ? Row(
                  children: [
                    Checkbox(
                      value: isCheckedLastShiftTank,
                      onChanged: (bool? value) {
                        setState(() {
                          isCheckedLastShiftTank =
                              value ?? false; // ← ini yang WAJIB
                        });

                        widget.onUseTankFromLastShiftChangedRm(value);
                      },
                    ),
                    Text('Use Tank From Last Shift'),
                  ],
                )
                : Container(),
            (widget.showCheckboxUseTankFromLastRowRm)
                ? Row(
                  children: [
                    Checkbox(
                      value: isCheckedLastRow,
                      onChanged: (bool? value) {
                        setState(() {
                          isCheckedLastRow = value ?? false;
                        });

                        widget.onUseTankFromLastRowRm(value);
                      },
                    ),
                    const Text("Use Tank From Last Row"),
                  ],
                )
                : Container(),
            const SizedBox(height: 12),
            Consumer<ProductProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
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

                if (provider.productFractionationList.isEmpty) {
                  log(
                    "FRACTIONATION LIST LENGTH: ${provider.productFractionationList.length}",
                  );
                  return TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF0ECE9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Oil Types tidak ditemukan.',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(Icons.warning_amber_rounded),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () async {
                          await provider.fetchProducts();
                        },
                      ),
                    ),
                  );
                }
                log(
                  "FRACTIONATION LIST LENGTH: ${provider.productFractionationList.length}",
                );
                return DropdownButtonFormField<String>(
                  value: widget.selectedOil,
                  items:
                      provider.productFractionationList.map((oil) {
                        return DropdownMenuItem<String>(
                          value: oil.id,
                          child: Text(
                            oil.rawMaterial!,
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      widget.onOilRmChanged(value);
                    }
                    validator:
                    (value) {
                      if (value == null) return 'Oil Type wajib dipilih';
                      return null;
                    };
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFFF0ECE9),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Pilih Oil Type',
                    prefixIcon: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Icon(Icons.oil_barrel_rounded),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            const Text("From Tank", style: _sectionTextStyle),
            const SizedBox(height: 10),
            Consumer<ValueProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
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
                      hintText: 'Loading Tanks...',
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
                      hintText: 'Tank List tidak ditemukan.',
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
                final tankItems = _buildUniqueTankItems(
                  provider.tankSourceList,
                );
                final selectedTankValue = _resolveSelectedDropdownValue(
                  widget.selectedTank,
                  tankItems,
                );
                return DropdownButtonFormField<String>(
                  value: selectedTankValue,
                  items: tankItems,
                  onChanged: widget.onTankChanged,
                  validator: (value) {
                    if (value == null) return 'Tank wajib dipilih';
                    return null;
                  },
                  decoration: InputDecoration(hintText: 'Pilih Tank'),
                );
              },
            ),

            const SizedBox(height: 10),
            const Text("CR", style: _sectionTextStyle),
            const SizedBox(height: 10),
            Consumer<ValueProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
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
                      hintText: 'Loading Tanks...',
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
                      hintText: 'Tank List tidak ditemukan.',
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
                final crystallizerItems = _buildUniqueTankItems(
                  provider.tankSourceList.where(
                    (element) => element.category == "CR",
                  ),
                );
                final selectedCrystallizerValue = _resolveSelectedDropdownValue(
                  widget.selectedCrystallizer,
                  crystallizerItems,
                );
                return DropdownButtonFormField<String>(
                  value: selectedCrystallizerValue,
                  items: crystallizerItems,
                  onChanged: widget.onCrystallizerChanged,
                  validator: (value) {
                    if (value == null) return 'Crystallizer wajib dipilih';
                    return null;
                  },
                  decoration: InputDecoration(hintText: 'Pilih CR'),
                );
              },
            ),
            const SizedBox(height: 12),
            const Text("Awal", style: _sectionTextStyle),
            const SizedBox(height: 10),
            CustomHourMinuteField(
              selectedTime: widget.selectedTimeAwal,
              onTap: widget.onTimeTapAwal,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: widget.flowmeterAwalController,
              label: 'Flowmeter',
              icon: Icons.speed,
              isNumeric: true,
              isRequired: true,
            ),
            const SizedBox(height: 12),
            const Text("Akhir", style: _sectionTextStyle),
            const SizedBox(height: 10),
            CustomHourMinuteField(
              selectedTime: widget.selectedTimeAkhir,
              onTap: widget.onTimeTapAkhir,
            ),
            const SizedBox(height: 12),
            CustomTextField(
              controller: widget.flowmeterAkhirController,
              label: 'Flowmeter',
              icon: Icons.speed,
              isNumeric: true,
              isRequired: true,
            ),
            const SizedBox(height: 12),
            const Text("Total", style: _sectionTextStyle),
            const SizedBox(height: 10),
            CustomTextField(
              controller: widget.flowmeterTotalController,
              label: 'Total',
              icon: Icons.functions,
              isNumeric: true,
              readOnly: true,
            ),
          ],
        ),
      ),
    );
  }
}

List<DropdownMenuItem<String>> _buildUniqueTankItems(
  Iterable<TankEntity> tanks,
) {
  final seenCodes = <String>{};
  final items = <DropdownMenuItem<String>>[];
  for (final tank in tanks) {
    final code = tank.code.trim();
    if (code.isEmpty || !seenCodes.add(code)) continue;
    items.add(
      DropdownMenuItem<String>(
        value: code,
        child: Text("$code | ${tank.name}"),
      ),
    );
  }
  return items;
}

String? _resolveSelectedDropdownValue(
  String? selectedValue,
  List<DropdownMenuItem<String>> items,
) {
  final normalized = selectedValue?.trim();
  if (normalized == null || normalized.isEmpty) return null;
  final matches = items.where((item) => item.value == normalized).length;
  return matches == 1 ? normalized : null;
}

const _sectionTextStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.bold,
  color: Color(0xFF655F5B),
);
