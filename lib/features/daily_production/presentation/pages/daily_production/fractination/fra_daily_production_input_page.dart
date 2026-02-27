import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/features/daily_production/data/model/daily_production/daily_production_fractionation_entity.dart';
import 'package:logsheet_app/features/daily_production/presentation/pages/daily_production/fractination/fra_input_item.dart';
import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/master_data/data/model/master/tank_entity.dart';
import 'package:logsheet_app/features/master_data/data/model/master/value_entity.dart';
import 'package:logsheet_app/features/daily_production/presentation/pages/daily_production/fractination/fra_section_olein_solein_sstearin.dart';
import 'package:logsheet_app/features/daily_production/presentation/pages/daily_production/fractination/fra_section_rbdpo_rol_rps.dart';
import 'package:logsheet_app/features/daily_production/presentation/pages/daily_production/fractination/fra_section_stearin_pmf_hstrearin.dart';

import 'package:logsheet_app/core/widgets/custom_app_bar.dart';
import 'package:logsheet_app/core/widgets/custom_hour_minute_picker.dart';
import 'package:logsheet_app/core/widgets/custom_remark_field.dart';
import 'package:logsheet_app/core/widgets/custom_save_button.dart';
import 'package:logsheet_app/core/widgets/custom_section_title.dart';
import 'package:logsheet_app/core/widgets/custom_text_field.dart';
import 'package:logsheet_app/core/widgets/section_card.dart';
import 'package:logsheet_app/features/daily_production/presentation/provider/daily_production/daily_production_fractionation_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/business_unit_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/crystallizer_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/plant_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/product_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/value_provider.dart';
import 'package:provider/provider.dart';

class DailyProductionFractinationInputPage extends StatefulWidget {
  final String userName;
  final DataFormNoEntity dataForm;
  final bool isFromAddNewShift;
  final DailyProductionFractionationEntity? entity;
  const DailyProductionFractinationInputPage({
    super.key,
    required this.userName,
    required this.dataForm,
    required this.isFromAddNewShift,
    this.entity,
  });

  @override
  State<DailyProductionFractinationInputPage> createState() =>
      _DailyProductionFractionPageState();
}

