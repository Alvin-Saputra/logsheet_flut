import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/widgets/custom_snack_bar.dart';
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

class FraDailyProductionEditPage extends StatefulWidget {
  final DataFormNoEntity dataForm;
  final List<DailyProductionFractionationEntity> listReport;

  const FraDailyProductionEditPage({
    super.key,
    required this.dataForm,
    required this.listReport,
  });

  @override
  State<FraDailyProductionEditPage> createState() =>
      _DailyProductionFractionPageState();
}

class _DailyProductionFractionPageState
    extends State<FraDailyProductionEditPage> {
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

  final TextEditingController flowMeterController = TextEditingController();
  final TextEditingController noController = TextEditingController();

  String? selectedShiftBleaching;

  final TextEditingController remarksController = TextEditingController();
  final uuFlowmeterBefore = TextEditingController();
  final uuFlowmeterAfter = TextEditingController();
  final uuFlowmeterTotal = TextEditingController();
  final uuYieldController = TextEditingController();
  final uuListrikController = TextEditingController();
  final uuAirController = TextEditingController();

  List<FractionationInputItem> inputItems = [];
  bool? isTicketComplete = false;
  List<int> deletedTicketId = [];
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    noController.dispose();

    flowMeterController.dispose();
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
      inputItems.add(FractionationInputItem());
    });
  }

  // Fungsi Hapus Row
  void removeRow(int index) {
    final itemToRemove = inputItems[index];

    setState(() {
      // 1. Jika item ini punya ticketId, berarti ini data lama dari DB.
      // Masukkan ke list deletedIds untuk dihapus dari DB nanti saat Save.
      if (itemToRemove.ticketId != null) {
        // Pastikan deletedIds bertipe List<int>
        deletedTicketId.add(itemToRemove.ticketId!);
      }

      // 2. Hapus dari tampilan UI
      inputItems.removeAt(index);
    });
  }

  void _calculateTotalFlowmeter() {
    final String awal4Text = uuFlowmeterBefore.text;
    final String akhir4Text = uuFlowmeterAfter.text;

    if (awal4Text != '' && akhir4Text != '') {
      // Coba parse nilai ke integer
      final int awal = int.parse(awal4Text);
      final int akhir = int.parse(akhir4Text);

      log("AWAL $awal AKHIR $akhir");

      // Hitung total: Akhir - Awal
      final int total = akhir - awal;
      uuFlowmeterTotal.text = total.toString();
    } else {
      // Kosongkan total jika ada input yang tidak valid
      uuFlowmeterTotal.text = '';
    }
  }

  void _showHourPickerAndUpdateState(
    Function(TimeOfDay) onTimeSelected,
    TimeOfDay? selectedTime,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (context) => CustomHourMinutePicker(
            selectedTime: selectedTime,
            onTimeSelected: (time) {
              onTimeSelected(time);
            },
          ),
      // builder:
      //     (context) => CustomHourPicker(
      //       selectedHour: selectedHour,
      //       onHourSelected: (hour) {
      //         onHourSelected(hour);
      //         // Navigator.pop(context);
      //       },
      //     ),
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

  void _prepopulateData() {
    // Ambil data header dari item pertama (karena Header biasanya sama untuk 1 grup tiket)
    final firstItem = widget.listReport.first;

    setState(() {
      // A. Prepopulate Header
      selectedWorkCenter = firstItem.workCenter;
      selectedTransactionDate = firstItem.transactionDate ?? DateTime.now();
      selectedShift = firstItem.shift;

      if (firstItem.uuFlowmeterBefore != null || firstItem.uuItem != null) {
        isUtillityUsageActive = true;
      }

      steamItem = firstItem.uuItem ?? "Steam (Ton/Ton CPO)";

      uuFlowmeterBefore.text = firstItem.uuFlowmeterBefore?.toString() ?? "";
      uuFlowmeterAfter.text = firstItem.uuFlowmeterAfter?.toString() ?? "";
      uuFlowmeterTotal.text = firstItem.uuFlowmeterTotal?.toString() ?? "";
      uuYieldController.text = firstItem.uuYieldPercent?.toString() ?? "";
      uuListrikController.text = firstItem.uuListrik?.toString() ?? "";
      uuAirController.text = firstItem.uuAir?.toString() ?? "";

      remarksController.text = firstItem.remarks ?? "";

      inputItems =
          widget.listReport.map((entity) {
            final item = FractionationInputItem();
            item.id = entity.id;
            item.existingNo = entity.no;
            item.ticketId = entity.ticketId;
            // 1. Raw Material Mapping
            item.selectedOilRm = entity.oilTypeRmId;
            item.selectedTankRm = entity.oilTypeRmFromTank;
            item.selectedCrystallizerRm = entity.oilTypeRmCr;
            item.timeAwalRm = entity.oilTypeRmAwalJam;
            item.timeAkhirRm = entity.oilTypeRmAkhirJam;
            item.flowAwalRm.text =
                entity.oilTypeRmAwalFlowmeter?.toString() ?? "";
            item.flowAkhirRm.text =
                entity.oilTypeRmAkhirFlowmeter?.toString() ?? "";
            item.flowTotalRm.text = entity.oilTypeRmTotal?.toString() ?? "";

            if (entity.oilTypeRmId == null &&
                entity.oilTypeRmFromTank == null &&
                entity.oilTypeRmCr == null &&
                entity.oilTypeRmAwalJam == null &&
                entity.oilTypeRmAkhirJam == null &&
                entity.oilTypeRmAwalFlowmeter == null &&
                entity.oilTypeRmAkhirFlowmeter == null &&
                entity.oilTypeRmTotal == null) {
              item.showRM = false;
            }

            // 2. Finish Goods Mapping
            item.selectedOilFg = entity.oilTypeFghId;
            item.selectedTankFg =
                entity.oilTypeFgsToTank; // Pastikan field ini sesuai
            // item.selectedCrystallizerFg = entity.oilTypeFgsCr; // Jika ada field ini di input item
            item.selectedOilFg =
                entity.oilTypeFgsId; // Override jika per-row bisa beda
            item.timeAwalFg = entity.oilTypeFgsAwalJam;
            item.timeAkhirFg = entity.oilTypeFgsAkhirJam;
            item.flowAwalFg.text =
                entity.oilTypeFgsAwalFlowmeter?.toString() ?? "";
            item.flowAkhirFg.text =
                entity.oilTypeFgsAkhirFlowmeter?.toString() ?? "";
            item.flowTotalFg.text = entity.oilTypeFgsTotal?.toString() ?? "";

            if (entity.oilTypeFgsId == null &&
                entity.oilTypeFgsToTank == null &&
                entity.oilTypeFgsCr == null &&
                entity.oilTypeFgsAwalJam == null &&
                entity.oilTypeFgsAkhirJam == null &&
                entity.oilTypeFgsAwalFlowmeter == null &&
                entity.oilTypeFgsAkhirFlowmeter == null &&
                entity.oilTypeFgsTotal == null) {
              item.showFG = false;
            }

            // 3. By Product Mapping
            item.selectedOilBp = entity.oilTypeFgsId;
            item.selectedTankBp = entity.oilTypeFghToTank;
            item.selectedOilBp =
                entity.oilTypeFghId; // Override jika per-row bisa beda
            item.timeAwalBp = entity.oilTypeFghAwalJam;
            item.timeAkhirBp = entity.oilTypeFghAkhirJam;
            // Perhatikan tipe data (int vs double), sesuaikan toString()
            item.flowAwalBp.text =
                entity.oilTypeFghAwalFlowmeter?.toString() ?? "";
            item.flowAkhirBp.text =
                entity.oilTypeFghAkhirFlowmeter?.toString() ?? "";
            item.flowTotalBp.text = entity.oilTypeFghTotal?.toString() ?? "";

            if (entity.oilTypeFghId == null &&
                entity.oilTypeFghToTank == null &&
                entity.oilTypeFghAwalJam == null &&
                entity.oilTypeFghAkhirJam == null &&
                entity.oilTypeFghAwalFlowmeter == null &&
                entity.oilTypeFghAkhirFlowmeter == null &&
                entity.oilTypeFghTotal == null) {
              item.showBP = false;
            }
            return item;
          }).toList();
    });
  }

  @override
  void initState() {
    super.initState();
    // _addNewRow();
    final valueProvider = context.read<ValueProvider>();
    final productProvider = context.read<ProductProvider>();
    final crystallizerProvider = context.read<CrystallizerProvider>();

    if (valueProvider.tankSourceList.isEmpty ||
        productProvider.productFractionationList.isEmpty ||
        crystallizerProvider.crystallizerList.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await valueProvider.fetchAllInitialData();
        await productProvider.fetchProducts();
        await crystallizerProvider.fetchCrystallizer();
        tankLists = valueProvider.tankSourceList;
      });
    }

    if (widget.listReport.isNotEmpty) {
      _prepopulateData();
    } else {
      // Jika kosong (Mode Insert Baru), tambah 1 baris kosong
      _addNewRow();
    }

    uuFlowmeterBefore.addListener(_calculateTotalFlowmeter);
    uuFlowmeterAfter.addListener(_calculateTotalFlowmeter);
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


  String? _validateNonFormFields() {
    for (int i = 0; i < inputItems.length; i++) {
      var item = inputItems[i];
      // FormKey tidak bisa cek TimeOfDay, jadi cek manual di sini
      if (item.showRM == true) {
        if (item.timeAwalRm == null || item.timeAkhirRm == null)
          return "Jam Raw Material di baris ${i + 1} belum diisi";
      }

      if (item.showFG == true) {
        if (item.timeAwalFg == null || item.timeAkhirFg == null)
          return "Jam Finish Goods di baris ${i + 1} belum diisi";
      }

      if (item.showBP == true) {
        if (item.timeAwalBp == null || item.timeAkhirBp == null)
          return "Jam By Product di baris ${i + 1} belum diisi";
      }
    }
    return null;
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
    return Scaffold(
      backgroundColor: const Color(0xFFEFF3F9),
      appBar: CustomAppBar(
        title: 'Daily Production - Fractionation (${widget.dataForm.code})',
        onRefresh: _refreshPage,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
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
                    onChanged: null,
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
                onTap: null,
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
                    style: const TextStyle(fontSize: 16, color: Colors.black45),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Oil Type Dropdown
              DropdownButtonFormField<String>(
                value: selectedShift,
                items:
                    dummyShiftOptions.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(
                          "${item}",
                          style: const TextStyle(fontSize: 14),
                        ),
                      );
                    }).toList(),
                onChanged: null,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFFF0ECE9),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  labelText: 'Pilih Shift',
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
              const SizedBox(height: 16),
              if (selectedWorkCenter == null) ...[
                const Center(
                  child: Text(
                    'Silakan pilih part terlebih dahulu',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ] else ...[
                for (int i = 0; i < inputItems.length; i++) ...{
                  // === Section: CPO RPA RPS (Raw Material) ===
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: ExpansionTile(
                      trailing: IconButton(
                        onPressed: () {
                          setState(() {
                            removeRow(i);
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
                        // if (i > 0)
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
                                            inputItems[i]
                                                .selectedCrystallizerRm = null;
                                            inputItems[i].selectedTankRm = null;

                                            inputItems[i].flowAwalRm.clear();
                                            inputItems[i].flowAkhirRm.clear();
                                            inputItems[i].flowTotalRm.clear();
                                          }
                                        });
                                      },
                                      checkmarkColor: Colors.black,
                                      selectedColor: Colors.red.withOpacity(
                                        0.2,
                                      ),
                                    ),

                                    // === CHIP FINISH GOODS ===
                                    FilterChip(
                                      label: const Text("Finish Goods"),
                                      selected: inputItems[i].showFG!,
                                      onSelected: (val) {
                                        setState(() {
                                          inputItems[i].showFG = val;

                                          if (!val) {
                                            inputItems[i].timeAwalFg = null;
                                            inputItems[i].timeAkhirFg = null;
                                            inputItems[i].selectedTankFg = null;
                                            inputItems[i].selectedOilFg = null;
                                            inputItems[i]
                                                .selectedCrystallizerFg = null;
                                            inputItems[i].selectedTankFg = null;

                                            inputItems[i].flowAwalFg.clear();
                                            inputItems[i].flowAkhirFg.clear();
                                            inputItems[i].flowTotalFg.clear();
                                          }
                                        });
                                      },
                                      checkmarkColor: Colors.black,
                                      selectedColor: Colors.red.withOpacity(
                                        0.2,
                                      ),
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
                                      selectedColor: Colors.red.withOpacity(
                                        0.2,
                                      ),
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
                            onCrystallizerChanged:
                                (val) => setState(
                                  () =>
                                      inputItems[i].selectedCrystallizerRm =
                                          val,
                                ),
                            onOilRmChanged:
                                (val) => setState(
                                  () => inputItems[i].selectedOilRm = val,
                                ),
                            selectedOil: inputItems[i].selectedOilRm,

                            onUseTankFromLastShiftChangedRm:
                                (val) => setState(() {}),

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
                        const SizedBox(height: 16),

                        // === Section: RBDPO RRBDPO RPS (Finish Good) ===
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
                            onCrystallizerChanged:
                                (val) => setState(
                                  () =>
                                      inputItems[i].selectedCrystallizerFg =
                                          val,
                                ),
                          ),
                        const SizedBox(height: 16),

                        // === Section: RFAD (By Product) ===
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
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
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
                            isRequired: true,
                          ),
                          CustomTextField(
                            controller: uuFlowmeterAfter,
                            label: 'Flowmeter After',
                            icon: Icons.functions,
                            isRequired: true,
                          ),
                          CustomTextField(
                            controller: uuFlowmeterTotal,
                            label: 'Total',
                            icon: Icons.functions,
                            isRequired: true,
                          ),
                          CustomTextField(
                            controller: uuYieldController,
                            label: 'Yield %',
                            icon: Icons.functions,
                            isRequired: true,
                          ),
                          CustomTextField(
                            controller: uuListrikController,
                            label: 'Listrik',
                            icon: Icons.electric_bolt_rounded,
                            isRequired: true,
                          ),
                          CustomTextField(
                            controller: uuAirController,
                            label: 'Air',
                            icon: Icons.water_drop_rounded,
                            isRequired: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              CheckboxListTile(
                  value: isTicketComplete ?? false,
                  title: Text(
                    "Ticket Selesai",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  onChanged: (value) {
                    setState(() {
                      String? nonFormFieldsValidationMessage =
                          _validateNonFormFields();

                      if (nonFormFieldsValidationMessage != null) {
                        showSnackBar(nonFormFieldsValidationMessage, context);
                      } else if (nonFormFieldsValidationMessage == null &&
                          _formKey.currentState!.validate()) {
                        isTicketComplete = value;
                      }
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                  activeColor: Colors.green,
                  checkboxShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
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
      final DateTime now = selectedTransactionDate;
      return DateTime(
        now.year,
        now.month,
        now.day,
        0,
        0,
        0,
        // now.hour,
        // now.minute,
        // now.second,
      );
    }

    DateTime getPostingDate() {
      final DateTime now = selectedTransactionDate;

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

    Future<List<String>> buildTicketNumbers(int batchSize) async {
      log("TICKET NUMBER FROM PROVIDER: $latestTicketIdFromProvider");

      if (latestTicketIdFromProvider == null) {
        log("id is null");
        return [];
      }

      // 1. Ambil prefix dan angka terakhir saat ini
      // Asumsi format: PREFIX(9 char) + NUMBER(6 char)
      String ticketPrefix = latestTicketIdFromProvider!.substring(0, 9);
      String numberPart = latestTicketIdFromProvider!.substring(9);

      int currentLastNumber = int.parse(numberPart);

      // 2. Hitung angka terakhir yang baru setelah ditambah jumlah data (batchSize)
      int newLastNumber = currentLastNumber + batchSize;

      // 3. Update database autonumber ke angka TERAKHIR sekaligus
      // Jadi jika batchSize 5, autonumber langsung lompat 5 angka.
      final update = await context
          .read<DailyProductionFractionationProvider>()
          .updateAutoNumber(plantCode, newLastNumber);

      log("Updating autonumber to: $newLastNumber, success: $update");

      if (!update) {
        // Handle error jika gagal update DB
        return [];
      }

      // 4. Generate List ID untuk dikembalikan ke UI
      List<String> generatedIds = [];

      for (int i = 1; i <= batchSize; i++) {
        // Generate urutan: current + 1, current + 2, dst...
        int sequenceNumber = currentLastNumber + i;
        String formattedNumber = sequenceNumber.toString().padLeft(6, '0');
        generatedIds.add(ticketPrefix + formattedNumber);
      }

      return generatedIds;
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

    String? convertStringTimeToDateTime(int? hour) {
      try {
        log("$hour");
        if (hour == null) {
          return null;
        }

        if (hour < 0 || hour > 23) {
          throw FormatException(
            "Hour must be between 0 and 23, but was $hour.",
          );
        }
        final formattedHour = "${hour.toString().padLeft(2, '0')}:00";

        return formattedHour;
      } on FormatException catch (e) {
        log("Error processing time string '$hour': $e");
        rethrow;
      }
    }

    if (!context.mounted) return;

    int newItemIndexCounter = 0;
    try {
      String existingId = widget.listReport[0].id;
      final dataForm = widget.dataForm;
      final postingDate = getPostingDate();
      final entities =
          inputItems.asMap().entries.map((entry) {
            int index = entry.key;
            FractionationInputItem item = entry.value;

            int ticketNo;

            if (item.id != null) {
              ticketNo = item.existingNo ?? (index + 1);
            } else {
              ticketNo = index + 1;
            }

            return DailyProductionFractionationEntity(
              id: existingId,
              ticketId: item.ticketId,
              company: companyName,
              plant: currentPlant.code,
              transactionDate: getTransactionDate(),
              postingDate: postingDate,
              workCenter: selectedWorkCenter,
              shift: selectedShift,
              no: index + 1,
              oilTypeRmId: selectedOilRm,
              oilTypeRmCr: item.selectedCrystallizerRm,
              oilTypeRmFromTank: item.selectedTankRm,
              oilTypeRmAwalJam: item.timeAwalRm,
              oilTypeRmAwalFlowmeter: parseInt(item.flowAwalRm.text),
              oilTypeRmAkhirJam: item.timeAkhirRm,
              oilTypeRmAkhirFlowmeter: parseInt(item.flowAkhirRm.text),
              oilTypeRmTotal: parseInt(item.flowTotalRm.text),
              oilTypeFgsId: selectedOilFg,
              oilTypeFgsCr: item.selectedCrystallizerFg,
              oilTypeFgsAwalJam: item.timeAwalFg,
              oilTypeFgsAwalFlowmeter: parseInt(item.flowAwalFg.text),
              oilTypeFgsAkhirJam: item.timeAkhirFg,
              oilTypeFgsAkhirFlowmeter: parseInt(item.flowAkhirFg.text),
              oilTypeFgsTotal: parseInt(item.flowTotalFg.text),
              oilTypeFgsToTank: item.selectedTankFg,
              oilTypeFghId: selectedOilBp,
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
              isCompleted: isTicketComplete,
            );
          }).toList();

      bool? success = await provider.updateReport(
        entities,
        deletedTicketId,
        currentUser?.username ?? "",
        currentUser?.role ?? "",
        plantCode,
      );

      // ... Handle success/error (tetap sama) ...
      if (success) {
        if (!mounted) return;
        // ... fetchAllTickets ...
        _showSnackBar('Update berhasil.');
        Navigator.pop(context);
      } else {
        _showSnackBar('Gagal update.');
      }
    } catch (e) {
      log("Gagal menyimpan laporan: $e");
      _showSnackBar("Gagal menyimpan laporan: $e");
    }
  }

  int getShiftBasedOnTimeAndDate(DateTime time) {
    int hour = time.hour;
    int day = time.weekday;
    log("Day: $day, Hour: $hour");

    if (day >= DateTime.friday) {
      if (hour >= 8 && hour < 20) {
        return 4;
      } else {
        return 5;
      }
    } else {
      if (hour >= 8 && hour <= 15) {
        return 1;
      } else if (hour >= 16 && hour <= 23) {
        return 2;
      } else {
        return 3;
      }
    }
  }
}
