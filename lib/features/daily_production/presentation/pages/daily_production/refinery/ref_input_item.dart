import 'package:flutter/material.dart';

class RefineryInputItem {

  //  ------ Rm Section -------
  final TextEditingController flowAwalRm = TextEditingController();
  final TextEditingController flowAkhirRm = TextEditingController();
  final TextEditingController flowTotalRm = TextEditingController();
  final TextEditingController oipRm = TextEditingController();
  String? selectedTankRm;
  String? selectedOilRm;
  TimeOfDay? timeAwalRm;
  TimeOfDay? timeAkhirRm;
  bool? showRM;
  bool? isUseLastTankRm = false;

  // ---- Finish good section ----
  final TextEditingController flowAwalFg = TextEditingController();
  final TextEditingController flowAkhirFg = TextEditingController();
  final TextEditingController flowTotalFg = TextEditingController();
  String? selectedTankFg;
  String? selectedOilFg;
  TimeOfDay? timeAwalFg;
  TimeOfDay? timeAkhirFg;
  bool? showFG;

  // ---- By Product section ----
  final TextEditingController flowAwalBp = TextEditingController();
  final TextEditingController flowAkhirBp = TextEditingController();
  final TextEditingController flowTotalBp = TextEditingController();
  String? selectedTankBp;
  String? selectedOilBp;
  TimeOfDay? timeAwalBp;
  TimeOfDay? timeAkhirBp;
  bool? showBP;

  String? id;
  int? existingNo;
  int? ticketId;

  RefineryInputItem({
    this.showRM = true,
    this.showFG = true,
    this.showBP = true,
  }) {
    // Pasang Listener otomatis untuk hitung Flowmeter Total
    _setupListener(flowAwalRm, flowAkhirRm, flowTotalRm);
    _setupListener(flowAwalFg, flowAkhirFg, flowTotalFg);
    _setupListener(flowAwalBp, flowAkhirBp, flowTotalBp, isDecimal: true);
  }

  void _setupListener(
    TextEditingController awal,
    TextEditingController akhir,
    TextEditingController total, {
    bool isDecimal = false,
  }) {
    void calculate() {
      if (awal.text.isNotEmpty && akhir.text.isNotEmpty) {
        if (isDecimal) {
          double? vAwal = double.tryParse(awal.text);
          double? vAkhir = double.tryParse(akhir.text);
          if (vAwal != null && vAkhir != null) {
            total.text = (vAkhir - vAwal).toStringAsFixed(4);
          }
        } else {
          int? vAwal = int.tryParse(awal.text);
          int? vAkhir = int.tryParse(akhir.text);
          if (vAwal != null && vAkhir != null) {
            total.text = (vAkhir - vAwal).toString();
          }
        }
      }
    }

    awal.addListener(calculate);
    akhir.addListener(calculate);
  }

  // Wajib dispose semua controller untuk mencegah memory leak
  void dispose() {
    flowAwalRm.dispose();
    flowAkhirRm.dispose();
    flowTotalRm.dispose();

    flowAwalFg.dispose();
    flowAkhirFg.dispose();
    flowTotalFg.dispose();

    flowAwalBp.dispose();
    flowAkhirBp.dispose();
    flowTotalBp.dispose();
  }
}