class _DailyProductionFractionPageState
    extends State<DailyProductionFractinationInputPage> {
  bool isLoading = true;
  bool isUtillityUsageActive = false;
  String? steamItem = "Steam (Ton/Ton CPO)";
  String? selected1Tank;
  String? selected2Tank;
  String? selected3Tank;
  String? selectedOilRm;
  String? selectedOilFg;
  String? selectedOilBp;
  String? selectedOilTypeFgToTank;
  TimeOfDay? selectedTime1Awal;
  TimeOfDay? selectedTime1Akhir;
  TimeOfDay? selectedTime2Awal;
  TimeOfDay? selectedTime2Akhir;
  TimeOfDay? selectedTime3Awal;
  TimeOfDay? selectedTime3Akhir;

  // String? selectedMachine;

  DateTime selectedTransactionDate = DateTime.now();
  String? selectedWorkCenter;
  String? selectedShift;
  String? budgetValue;

  // Dummy data
  Map<String, double> utilityBudget = {'FRAC-02': 0.06, 'FRAC-01': 0.05};

  List<TankEntity>? tankLists;
  List<MasterValueEntity>? oilLists;

  final List<String> dummyShiftOptions = ['1', '2', '3', '4', '5'];
  final Set<String> _usedShiftOptions = <String>{};

  String? selectedShiftBleaching;

  final TextEditingController remarksController = TextEditingController();
  final uuFlowmeterBefore = TextEditingController();
  final uuFlowmeterAfter = TextEditingController();
  final uuFlowmeterTotal = TextEditingController();
  final uuYieldController = TextEditingController();
  final uuListrikController = TextEditingController();
  final uuAirController = TextEditingController();

  List<FractionationInputItem> inputItems = [];

  @override
  void dispose() {
    uuFlowmeterBefore.dispose();
    uuFlowmeterAfter.dispose();
    uuFlowmeterTotal.dispose();
    uuYieldController.dispose();
    uuListrikController.dispose();
    uuAirController.dispose();

    super.dispose();
  }

  void _addNewRow() {
    setState(() {
      bool isDefaultRow = inputItems.isEmpty;
      inputItems.add(
        FractionationInputItem(
          showRM: isDefaultRow, // True jika row 0, False jika row > 0
          showFG: isDefaultRow,
          showBP: isDefaultRow,
        ),
      );
    });
  }

  // Fungsi Hapus Row
  void _removeRow(int index) {
    setState(() {
      inputItems[index].dispose(); // Bersihkan memory controller
      inputItems.removeAt(index);
    });
  }

  void _showHourPickerAndUpdateState(
    Function(TimeOfDay) onTimeSelected,
    TimeOfDay? selectedTime,
  ) {
    showDialog(
      context: context,
      builder:
          (context) => Dialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            insetPadding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Takes only necessary height
              children: [
                // Optional: You might want to wrap this in a specific height or width
                // container if the picker doesn't have a defined size.
                CustomHourMinutePicker(
                  selectedTime: selectedTime,
                  onTimeSelected: (time) {
                    onTimeSelected(time);
                    // If you want the dialog to close immediately after selection, uncomment the line below:
                    // Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _refreshPage() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => isLoading = false);
  }

  Future<void> _selectTransactionDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedTransactionDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != selectedTransactionDate) {
      setState(() {
        selectedTransactionDate = picked;
      });
    }
  }

  bool get _isAddShiftMode => widget.isFromAddNewShift && widget.entity != null;

  bool get _isWorkCenterLockedForAddShift =>
      _isAddShiftMode &&
      (widget.entity?.workCenter?.trim().isNotEmpty ?? false);

  List<String> get _availableShiftOptions {
    if (!_isAddShiftMode) {
      return dummyShiftOptions;
    }
    return dummyShiftOptions
        .where((shift) => !_usedShiftOptions.contains(shift))
        .toList();
  }

  void _syncAddShiftContext() {
    if (!_isAddShiftMode) {
      return;
    }

    final ticketId = widget.entity!.id;
    final provider = context.read<DailyProductionFractionationProvider>();
    final usedShiftOptions = <String>{};

    void collectShifts(List<DailyProductionFractionationEntity> source) {
      for (final item in source) {
        if (item.id != ticketId) continue;
        final shift = item.shift?.trim();
        if (shift != null && dummyShiftOptions.contains(shift)) {
          usedShiftOptions.add(shift);
        }
      }
    }

    collectShifts(provider.reportsList);
    collectShifts(provider.filteredTickets);

    final fallbackShift = widget.entity?.shift?.trim();
    if (fallbackShift != null && dummyShiftOptions.contains(fallbackShift)) {
      usedShiftOptions.add(fallbackShift);
    }

    _usedShiftOptions
      ..clear()
      ..addAll(usedShiftOptions);

    selectedWorkCenter = widget.entity?.workCenter;
    final availableShifts = _availableShiftOptions;
    selectedShift =
        availableShifts.contains(selectedShift)
            ? selectedShift
            : (availableShifts.isNotEmpty ? availableShifts.first : null);
  }

  Future<void> _fetchInitialDataIfNeeded() async {
    final valueProvider = context.read<ValueProvider>();
    final productProvider = context.read<ProductProvider>();
    final crystallizerProvider = context.read<CrystallizerProvider>();
    final futures = <Future<void>>[];

    if (valueProvider.workCenterFractLists.isEmpty) {
      futures.add(valueProvider.fetchWorkCenterFractLists());
    }
    if (valueProvider.tankSourceList.isEmpty) {
      futures.add(valueProvider.fetchTankSourceLists());
    }
    if (productProvider.productFractionationList.isEmpty) {
      futures.add(productProvider.fetchProducts());
    }
    if (crystallizerProvider.crystallizerList.isEmpty) {
      futures.add(crystallizerProvider.fetchCrystallizer());
    }

    if (futures.isNotEmpty) {
      await Future.wait(futures);
    }

    if (!mounted) return;
    setState(() {
      tankLists = valueProvider.tankSourceList;
      if (_isWorkCenterLockedForAddShift) {
        selectedWorkCenter = widget.entity?.workCenter;
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _addNewRow();
    final valueProvider = context.read<ValueProvider>();
    tankLists = valueProvider.tankSourceList;

    if (_isWorkCenterLockedForAddShift) {
      selectedWorkCenter = widget.entity?.workCenter;
    }
    _syncAddShiftContext();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _fetchInitialDataIfNeeded();
    });
  }

  Future<void> showSaveConfirmationDialog(
    BuildContext context, {
    required Future<void> Function() onConfirm,
  }) async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        bool isLoading =
            context.watch<DailyProductionFractionationProvider>().isLoading;
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Konfirmasi input"),
              content: const Text("Apakah anda yakin?"),
              actions: [
                TextButton(
                  onPressed:
                      isLoading
                          ? null
                          : () {
                            Navigator.of(context).pop();
                          },
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed:
                      isLoading
                          ? null
                          : () async {
                            await onConfirm();
                            if (context.mounted) Navigator.of(context).pop();
                          },
                  child:
                      isLoading
                          ? const SizedBox(
                            height: 24,
                            width: 24,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                          : Text("Yes"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    budgetValue =
        selectedWorkCenter != null &&
                utilityBudget.containsKey(selectedWorkCenter)
            ? selectedWorkCenter == 'FRAC-02'
                ? '${utilityBudget['FRAC-02']}'
                : '${utilityBudget['FRAC-01']}'
            : 'N/A';
    final availableShiftOptions = _availableShiftOptions;
    final selectedShiftValue =
        availableShiftOptions.contains(selectedShift) ? selectedShift : null;
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: CustomAppBar(
        title: 'Daily Production - Fractionation (${widget.dataForm.code})',
        onRefresh: _refreshPage,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // === Dropdown: Plant ===
            Consumer<ValueProvider>(
              builder: (context, provider, child) {
                if (provider.isWorkCenterFractLoading) {
                  return DropdownButtonFormField<String>(
                    value: null,
                    items: [],
                    onChanged: null,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF0ECE9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Loading Work Center...',
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
                if (provider.workCenterFractLists.isEmpty) {
                  return TextFormField(
                    readOnly: true,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFFF0ECE9),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      hintText: 'Fract. Machine tidak ditemukan.',
                      prefixIcon: const Padding(
                        padding: EdgeInsets.all(12.0),
                        child: Icon(Icons.warning_amber_rounded),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.refresh),
                        onPressed: () async {
                          await context
                              .read<ValueProvider>()
                              .fetchWorkCenterFractLists();
                        },
                      ),
                    ),
                  );
                }
                return DropdownButtonFormField<String>(
                  value: selectedWorkCenter,
                  items:
                      provider.workCenterFractLists.map((machine) {
                        return DropdownMenuItem<String>(
                          value: machine.code,
                          child: Text(
                            "${machine.code} | ${machine.name}",
                            style: TextStyle(fontSize: 14),
                          ),
                        );
                      }).toList(),
                  onChanged:
                      _isWorkCenterLockedForAddShift
                          ? null
                          : (value) {
                            setState(() {
                              selectedWorkCenter = value;
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

            GestureDetector(
              onTap: _selectTransactionDate,
              child: InputDecorator(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF0ECE9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  hintText: 'Pilih Tanggal Transaksi',
                  labelText: 'Tanggal Transaksi',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: Icon(Icons.calendar_today),
                  ),
                ),
                child: Text(
                  DateFormat('dd MMMM yyyy').format(selectedTransactionDate),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),

            const SizedBox(height: 8),

            DropdownButtonFormField<String>(
              value: selectedShiftValue,
              items:
                  availableShiftOptions.map((item) {
                    return DropdownMenuItem<String>(
                      value: item,
                      child: Text(
                        "${item}",
                        style: const TextStyle(fontSize: 14),
                      ),
                    );
                  }).toList(),
              onChanged:
                  availableShiftOptions.isEmpty
                      ? null
                      : (value) {
                        setState(() {
                          selectedShift = value;
                        });
                      },
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFFF0ECE9),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                labelText:
                    availableShiftOptions.isEmpty
                        ? 'Semua shift sudah dibuat'
                        : 'Pilih Shift',
                floatingLabelBehavior: FloatingLabelBehavior.auto,
                prefixIcon: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: SvgPicture.asset(
                    'assets/icons/oil-refinery-tanks.svg',
                    height: 24,
                    width: 24,
                  ),
                ),
              ),
            ),

            if (selectedWorkCenter == null) ...[
              const Center(
                child: Text(
                  'Silakan pilih workCenter terlebih dahulu',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ] else ...[
              const SizedBox(height: 16),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.center,
              //   children: [
              //     Text(
              //       'Production Data Details',
              //       style: TextStyle(
              //         color: Colors.black,
              //         fontSize: 20.0,
              //         fontWeight: FontWeight.w600,
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 8),

              // ...inputItems.asMap().entries.map((entry) {
              //   int index = entry.key;
              //   FractionationInputItem item = entry.value;

              //   return Card(
              //     elevation: 3,
              //     margin: const EdgeInsets.only(
              //       bottom: 24,
              //     ), // Jarak antar Grup besar
              //     shape: RoundedRectangleBorder(
              //       borderRadius: BorderRadius.circular(16),
              //     ),
              //     child: Column(
              //       crossAxisAlignment: CrossAxisAlignment.start,
              //       children: [
              //         // HEADER CARD (Judul + Tombol Hapus)
              //         Container(
              //           padding: const EdgeInsets.symmetric(
              //             horizontal: 16,
              //             vertical: 12,
              //           ),
              //           decoration: BoxDecoration(
              //             color: Colors.blueGrey[50],
              //             borderRadius: const BorderRadius.vertical(
              //               top: Radius.circular(16),
              //             ),
              //           ),
              //           child: Row(
              //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //             children: [
              //               Text(
              //                 "Set Data #${index + 1}",
              //                 style: const TextStyle(
              //                   fontWeight: FontWeight.bold,
              //                   fontSize: 16,
              //                 ),
              //               ),
              //               // Tombol Hapus (Hanya muncul jika item > 1)
              //               if (inputItems.length > 1)
              //                 InkWell(
              //                   onTap: () => _removeRow(index),
              //                   child: const Icon(
              //                     Icons.delete,
              //                     color: Colors.red,
              //                   ),
              //                 ),
              //             ],
              //           ),
              //         ),

              //         Padding(
              //           padding: const EdgeInsets.all(12.0),
              //           child: Column(
              //             children: [
              //               // 1. SECTION RAW MATERIAL
              //               const Text(
              //                 "1. Raw Material (RBDPO/ROL/RPS)",
              //                 style: TextStyle(
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.black,
              //                 ),
              //               ),
              //               const SizedBox(height: 8),
              //               FraSectionRbdpoRolRps(
              //                 dummyTanks: tankLists ?? [],
              //                 selectedTank: item.selectedTankRm,
              //                 onTankChanged:
              //                     (val) =>
              //                         setState(() => item.selectedTankRm = val),
              //                 selectedTimeAwal: item.timeAwalRm,
              //                 selectedTimeAkhir: item.timeAkhirRm,
              //                 onTimeTapAwal:
              //                     () => _showHourPickerAndUpdateState(
              //                       (t) => setState(() => item.timeAwalRm = t),
              //                       item.timeAwalRm,
              //                     ),
              //                 onTimeTapAkhir:
              //                     () => _showHourPickerAndUpdateState(
              //                       (t) => setState(() => item.timeAkhirRm = t),
              //                       item.timeAkhirRm,
              //                     ),
              //                 flowmeterAwalController: item.flowAwalRm,
              //                 flowmeterAkhirController: item.flowAkhirRm,
              //                 flowmeterTotalController: item.flowTotalRm,
              //                 onCrystallizerChanged:
              //                     (val) => setState(
              //                       () => item.selectedCrystallizerRm = val,
              //                     ),
              //                 onOilRmChanged:
              //                     (val) =>
              //                         setState(() => item.selectedOilRm = val),
              //                 selectedOil: item.selectedOilRm,
              //               ),
              //               SizedBox(height: 16.0),
              //               const Divider(height: 32, thickness: 2),
              //               SizedBox(height: 16.0),
              //               // 2. SECTION FINISH GOODS
              //               const Text(
              //                 "2. Finish Goods (Olein/Solein)",
              //                 style: TextStyle(
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.black,
              //                 ),
              //               ),
              //               const SizedBox(height: 8),
              //               FraSectionOleinSoleinSstearin(
              //                 tankLists: tankLists ?? [],
              //                 selectedTank: item.selectedTankFg,
              //                 onTankChanged:
              //                     (val) =>
              //                         setState(() => item.selectedTankFg = val),
              //                 selectedTimeAwal: item.timeAwalFg,
              //                 selectedTimeAkhir: item.timeAkhirFg,
              //                 onTimeTapAwal:
              //                     () => _showHourPickerAndUpdateState(
              //                       (t) => setState(() => item.timeAwalFg = t),
              //                       item.timeAwalFg,
              //                     ),
              //                 onTimeTapAkhir:
              //                     () => _showHourPickerAndUpdateState(
              //                       (t) => setState(() => item.timeAkhirFg = t),
              //                       item.timeAkhirFg,
              //                     ),
              //                 flowmeterAwalController: item.flowAwalFg,
              //                 flowmeterAkhirController: item.flowAkhirFg,
              //                 flowmeterTotalController: item.flowTotalFg,
              //                 // Logic selectedOilFg:
              //                 // Jika ingin otomatis mengikuti 'selectedOilFg' global:
              //                 // selectedOil: selectedOilFg,
              //                 // Jika user bisa ganti per baris, gunakan item.selectedOilFg
              //                 selectedOil: item.selectedOilFg ?? selectedOilFg,
              //                 onOilFgChanged:
              //                     (val) =>
              //                         setState(() => item.selectedOilFg = val),
              //                 onCrystallizerChanged:
              //                     (val) => setState(
              //                       () => item.selectedCrystallizerFg = val,
              //                     ),
              //               ),

              //               SizedBox(height: 16.0),
              //               const Divider(height: 32, thickness: 2),
              //               SizedBox(height: 16.0),
              //               // 3. SECTION BY PRODUCT
              //               const Text(
              //                 "3. By Product (Stearin/PMF)",
              //                 style: TextStyle(
              //                   fontWeight: FontWeight.bold,
              //                   color: Colors.black,
              //                 ),
              //               ),
              //               const SizedBox(height: 8),
              //               FraSectionStearinPmfHstrearin(
              //                 tanksList: tankLists ?? [],
              //                 selectedTank: item.selectedTankBp,
              //                 onTankChanged:
              //                     (val) =>
              //                         setState(() => item.selectedTankBp = val),
              //                 selectedTimeAwal: item.timeAwalBp,
              //                 selectedTimeAkhir: item.timeAkhirBp,
              //                 onTimeTapAwal:
              //                     () => _showHourPickerAndUpdateState(
              //                       (t) => setState(() => item.timeAwalBp = t),
              //                       item.timeAwalBp,
              //                     ),
              //                 onTimeTapAkhir:
              //                     () => _showHourPickerAndUpdateState(
              //                       (t) => setState(() => item.timeAkhirBp = t),
              //                       item.timeAkhirBp,
              //                     ),
              //                 flowmeterAwalController: item.flowAwalBp,
              //                 flowmeterAkhirController: item.flowAkhirBp,
              //                 flowmeterTotalController: item.flowTotalBp,
              //                 selectedOil: item.selectedOilBp ?? selectedOilBp,
              //                 onOilBpChanged:
              //                     (val) =>
              //                         setState(() => item.selectedOilBp = val),
              //               ),
              //             ],
              //           ),
              //         ),
              //       ],
              //     ),
              //   );
              // }).toList(),

              // Container(
              //   width: double.infinity,
              //   margin: const EdgeInsets.only(bottom: 24),
              //   child: OutlinedButton.icon(
              //     onPressed: _addNewRow,
              //     style: OutlinedButton.styleFrom(
              //       padding: const EdgeInsets.all(16),
              //       side: const BorderSide(color: Colors.redAccent, width: 2),
              //       shape: RoundedRectangleBorder(
              //         borderRadius: BorderRadius.circular(12),
              //       ),
              //     ),
              //     icon: const Icon(Icons.add_circle_outline, size: 28),
              //     label: const Text(
              //       "Tambah Set Data (RM + FG + BP)",
              //       style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              //     ),
              //   ),
              // ),
              for (int i = 0; i < inputItems.length; i++) ...{
                // === Section: CPO RPA RPS (Raw Material) ===
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: ExpansionTile(
                    trailing: IconButton(
                      onPressed: () {
                        setState(() {
                          _removeRow(i);
                        });
                      },
                      icon: Icon(Icons.delete),
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.grey, width: 0.5),
                    ),
                    // 2. Add Collapsed Shape (Border when closed)
                    collapsedShape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.grey, width: 0.5),
                    ),
                    title: Text(
                      "Row ${i + 1}",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    initiallyExpanded: true,
                    collapsedBackgroundColor: Color(0xFFF0ECE9),
                    backgroundColor:
                        Colors.white, // backgroundColor: Colors.blue,
                    children: [
                      if (i > 0)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Pilih section yang ingin diinput:",
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Wrap(
                                spacing: 8.0,
                                children: [
                                  // === CHIP RAW MATERIAL ===
                                  FilterChip(
                                    label: const Text("Raw Material"),
                                    selected: inputItems[i].showRM!,
                                    onSelected: (val) {
                                      setState(() {
                                        inputItems[i].showRM = val;

                                        // JIKA DI-UNCHECK (val == false), BERSIHKAN DATA
                                        if (!val) {
                                          // 1. Reset variable dropdown/picker
                                          inputItems[i].timeAwalRm = null;
                                          inputItems[i].timeAkhirRm = null;
                                          inputItems[i].selectedTankRm = null;
                                          inputItems[i].selectedOilRm = null;
                                          // inputItems[i].isUseLastTankRm =
                                          //     false; // Reset checkbox tank

                                          // 2. Bersihkan Text Controllers
                                          inputItems[i].flowAwalRm.clear();
                                          inputItems[i].flowAkhirRm.clear();
                                          inputItems[i].flowTotalRm.clear();
                                          // inputItems[i].oipRm.clear();
                                        }
                                      });
                                    },
                                    checkmarkColor: Colors.black,
                                    selectedColor: Colors.red.withOpacity(0.2),
                                  ),

                                  // === CHIP FINISH GOODS ===
                                  FilterChip(
                                    label: const Text("Finish Goods"),
                                    selected: inputItems[i].showFG!,
                                    onSelected: (val) {
                                      setState(() {
                                        inputItems[i].showFG = val;

                                        // JIKA DI-UNCHECK, BERSIHKAN DATA FG
                                        if (!val) {
                                          // 1. Reset variable dropdown/picker
                                          inputItems[i].timeAwalFg = null;
                                          inputItems[i].timeAkhirFg = null;
                                          inputItems[i].selectedTankFg = null;
                                          inputItems[i].selectedOilFg = null;

                                          // 2. Bersihkan Text Controllers
                                          inputItems[i].flowAwalFg.clear();
                                          inputItems[i].flowAkhirFg.clear();
                                          inputItems[i].flowTotalFg.clear();
                                        }
                                      });
                                    },
                                    checkmarkColor: Colors.black,
                                    selectedColor: Colors.red.withOpacity(0.2),
                                  ),

                                  // === CHIP BY PRODUCT ===
                                  FilterChip(
                                    label: const Text("By Product"),
                                    selected: inputItems[i].showBP!,
                                    onSelected: (val) {
                                      setState(() {
                                        inputItems[i].showBP = val;

                                        // JIKA DI-UNCHECK, BERSIHKAN DATA BP
                                        if (!val) {
                                          // 1. Reset variable dropdown/picker
                                          inputItems[i].timeAwalBp = null;
                                          inputItems[i].timeAkhirBp = null;
                                          inputItems[i].selectedTankBp = null;
                                          inputItems[i].selectedOilBp = null;

                                          // 2. Bersihkan Text Controllers
                                          inputItems[i].flowAwalBp.clear();
                                          inputItems[i].flowAkhirBp.clear();
                                          inputItems[i].flowTotalBp.clear();
                                        }
                                      });
                                    },
                                    checkmarkColor: Colors.black,
                                    selectedColor: Colors.red.withOpacity(0.2),
                                  ),
                                ],
                              ),
                              const Divider(),
                            ],
                          ),
                        ),

                      if (inputItems[i].showRM == true)
                        FraSectionRbdpoRolRps(
                          dummyTanks: tankLists ?? [],
                          selectedTank: inputItems[i].selectedTankRm,
                          onTankChanged:
                              (val) => setState(
                                () => inputItems[i].selectedTankRm = val,
                              ),
                          selectedTimeAwal: inputItems[i].timeAwalRm,
                          selectedTimeAkhir: inputItems[i].timeAkhirRm,
                          onTimeTapAwal:
                              () => _showHourPickerAndUpdateState(
                                (t) => setState(
                                  () => inputItems[i].timeAwalRm = t,
                                ),
                                inputItems[i].timeAwalRm,
                              ),
                          onTimeTapAkhir:
                              () => _showHourPickerAndUpdateState(
                                (t) => setState(
                                  () => inputItems[i].timeAkhirRm = t,
                                ),
                                inputItems[i].timeAkhirRm,
                              ),
                          flowmeterAwalController: inputItems[i].flowAwalRm,
                          flowmeterAkhirController: inputItems[i].flowAkhirRm,
                          flowmeterTotalController: inputItems[i].flowTotalRm,

                          selectedCrystallizer: inputItems[i].selectedCrystallizerRm,
                          onCrystallizerChanged:
                              (val) => setState(
                                () =>
                                    inputItems[i].selectedCrystallizerRm = val,
                              ),
                          onOilRmChanged:
                              (val) => setState(
                                () => inputItems[i].selectedOilRm = val,
                              ),
                          selectedOil: inputItems[i].selectedOilRm,
                          showCheckboxUseTankFromLastShiftChangedRm:
                              (widget.isFromAddNewShift &&
                                  inputItems[i] == inputItems.first),
                          onUseTankFromLastShiftChangedRm: (bool? value) {
                            setState(() {
                              // Update status checkbox
                              // inputItems[i].isUseLastTankRm = value;

                              if (value == true && widget.entity != null) {
                                inputItems[i].selectedTankRm =
                                    widget.entity?.oilTypeRmFromTank;
                              } else {
                                // RESET JIKA UNCHECK (Kembali Kosong)
                                setState(() {
                                  inputItems[i].selectedTankRm = null;
                                });
                              }
                            });
                          },

                          showCheckboxUseTankFromLastRowRm:
                              (inputItems[i] != inputItems.first),

                          onUseTankFromLastRowRm: (bool? value) {
                            if (value == true &&
                                inputItems[i - 1].selectedTankRm != null) {
                              setState(() {
                                inputItems[i].selectedTankRm =
                                    inputItems[i - 1].selectedTankRm;
                              });
                            } else {
                              setState(() {
                                inputItems[i].selectedTankRm = null;
                              });
                            }
                          },
                        ),
                      SizedBox(height: 16.0),

                      if (inputItems[i].showFG == true)
                        FraSectionOleinSoleinSstearin(
                          tankLists: tankLists ?? [],
                          selectedTank: inputItems[i].selectedTankFg,
                          onTankChanged:
                              (val) => setState(
                                () => inputItems[i].selectedTankFg = val,
                              ),
                          selectedTimeAwal: inputItems[i].timeAwalFg,
                          selectedTimeAkhir: inputItems[i].timeAkhirFg,
                          onTimeTapAwal:
                              () => _showHourPickerAndUpdateState(
                                (t) => setState(
                                  () => inputItems[i].timeAwalFg = t,
                                ),
                                inputItems[i].timeAwalFg,
                              ),
                          onTimeTapAkhir:
                              () => _showHourPickerAndUpdateState(
                                (t) => setState(
                                  () => inputItems[i].timeAkhirFg = t,
                                ),
                                inputItems[i].timeAkhirFg,
                              ),
                          flowmeterAwalController: inputItems[i].flowAwalFg,
                          flowmeterAkhirController: inputItems[i].flowAkhirFg,
                          flowmeterTotalController: inputItems[i].flowTotalFg,
                          // Logic selectedOilFg:
                          // Jika ingin otomatis mengikuti 'selectedOilFg' global:
                          // selectedOil: selectedOilFg,
                          // Jika user bisa ganti per baris, gunakan inputItems[i].selectedOilFg
                          selectedOil:
                              inputItems[i].selectedOilFg ?? selectedOilFg,
                          onOilFgChanged:
                              (val) => setState(
                                () => inputItems[i].selectedOilFg = val,
                              ),
                          selectedCrystallizer: inputItems[i].selectedCrystallizerFg,    
                          onCrystallizerChanged:
                              (val) => setState(
                                () =>
                                    inputItems[i].selectedCrystallizerFg = val,
                              ), 
                        ),

                      SizedBox(height: 16.0),

                      if (inputItems[i].showBP == true)
                        FraSectionStearinPmfHstrearin(
                          tanksList: tankLists ?? [],
                          selectedTank: inputItems[i].selectedTankBp,
                          onTankChanged:
                              (val) => setState(
                                () => inputItems[i].selectedTankBp = val,
                              ),
                          selectedTimeAwal: inputItems[i].timeAwalBp,
                          selectedTimeAkhir: inputItems[i].timeAkhirBp,
                          onTimeTapAwal:
                              () => _showHourPickerAndUpdateState(
                                (t) => setState(
                                  () => inputItems[i].timeAwalBp = t,
                                ),
                                inputItems[i].timeAwalBp,
                              ),
                          onTimeTapAkhir:
                              () => _showHourPickerAndUpdateState(
                                (t) => setState(
                                  () => inputItems[i].timeAkhirBp = t,
                                ),
                                inputItems[i].timeAkhirBp,
                              ),
                          flowmeterAwalController: inputItems[i].flowAwalBp,
                          flowmeterAkhirController: inputItems[i].flowAkhirBp,
                          flowmeterTotalController: inputItems[i].flowTotalBp,
                          selectedOil:
                              inputItems[i].selectedOilBp ?? selectedOilBp,
                          onOilBpChanged:
                              (val) => setState(
                                () => inputItems[i].selectedOilBp = val,
                              ),
                        ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Optional: Add a button to remove this specific row if needed
                // IconButton(icon: Icon(Icons.delete), onPressed: () => _removeRow(i)),
              },

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
                    "Tambah Set Data (RM + FG + BP)",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              CheckboxListTile(
                value: isUtillityUsageActive,
                title: Text("Input Utillity Usage"),
                onChanged: (value) {
                  setState(() {
                    isUtillityUsageActive = !isUtillityUsageActive;
                  });
                },
                controlAffinity: ListTileControlAffinity.leading,
              ),

              if (isUtillityUsageActive) ...[
                Card(
                  color: Colors.white,
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(20),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const CustomSectionTitle(title: 'Utillty Usage'),
                        Row(
                          children: [
                            const Text(
                              "Item: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                steamItem ?? '-',
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Text(
                              "Budget: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              budgetValue ?? "-",
                              style: const TextStyle(
                                color: Colors.green,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Text(
                              "Shift: ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        CustomTextField(
                          controller: uuFlowmeterBefore,
                          label: 'Flowmeter Before',
                          icon: Icons.functions,
                        ),
                        CustomTextField(
                          controller: uuFlowmeterAfter,
                          label: 'Flowmeter After',
                          icon: Icons.functions,
                        ),
                        CustomTextField(
                          controller: uuFlowmeterTotal,
                          label: 'Total',
                          icon: Icons.functions,
                        ),
                        CustomTextField(
                          controller: uuYieldController,
                          label: 'Yield %',
                          icon: Icons.functions,
                        ),
                        CustomTextField(
                          controller: uuListrikController,
                          label: 'Listrik',
                          icon: Icons.electric_bolt_rounded,
                        ),
                        CustomTextField(
                          controller: uuAirController,
                          label: 'Air',
                          icon: Icons.water_drop_rounded,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
              SectionCard(
                title: 'Remark',
                children: [CustomRemarkField(controller: remarksController)],
              ),
              const SizedBox(height: 24),

              // === Submit Button ===
              CustomSaveButton(
                onPressed:
                    () => showSaveConfirmationDialog(
                      context,
                      onConfirm: () async => await save(),
                    ),
                label: 'Submit Laporan',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Future<void> save() async {
    final provider = context.read<DailyProductionFractionationProvider>();
    final currentUser = context.read<UserProvider>().currentUser;
    final currentPlant = context.read<PlantProvider>().currentPlant;
    final plantCode = currentPlant!.code;
    final companyName =
        context.read<BusinessUnitProvider>().currentBusinessUnit?.buCode;

    DateTime getTransactionDate() {
      final DateTime now = DateTime.now();
      return DateTime(
        now.year,
        now.month,
        now.day,
        now.hour,
        now.minute,
        now.second,
      );
    }

    DateTime getPostingDate() {
      final DateTime now = DateTime.now();

      final int hour = now.hour;

      if (hour <= 7) {
        final DateTime previousDay = now.subtract(const Duration(days: 1));
        return DateTime(
          previousDay.year,
          previousDay.month,
          previousDay.day,
          previousDay.hour,
          previousDay.minute,
          previousDay.second,
        );
      } else {
        return DateTime(
          now.year,
          now.month,
          now.day,
          now.hour,
          now.minute,
          now.second,
        );
      }
    }

    double? parseDouble(TextEditingController c) {
      final text = c.text.trim();
      return text.isEmpty || text == "-"
          ? null
          : double.parse(double.parse(text).toStringAsFixed(4));
    }

    final latestTicketIdFromProvider = await context
        .read<DailyProductionFractionationProvider>()
        .fetchLatestId(plantCode);

    Future<String> buildTicketNumber() async {
      log("TICKET NUMBER FROM PROVIDER: $latestTicketIdFromProvider");
      if (latestTicketIdFromProvider == null) {
        // return error snackbar saying plant code is not registered.
        log("id is null");
        return "";
      }
      log("lastDigit: ${latestTicketIdFromProvider.substring(9)}");
      int digit = (int.parse((latestTicketIdFromProvider.substring(9))) + 1);
      final update = await context
          .read<DailyProductionFractionationProvider>()
          .updateAutoNumber(plantCode, digit);
      String lastDigit = digit.toString().padLeft(6, '0');
      if (lastDigit == "") {
        lastDigit = "1";
      }
      log("Last Digit: $lastDigit, is update successful: $update");
      String ticketPrefixQc = latestTicketIdFromProvider.substring(0, 9);
      log(ticketPrefixQc + lastDigit);

      return ticketPrefixQc + lastDigit;
    }

    int? parseInt(String value) {
      final text = value.trim();
      return text.isEmpty ? null : int.tryParse(text);
    }

    void _showSnackBar(String message) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }

    final workCenterForSubmission =
        _isWorkCenterLockedForAddShift
            ? widget.entity?.workCenter
            : selectedWorkCenter;

    if (workCenterForSubmission == null || workCenterForSubmission.isEmpty) {
      _showSnackBar('Silakan pilih Work Center terlebih dahulu.');
      return;
    }

    if (selectedShift == null || selectedShift!.isEmpty) {
      _showSnackBar(
        _isAddShiftMode && _availableShiftOptions.isEmpty
            ? 'Semua shift untuk ticket ini sudah dibuat.'
            : 'Silakan pilih Shift terlebih dahulu.',
      );
      return;
    }

    if (!context.mounted) return;

    try {
      final postingDate = getPostingDate();
      final dataForm = widget.dataForm;
      String newTicketId = await buildTicketNumber();

      if (newTicketId.isEmpty) {
        return;
      }

      final entities =
          inputItems.asMap().entries.map((entry) {
            int index = entry.key;
            FractionationInputItem item = entry.value;

            return DailyProductionFractionationEntity(
              id: (widget.isFromAddNewShift) ? widget.entity!.id : newTicketId,
              company: companyName,
              plant: currentPlant.code,
              transactionDate: getTransactionDate(),
              postingDate: getPostingDate(),
              workCenter: workCenterForSubmission,
              shift: selectedShift,
              no: index + 1,
              oilTypeRmId: item.selectedOilRm,
              oilTypeRmCr: item.selectedCrystallizerRm,
              oilTypeRmFromTank: item.selectedTankRm,
              oilTypeRmAwalJam: item.timeAwalRm,
              oilTypeRmAwalFlowmeter: parseInt(item.flowAwalRm.text),
              oilTypeRmAkhirJam: item.timeAkhirRm,
              oilTypeRmAkhirFlowmeter: parseInt(item.flowAkhirRm.text),
              oilTypeRmTotal: parseInt(item.flowTotalRm.text),
              oilTypeFgsId: item.selectedOilFg,
              oilTypeFgsCr: item.selectedCrystallizerFg,
              oilTypeFgsAwalJam: item.timeAwalFg,
              oilTypeFgsAwalFlowmeter: parseInt(item.flowAwalFg.text),
              oilTypeFgsAkhirJam: item.timeAkhirFg,
              oilTypeFgsAkhirFlowmeter: parseInt(item.flowAkhirFg.text),
              oilTypeFgsTotal: parseInt(item.flowTotalFg.text),
              oilTypeFgsToTank: item.selectedTankFg,
              oilTypeFghId: item.selectedOilBp,
              oilTypeFghAwalJam: item.timeAwalBp,
              oilTypeFghAwalFlowmeter: parseDouble(item.flowAwalBp),
              oilTypeFghAkhirJam: item.timeAkhirBp,
              oilTypeFghAkhirFlowmeter: parseDouble(item.flowAkhirBp),
              oilTypeFghTotal: parseDouble(item.flowTotalBp),
              oilTypeFghToTank: item.selectedTankBp,
              remarks: remarksController.text,
              flag: 'T',
              uuItem: steamItem,
              uuBudgetRefQty: budgetValue,
              uuFlowmeterBefore: parseInt(uuFlowmeterBefore.text),
              uuFlowmeterAfter: parseInt(uuFlowmeterAfter.text),
              uuFlowmeterTotal: parseInt(uuFlowmeterTotal.text),
              uuYieldPercent: parseDouble(uuYieldController),
              uuListrik: parseInt(uuListrikController.text),
              uuAir: parseInt(uuAirController.text),
              entryBy: currentUser?.username,
              entryDate: DateTime.now(),
              preparedBy: null,
              preparedDate: null,
              preparedStatus: null,
              preparedStatusRemarks: null,
              verifiedBy: null,
              verifiedDate: null,
              verifiedStatus: null,
              verifiedStatusRemarks: null,
              checkedBy: null,
              checkedDate: null,
              checkedStatus: null,
              checkedStatusRemarks: null,
              formNo: dataForm.code,
              dateIssued: dataForm.dateIssued,
              revisionNo: dataForm.revisionNo,
              revisionDate: dataForm.revisionDate,
              isCompleted: false,
            );
          }).toList();

      bool? success;

      success = await provider.insertTicket(entities);

      log("is success? $success");
      if (success) {
        if (!mounted) return;
        context.read<DailyProductionFractionationProvider>().fetchAllTickets(
          null,
          null,
          currentUser?.username ?? "",
          currentUser?.role ?? "",
          plantCode,
        );
        _showSnackBar('Input berhasil.');
        if (!mounted) return;
        Navigator.pop(context);
      } else {
        _showSnackBar('Error Input.');
      }
    } catch (e) {
      log("Gagal menyimpan laporan: $e");

      final message = e.toString().replaceFirst('Exception: ', '');
      _showSnackBar("Gagal menyimpan laporan: $message");
    }
  }

  // int getShiftBasedOnTimeAndDate(DateTime time) {
  //   int hour = time.hour;
  //   int day = time.weekday;
  //   log("Day: $day, Hour: $hour");

  //   if (day >= DateTime.friday) {
  //     if (hour >= 8 && hour < 20) {
  //       return 4;
  //     } else {
  //       return 5;
  //     }
  //   } else {
  //     if (hour >= 8 && hour <= 15) {
  //       return 1;
  //     } else if (hour >= 16 && hour <= 23) {
  //       return 2;
  //     } else {
  //       return 3;
  //     }
  //   }
  // }
}
