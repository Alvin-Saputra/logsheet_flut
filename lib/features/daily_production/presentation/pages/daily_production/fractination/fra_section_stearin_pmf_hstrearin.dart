import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/features/master_data/data/model/master/tank_entity.dart';
import 'package:logsheet_app/core/widgets/custom_hour_minute_field.dart';
import 'package:logsheet_app/core/widgets/custom_section_title.dart';
import 'package:logsheet_app/core/widgets/custom_text_field.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/product_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/value_provider.dart';
import 'package:provider/provider.dart';

class FraSectionStearinPmfHstrearin extends StatelessWidget {
  // final int? selectedHourAwal;
  // final int? selectedHourAkhir;
  // final VoidCallback onHourTapAwal;
  // final VoidCallback onHourTapAkhir;
  final TimeOfDay? selectedTimeAwal;
  final TimeOfDay? selectedTimeAkhir;
  final VoidCallback onTimeTapAwal;
  final VoidCallback onTimeTapAkhir;
  final TextEditingController flowmeterAwalController;
  final TextEditingController flowmeterAkhirController;
  final TextEditingController flowmeterTotalController;
  final List<TankEntity> tanksList;
  // final List<MasterValueEntity> oilList;
  String? selectedTank;
  String? selectedOil;
  final Function(String?) onTankChanged;
  final Function(String?) onOilBpChanged;
  FraSectionStearinPmfHstrearin({
    super.key,
    required this.tanksList,
    required this.selectedTank,
    required this.onTankChanged,
    required this.flowmeterAwalController,
    required this.flowmeterAkhirController,
    required this.flowmeterTotalController,
    // required this.oilList,
    required this.selectedOil,
    required this.onOilBpChanged,
    this.selectedTimeAwal,
    this.selectedTimeAkhir,
    required this.onTimeTapAwal,
    required this.onTimeTapAkhir,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Consumer<ProductProvider>(
          builder: (context, provider, child) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const CustomSectionTitle(title: 'STEARIN/PMF/HARD STEARIN'),
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
                      isExpanded: true,
                      value: selectedOil,
                      items:
                          provider.productFractionationList.map((oil) {
                            return DropdownMenuItem<String>(
                              value: oil.id,
                              child: Text(
                                oil.finishGood!,
                                style: TextStyle(fontSize: 14),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            );
                          }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          onOilBpChanged(value);
                        }
                      },
                      validator: (value) {
                        if (value == null) return 'Oil Type wajib dipilih';
                        return null;
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
                const SizedBox(height: 12),

                const Text("To Tank", style: _sectionTextStyle),
                const SizedBox(height: 10),
                Consumer<ValueProvider>(
                  builder: (context, provider, child) {
                    if (provider.isLoading) {
                      return DropdownButtonFormField<String>(
                        isExpanded: true,
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
                      selectedTank,
                      tankItems,
                    );
                    return DropdownButtonFormField<String>(
                      value: selectedTankValue,
                      items: tankItems,
                      onChanged: onTankChanged,
                      validator: (value) {
                        if (value == null) return 'Tank wajib dipilih';
                        return null;
                      },
                      decoration: InputDecoration(hintText: 'Pilih Tank'),
                    );
                  },
                ),
                const SizedBox(height: 12),
                const Text("Start", style: _sectionTextStyle),
                const SizedBox(height: 10),
                CustomHourMinuteField(
                  selectedTime: selectedTimeAwal,
                  onTap: onTimeTapAwal,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: flowmeterAwalController,
                  label: 'Flowmeter',
                  icon: Icons.speed,
                  isNumeric: true,
                  
                ),
                const SizedBox(height: 12),
                const Text("Akhir", style: _sectionTextStyle),
                const SizedBox(height: 10),
                CustomHourMinuteField(
                  selectedTime: selectedTimeAkhir,
                  onTap: onTimeTapAkhir,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  controller: flowmeterAkhirController,
                  label: 'Flowmeter',
                  icon: Icons.speed,
                  isNumeric: true,
                  
                ),
                const SizedBox(height: 12),
                const Text("Total", style: _sectionTextStyle),
                const SizedBox(height: 10),
                CustomTextField(
                  controller: flowmeterTotalController,
                  label: 'Total',
                  icon: Icons.functions,
                  isNumeric: true,
                  readOnly: true,
                ),
              ],
            );
          },
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
