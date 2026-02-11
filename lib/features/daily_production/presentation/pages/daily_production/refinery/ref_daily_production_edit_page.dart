import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:logsheet_app/core/widgets/custom_snack_bar.dart';
import 'package:logsheet_app/features/daily_production/data/model/daily_production/daily_production_refinery_entity.dart';
import 'package:logsheet_app/features/daily_production/presentation/pages/daily_production/refinery/ref_input_item.dart';
import 'package:logsheet_app/features/master_data/data/model/master/data_form_no_entity.dart';
import 'package:logsheet_app/features/master_data/data/model/master/tank_entity.dart';
import 'package:logsheet_app/features/master_data/data/model/master/value_entity.dart';
import 'package:logsheet_app/features/daily_production/presentation/pages/daily_production/refinery/ref_section_auxiliary_material.dart';
import 'package:logsheet_app/core/widgets/custom_app_bar.dart';
import 'package:logsheet_app/core/widgets/custom_hour_minute_picker.dart';
import 'package:logsheet_app/core/widgets/custom_remark_field.dart';
import 'package:logsheet_app/core/widgets/custom_save_button.dart';
import 'package:logsheet_app/core/widgets/custom_section_title.dart';
import 'package:logsheet_app/core/widgets/custom_text_field.dart';
import 'package:logsheet_app/core/widgets/section_card.dart';
import 'package:logsheet_app/features/daily_production/presentation/provider/daily_production/daily_production_refinery_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/business_unit_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/plant_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/product_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/user_provider.dart';
import 'package:logsheet_app/features/master_data/presentation/provider/master/value_provider.dart';
import 'package:provider/provider.dart';

import 'ref_section_cpo_rpa_rps.dart';
import 'ref_section_rbdpo_rrbdpo_rps.dart';
import 'ref_section_rfad.dart';

class RefDailyProductionEditPage extends StatefulWidget {
  final List<DailyProductionRefineryEntity> listReport;
  final DataFormNoEntity dataForm;
  const RefDailyProductionEditPage({
    super.key,
    required this.listReport,
    required this.dataForm,
  });

  @override
  State<RefDailyProductionEditPage> createState() =>
      _DailyProductionPageState();
}

class _DailyProductionPageState extends State<RefDailyProductionEditPage> {
  bool isLoading = true;
  String? selected1Tank;
  String? selected2Tank;
  String? selected3Tank;

  DateTime selectedPostingDate = DateTime.now();

  String? selectedRefineryMachine;
  String? budgetValue;
  String? paValue;

  // Utility Usage fixed values based on machine
  Map<String, double> utilityBudget = {'REF-02': 0.13, 'REF-01': 0.27};
  Map<String, double> paValues = {'REF-02': 3.70, 'REF-01': 2.18};

  bool isBahanPenolongActive = false;
  bool isUtillityUsageActive = false;

  List<TankEntity>? tankLists;
  List<MasterValueEntity>? oilTypeLists;

  final List<String> dummyShiftOptions = ['1', '2', '3', "4", "5"];
  String? selectedShift;

  final beTotalBagController = TextEditingController();
  final beTotalJenisController = TextEditingController();
  final beLotBatchNumberController = TextEditingController();

  final paTotalController = TextEditingController();
  final paLotBatchNumberController = TextEditingController();
  final paYieldPercentageController = TextEditingController();

  final totalOilController = TextEditingController();
  final totalSteamController = TextEditingController();
  final steamOilTypeController = TextEditingController();
  final yieldPercentController = TextEditingController();

  // Bleaching Earth
  String? selectedShiftBleaching;
  bool ref500Bleaching = false;
  bool ref150Bleaching = false;
  final TextEditingController bleachingBagController = TextEditingController();
  final TextEditingController bleachingTypeController = TextEditingController();
  final TextEditingController bleachingBatchController =
      TextEditingController();
  final TextEditingController bleachingYieldPercentController =
      TextEditingController();

  // Phosphoric Acid
  String? selectedShiftPhosphoric;
  String? steamItem;
  bool ref500Phosphoric = false;
  bool ref150Phosphoric = false;
  final TextEditingController phosphoricWeightController =
      TextEditingController();
  final TextEditingController phosphoricVolumeController =
      TextEditingController();
  final TextEditingController phosphoricYieldController =
      TextEditingController();
  final TextEditingController phosphoricBatchController =
      TextEditingController();
  final TextEditingController phosphoricTotalController =
      TextEditingController();

  final TextEditingController remarksController = TextEditingController();

  List<RefineryInputItem> inputItems = [];
  List<int> deletedTicketId = [];
  bool? isTicketComplete = false;
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    super.dispose();

    beTotalBagController.dispose();
    beTotalJenisController.dispose();
    beLotBatchNumberController.dispose();
    paTotalController.dispose();
    paLotBatchNumberController.dispose();
    paYieldPercentageController.dispose();
    bleachingBagController.dispose();
    bleachingTypeController.dispose();
    bleachingBatchController.dispose();
    phosphoricWeightController.dispose();
    phosphoricVolumeController.dispose();
    phosphoricYieldController.dispose();
    phosphoricBatchController.dispose();

    totalOilController.dispose();
    totalSteamController.dispose();
    steamOilTypeController.dispose();
    yieldPercentController.dispose();
  }

  void _addNewRow() {
    setState(() {
      bool isDefaultRow = inputItems.isEmpty;
      inputItems.add(
        RefineryInputItem(
          showRM: isDefaultRow, // True jika row 0, False jika row > 0
          showFG: isDefaultRow,
          showBP: isDefaultRow,
        ),
      );
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

  void _showHourPickerAndUpdateState(
    TimeOfDay? selectedTime,
    Function(TimeOfDay) onTimeSelected,
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
                  },
                ),
              ],
            ),
          ),
    );
  }

  Future<void> _selectPostingDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedPostingDate,
      firstDate: DateTime(2000),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null && picked != selectedPostingDate) {
      setState(() {
        selectedPostingDate = picked;
      });
    }
  }

  Future<void> _refreshPage() async {
    setState(() => isLoading = true);
    await Future.delayed(const Duration(milliseconds: 600));
    setState(() => isLoading = false);
  }

  void _prepopulateData() {
    final firstItem = widget.listReport.first;

    setState(() {
      selectedRefineryMachine = firstItem.workCenter;
      selectedPostingDate = firstItem.transactionDate ?? DateTime.now();
      selectedShift = firstItem.shift;

      if (firstItem.beTotalBag != null) {
        isBahanPenolongActive = true;
      }

      if (firstItem.uuBudgetRefTank != null || firstItem.uuItem != null) {
        isUtillityUsageActive = true;
      }

      steamItem = firstItem.uuItem ?? "Steam (Ton/Ton CPO)";

      remarksController.text = firstItem.remarks ?? "";

      // C. Prepopulate List Rows (Input Items)
      // Kita mapping setiap Entity di listReport menjadi FractionationInputItem
      inputItems =
          widget.listReport.map((entity) {
            final item = RefineryInputItem();
            item.id = entity.id;
            item.existingNo = entity.no;
            item.ticketId = entity.ticketId;
            // 1. Raw Material Mapping

            item.selectedOilRm = entity.oilTypeRmId;
            item.selectedTankRm = entity.cpoTank;
            item.timeAwalRm = entity.oilTypeRmAwalJam;
            item.timeAkhirRm = entity.oilTypeRmAkhirJam;
            item.flowAwalRm.text =
                entity.oilTypeRmAwalFlowmeter?.toString() ?? "";
            item.flowAkhirRm.text =
                entity.oilTypeRmAkhirFlowmeter?.toString() ?? "";
            item.flowTotalRm.text = entity.oilTypeRmTotal?.toString() ?? "";
            item.oipRm.text = entity.oilTypeRmOip?.toString() ?? "";

            if (entity.oilTypeRmId == null &&
                entity.cpoTank == null &&
                entity.oilTypeRmAwalJam == null &&
                entity.oilTypeRmAkhirJam == null &&
                entity.oilTypeRmAwalFlowmeter == null &&
                entity.oilTypeRmAkhirFlowmeter == null &&
                entity.oilTypeRmTotal == null &&
                entity.oilTypeRmOip == null) {
              item.showRM = false;
            }

            // 2. Finish Goods Mapping
            // item.selectedOilFg = entity.oilTypeFgId;
            // item.selectedTankFg = entity.oilTypeFgToTank;
            item.selectedOilFg = entity.oilTypeFgId;
            item.timeAwalFg = entity.oilTypeFgAwalJam;
            item.timeAkhirFg = entity.oilTypeFgAkhirJam;
            item.flowAwalFg.text =
                entity.oilTypeFgAwalFlowmeter?.toString() ?? "";
            item.flowAkhirFg.text =
                entity.oilTypeFgAkhirFlowmeter?.toString() ?? "";
            item.flowTotalFg.text = entity.oilTypeFgTotal?.toString() ?? "";
            item.selectedTankFg = entity.oilTypeFgToTank;

            if (entity.oilTypeFgId == null &&
                entity.oilTypeFgToTank == null &&
                entity.oilTypeFgAwalJam == null &&
                entity.oilTypeFgAkhirJam == null &&
                entity.oilTypeFgAwalFlowmeter == null &&
                entity.oilTypeFgAkhirFlowmeter == null &&
                entity.oilTypeFgTotal == null) {
              item.showFG = false;
            }

            // 3. By Product Mapping
            item.selectedOilBp = entity.oilTypeBpId;
            item.selectedTankBp = entity.bpToTank;

            item.timeAwalBp = entity.bpAwalJam;
            item.timeAkhirBp = entity.bpAkhirJam;
            // Perhatikan tipe data (int vs double), sesuaikan toString()
            item.flowAwalBp.text = entity.bpAwalFlowmeter?.toString() ?? "";
            item.flowAkhirBp.text = entity.bpAkhirFlowmeter?.toString() ?? "";
            item.flowTotalBp.text = entity.bpTotal?.toString() ?? "";

            if (entity.oilTypeBpId == null &&
                entity.bpToTank == null &&
                entity.bpAwalJam == null &&
                entity.bpAkhirJam == null &&
                entity.bpAwalFlowmeter == null &&
                entity.bpAkhirFlowmeter == null &&
                entity.bpTotal == null) {
              item.showBP = false;
            }

            return item;
          }).toList();

      if (selectedRefineryMachine == "REF-02") {
        ref500Bleaching = true;
        ref150Bleaching = false;

        ref500Phosphoric = true;
        ref150Phosphoric = false;
      } else {
        ref500Bleaching = false;
        ref150Bleaching = true;

        ref500Phosphoric = false;
        ref150Phosphoric = true;
      }

      bleachingBagController.text = firstItem.beTotalBag?.toString() ?? "";
      bleachingTypeController.text = firstItem.beTotalJenis ?? "";
      bleachingBatchController.text =
          firstItem.beLotBatchNumber?.toString() ?? "";
      bleachingYieldPercentController.text =
          firstItem.beYieldPercent?.toString() ?? "";

      phosphoricTotalController.text = firstItem.paTotal?.toString() ?? "";
      phosphoricBatchController.text =
          firstItem.paLotBatchNumber?.toString() ?? "";
      phosphoricYieldController.text =
          firstItem.paYieldPercent?.toString() ?? "";

      steamItem = firstItem.uuItem ?? '';
      totalOilController.text = firstItem.uuTotalCpo?.toString() ?? "";
      totalSteamController.text = firstItem.uuTotalSteam?.toString() ?? "";
      steamOilTypeController.text = firstItem.uuSteamCpo?.toString() ?? "";
      yieldPercentController.text = firstItem.uuYieldPercent?.toString() ?? "";
    });
  }

  @override
  void initState() {
    super.initState();
    final valueProvider = context.read<ValueProvider>();
    final productProvider = context.read<ProductProvider>();

    if (valueProvider.tankSourceList.isEmpty ||
        productProvider.productFractionationList.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
        await valueProvider.fetchAllInitialData();
        await productProvider.fetchProducts();
        tankLists = valueProvider.tankSourceList;
      });
    }

    tankLists = context.read<ValueProvider>().tankSourceList;

    if (widget.listReport.isNotEmpty) {
      _prepopulateData();
    } else {
      // Jika kosong (Mode Insert Baru), tambah 1 baris kosong
      _addNewRow();
    }
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
            context.watch<DailyProductionRefineryProvider>().isLoading;

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
    steamItem = 'Steam (Ton/Ton))';
    budgetValue =
        selectedRefineryMachine != null &&
                utilityBudget.containsKey(selectedRefineryMachine)
            ? selectedRefineryMachine == 'REF-01'
                ? '${utilityBudget['REF-01']}'
                : '${utilityBudget['REF-02']}'
            : 'N/A';

    paValue =
        selectedRefineryMachine != null &&
                paValues.containsKey(selectedRefineryMachine)
            ? selectedRefineryMachine == 'REF-01'
                ? '${paValues['REF-01']} cm'
                : '${paValues['REF-02']} cm'
            : 'N/A';

    // Determine current shift based on local time for display
    final currentShift = getShiftBasedOnTimeAndDate(DateTime.now()).toString();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Daily Production - \nRefinery (${widget.dataForm.code})',
        onRefresh: _refreshPage,
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Consumer<ValueProvider>(
                builder: (context, provider, child) {
                  if (provider.isLoading) {
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
                  if (provider.workCenterLists.isEmpty) {
                    return TextFormField(
                      readOnly: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(0xFFF0ECE9),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        hintText: 'Refinery Machine tidak ditemukan.',
                        prefixIcon: const Padding(
                          padding: EdgeInsets.all(12.0),
                          child: Icon(Icons.warning_amber_rounded),
                        ),
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.refresh),
                          onPressed: () async {
                            await context
                                .read<ValueProvider>()
                                .fetchWorkCenterLists();
                          },
                        ),
                      ),
                    );
                  }
                  return DropdownButtonFormField<String>(
                    value: selectedRefineryMachine,
                    items:
                        provider.workCenterLists.map((machine) {
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
                // onTap: _selectPostingDate,
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
                    DateFormat('dd MMMM yyyy').format(selectedPostingDate),
                    style: const TextStyle(fontSize: 16, color: Colors.black45),
                  ),
                ),
              ),
              const SizedBox(height: 8),

              // Oil Type Dropdown
              const SizedBox(height: 8),

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

              SizedBox(height: 8.0),

              SizedBox(height: 8.0),
              Text(
                "Daily Refinery Data",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8.0),

              if (selectedRefineryMachine == null) ...[
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
                                            inputItems[i].oipRm.clear();
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
                          SectionCpoRpaRps(
                            // RM Time Awal
                            selectedTimeAwal: inputItems[i].timeAwalRm,
                            onTimeTapAwal:
                                () => _showHourPickerAndUpdateState(
                                  inputItems[i].timeAwalRm,
                                  (hour) => setState(() {
                                    inputItems[i].timeAwalRm = hour;
                                  }),
                                ),
                            // RM Time Akhir
                            selectedTimeAkhir: inputItems[i].timeAkhirRm,
                            onTimeTapAkhir:
                                () => _showHourPickerAndUpdateState(
                                  inputItems[i].timeAkhirRm,
                                  (hour) => setState(() {
                                    inputItems[i].timeAkhirRm = hour;
                                  }),
                                ),
                            selectedWorkCenter:
                                selectedRefineryMachine, // Remains global
                            dummmyTanks: tankLists, // Remains global
                            // RM Tank
                            selectedTank: inputItems[i].selectedTankRm,
                            onTankChanged: (val) {
                              setState(() {
                                inputItems[i].selectedTankRm = val;

                                // inputItems[i].isUseLastTankRm = false;
                              });
                            },
                            // RM Controllers
                            flowRateAwalController: inputItems[i].flowAwalRm,
                            flowRateAkhirController: inputItems[i].flowAkhirRm,
                            flowRateTotalController: inputItems[i].flowTotalRm,
                            oipController: inputItems[i].oipRm,
                            onOilRmChanged:
                                (value) => setState(() {
                                  inputItems[i].selectedOilRm = value;
                                }),
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
                          SectionRbdpoRrbdpoRps(
                            // FG Time Awal
                            selectedTimeAwal: inputItems[i].timeAwalFg,
                            onTimeTapAwal:
                                () => _showHourPickerAndUpdateState(
                                  inputItems[i].timeAwalFg,
                                  (hour) => setState(() {
                                    inputItems[i].timeAwalFg = hour;
                                  }),
                                ),
                            // FG Time Akhir
                            selectedTimeAkhir: inputItems[i].timeAkhirFg,
                            onTimeTapAkhir:
                                () => _showHourPickerAndUpdateState(
                                  inputItems[i].timeAkhirFg,
                                  (hour) => setState(() {
                                    inputItems[i].timeAkhirFg = hour;
                                  }),
                                ),
                            selectedWorkCenter:
                                selectedRefineryMachine, // Remains global
                            tankList: tankLists, // Remains global
                            // FG Tank
                            selectedTank: inputItems[i].selectedTankFg,
                            onTankChanged:
                                (value) => setState(() {
                                  inputItems[i].selectedTankFg = value;
                                }),
                            // FG Controllers
                            flowRateAwalController: inputItems[i].flowAwalFg,
                            flowRateAkhirController: inputItems[i].flowAkhirFg,
                            flowRateTotalController: inputItems[i].flowTotalFg,
                            // FG Oil Selection
                            selectedOil: inputItems[i].selectedOilFg,

                            onOilFgChanged:
                                (oilFg) => setState(() {
                                  inputItems[i].selectedOilFg = oilFg;
                                }),
                          ),
                        const SizedBox(height: 16),

                        // === Section: RFAD (By Product) ===
                        if (inputItems[i].showBP == true)
                          SectionRfad(
                            // BP Time Awal
                            selectedTimeAwal: inputItems[i].timeAwalBp,
                            onTimeTapAwal:
                                () => _showHourPickerAndUpdateState(
                                  inputItems[i].timeAwalBp,
                                  (hour) => setState(() {
                                    inputItems[i].timeAwalBp = hour;
                                  }),
                                ),
                            // BP Time Akhir
                            selectedTimeAkhir: inputItems[i].timeAkhirBp,
                            onTimeTapAkhir:
                                () => _showHourPickerAndUpdateState(
                                  inputItems[i].timeAkhirBp,
                                  (hour) => setState(() {
                                    inputItems[i].timeAkhirBp = hour;
                                  }),
                                ),
                            selectedWorkCenter:
                                selectedRefineryMachine, // Remains global
                            tankLists: tankLists, // Remains global
                            // BP Tank
                            selectedTank: inputItems[i].selectedTankBp,
                            onTankChanged:
                                (value) => setState(() {
                                  inputItems[i].selectedTankBp = value;
                                }),
                            // BP Controllers
                            flowRateAwalController: inputItems[i].flowAwalBp,
                            flowRateAkhirController: inputItems[i].flowAkhirBp,
                            flowRateTotalController: inputItems[i].flowTotalBp,
                            // BP Oil Selection
                            selectedOil: inputItems[i].selectedOilBp,
                            onOilBpChanged:
                                (oil) => setState(() {
                                  inputItems[i].selectedOilBp = oil;
                                }),
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
                // CheckBox to activate the bahan penolong card
                CheckboxListTile(
                  value: isBahanPenolongActive,
                  title: Text("Input Pemakaian Bahan Penolong"),
                  onChanged: (value) {
                    setState(() {
                      isBahanPenolongActive = !isBahanPenolongActive;
                    });
                  },
                  controlAffinity: ListTileControlAffinity.leading,
                ),

                if (isBahanPenolongActive) ...[
                  // === Section: Auxiliary Material ===
                  SectionAuxiliaryMaterial(
                    shiftOptions: dummyShiftOptions,
                    selectedShiftBleaching: selectedShiftBleaching,
                    selectedShiftPhosphoric: selectedShiftPhosphoric,
                    bleachingBagController: bleachingBagController,
                    bleachingTypeController: bleachingTypeController,
                    bleachingBatchController: bleachingBatchController,
                    bleachingBatchYieldPercentController:
                        bleachingYieldPercentController,
                    ref500Bleaching: ref500Bleaching,
                    ref150Bleaching: ref150Bleaching,
                    phosphoricWeightController: phosphoricWeightController,
                    phosphoricVolumeController: phosphoricVolumeController,
                    phosphoricYieldController: phosphoricYieldController,
                    phosphoricBatchController: phosphoricBatchController,
                    ref500Phosphoric: ref500Phosphoric,
                    ref150Phosphoric: ref150Phosphoric,
                    onBleachingShiftChanged:
                        (value) =>
                            setState(() => selectedShiftBleaching = value),
                    onPhosphoricShiftChanged:
                        (value) =>
                            setState(() => selectedShiftPhosphoric = value),
                    selectedRefineryMachine: selectedRefineryMachine,
                    paValue: paValue,
                    phosporicTotalController: phosphoricTotalController,
                  ),
                ],
                const SizedBox(height: 16),

                // CheckBox to activate the bahan penolong card
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
                  // === Section: Utillity Usage ===
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
                              Text(
                                selectedShiftBleaching ?? currentShift,
                                style: TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          // Row(children: [Text("Shift: "), Text("I")]),
                          CustomTextField(
                            controller: totalOilController,
                            label: 'Total',
                            icon: Icons.functions,
                            isNumeric: true,
                            isRequired: true,
                          ),
                          CustomTextField(
                            controller: totalSteamController,
                            label: 'Total Steam',
                            icon: Icons.functions,
                            isNumeric: true,
                            isRequired: true,
                          ),
                          CustomTextField(
                            controller: steamOilTypeController,
                            label: 'Steam',
                            icon: Icons.functions,
                            isNumeric: true,
                            isRequired: true,
                          ),
                          CustomTextField(
                            controller: yieldPercentController,
                            label: 'Yield %',
                            icon: Icons.functions,
                            isNumeric: true,
                            isRequired: true,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 16),

                // === Section: Remark ===
                SectionCard(
                  title: 'Remark',
                  children: [CustomRemarkField(controller: remarksController)],
                ),
                const SizedBox(height: 12),

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

                const SizedBox(height: 12),
                // === Submit Button ===
                CustomSaveButton(
                  onPressed: () {
                    showSaveConfirmationDialog(
                      context,
                      onConfirm: () async {
                        await submitReport(context);
                      },
                    );
                  },
                  label: 'Submit Draft Laporan',
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitReport(BuildContext context) async {
    final provider = context.read<DailyProductionRefineryProvider>();
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
        .read<DailyProductionRefineryProvider>()
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
          .read<DailyProductionRefineryProvider>()
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

    void showSnackBar(String message) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    }

    if (!context.mounted) return;

    try {
      final dataForm = widget.dataForm;
      String existingId = widget.listReport[0].id;

      final entities =
          inputItems.asMap().entries.map((entry) {
            int index = entry.key;
            RefineryInputItem item = entry.value;

            int ticketNo;

            if (item.id != null) {
              ticketNo = item.existingNo ?? (index + 1);
            } else {
              ticketNo = index + 1;
            }

            return DailyProductionRefineryEntity(
              id: existingId,
              ticketId: item.ticketId,
              company: companyName,
              plant: currentPlant.code,
              transactionDate: getTransactionDate(),
              postingDate: getPostingDate(),
              workCenter: selectedRefineryMachine,
              shift: selectedShift,
              no: index + 1,
              cpoTank: item.selectedTankRm,
              oilTypeRmId: item.selectedOilRm,
              oilTypeRmAwalJam: item.timeAwalRm,
              oilTypeRmAwalFlowmeter: parseDouble(item.flowAwalRm),
              oilTypeRmAkhirJam: item.timeAkhirRm,
              oilTypeRmAkhirFlowmeter: parseDouble(item.flowAkhirRm),
              oilTypeRmTotal: parseDouble(item.flowTotalRm),
              oilTypeRmOip: parseDouble(item.oipRm),

              oilTypeFgId: item.selectedOilFg,
              oilTypeFgAwalJam: item.timeAwalFg,
              oilTypeFgAwalFlowmeter: parseDouble(item.flowAwalFg),
              oilTypeFgAkhirJam: item.timeAkhirFg,
              oilTypeFgAkhirFlowmeter: parseDouble(item.flowAkhirFg),
              oilTypeFgTotal: parseDouble(item.flowTotalFg),
              oilTypeFgToTank: item.selectedTankFg,

              oilTypeBpId: item.selectedOilBp,
              bpAwalJam: item.timeAwalBp,
              bpAwalFlowmeter: parseDouble(item.flowAwalBp),
              bpAkhirJam: item.timeAkhirBp,
              bpAkhirFlowmeter: parseDouble(item.flowAkhirBp),
              bpTotal: parseDouble(item.flowTotalBp),
              bpToTank: item.selectedTankBp,

              // Bleaching Earth - Mapped to Global State Controllers
              beRefTank: selectedRefineryMachine,
              beRefQty:
                  "1 Bag (1000 Kg)", // Not explicitly captured in UI, usually handled by Bag count
              beTotalBag: bleachingBagController.text,
              beTotalJenis: bleachingTypeController.text,
              beLotBatchNumber: parseInt(bleachingBatchController.text),
              beYieldPercent: parseDouble(bleachingYieldPercentController),

              // Phosphoric Acid - Mapped to Global State Controllers
              paRefTank: selectedRefineryMachine,
              paRefQty: paValue,
              paTotal: phosphoricTotalController.text,
              paLotBatchNumber: parseInt(phosphoricBatchController.text),
              paYieldPercent: parseDouble(phosphoricYieldController),

              remarks: remarksController.text,
              flag: 'T',

              // Utility Usage - Mapped to Global State/Values
              uuItem: steamItem,
              uuBudgetRefTank: selectedRefineryMachine,
              uuBudgetQty:
                  budgetValue != null ? double.tryParse(budgetValue!) : null,
              uuTotalCpo: parseDouble(totalOilController),
              uuTotalSteam: parseDouble(totalSteamController),
              uuSteamCpo: parseDouble(steamOilTypeController),
              uuYieldPercent: parseDouble(yieldPercentController),
              entryBy: currentUser?.username,
              entryDate: DateTime.now(),
              preparedBy: null,
              preparedDate: null,
              preparedStatus: null,
              verifiedBy: null,
              verifiedDate: null,
              verifiedStatus: null,
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

      bool? success;

      success = await provider.updateReport(
        entities,
        currentUser?.username ?? "",
        currentUser?.role ?? "",
        plantCode,
        deletedTicketId,
      );

      log("is success? $success");
      if (success) {
        // if (!mounted) return;
        context.read<DailyProductionRefineryProvider>().fetchAllTickets(
          null,
          null,
          currentUser?.username ?? "",
          currentUser?.role ?? "",
          plantCode,
        );
        showSnackBar('Update berhasil.');
        // if (!mounted) return;
        Navigator.pop(context);
      } else {
        showSnackBar('Error Input.');
      }
    } catch (e) {
      log("Gagal menyimpan laporan: $e");

      final message = e.toString().replaceFirst('Exception: ', '');
      showSnackBar("Gagal menyimpan laporan: $message");
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
