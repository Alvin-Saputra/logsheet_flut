import 'package:flutter/material.dart';

class DailyProductionRefineryEntity {
  // Primary Key (Auto Increment dari Database)
  final int? ticketId;

  // Grouping Key (Satu tiket bisa memiliki banyak baris dengan ID ini yang sama)
  final String id;

  // General Information
  final String? company;
  final String? plant;
  final DateTime? transactionDate;
  final DateTime? postingDate;
  final String? workCenter;
  final String? shift;
  final int? no;
  final String? cpoTank;

  // Raw Material (RM)
  final String? oilTypeRmId;
  final String? oilTypeRm;
  final TimeOfDay? oilTypeRmAwalJam;
  final double? oilTypeRmAwalFlowmeter;
  final TimeOfDay? oilTypeRmAkhirJam;
  final double? oilTypeRmAkhirFlowmeter;
  final double? oilTypeRmOip;
  final double? oilTypeRmTotal;

  // Finished Goods (FG)
  final String? oilTypeFgId;
  final String? oilTypeFg;
  final TimeOfDay? oilTypeFgAwalJam;
  final double? oilTypeFgAwalFlowmeter;
  final TimeOfDay? oilTypeFgAkhirJam;
  final double? oilTypeFgAkhirFlowmeter;
  final double? oilTypeFgTotal;
  final String? oilTypeFgToTank;

  // By Product (BP) / PFAD
  final String? oilTypeBpId;
  final String? oilTypeBp;
  final TimeOfDay? bpAwalJam;
  final double? bpAwalFlowmeter;
  final TimeOfDay? bpAkhirJam;
  final double? bpAkhirFlowmeter;
  final double? bpTotal;
  final String? bpToTank;

  // Bleaching Earth (BE)
  final String? beRefTank;
  final String? beRefQty;
  final String? beTotalBag;
  final String? beTotalJenis;
  final int? beLotBatchNumber;
  final double? beYieldPercent;

  // Phosphoric Acid (PA)
  final String? paRefTank;
  final String? paRefQty;
  final String? paTotal;
  final int? paLotBatchNumber;
  final double? paYieldPercent;

  // Remarks & Flag
  final String? remarks;
  final String? flag;

  // Utility Usage (UU)
  final String? uuItem;
  final String? uuBudgetRefTank;
  final double? uuBudgetQty;
  final double? uuTotalCpo;
  final double? uuTotalSteam;
  final double? uuSteamCpo;
  final double? uuYieldPercent;

  // Approval & Tracking
  String? entryBy;
  DateTime? entryDate;
  String? preparedBy;
  DateTime? preparedDate;
  String? preparedStatus;
  String? preparedStatusRemarks;
  String? verifiedBy;
  DateTime? verifiedDate;
  String? verifiedStatus;
  String? checkedBy;
  DateTime? checkedDate;
  String? checkedStatus;
  String? checkedStatusRemarks;

  // Form Information
  final String? formNo;
  final DateTime? dateIssued;
  final int? revisionNo;
  final DateTime? revisionDate;

  bool? isCompleted;

  DailyProductionRefineryEntity({
    this.ticketId,
    required this.id,
    this.company,
    this.plant,
    this.transactionDate,
    this.postingDate,
    this.workCenter,
    this.shift,
    this.no,
    this.cpoTank,
    this.oilTypeRmId,
    this.oilTypeRm,
    this.oilTypeRmAwalJam,
    this.oilTypeRmAwalFlowmeter,
    this.oilTypeRmAkhirJam,
    this.oilTypeRmAkhirFlowmeter,
    this.oilTypeRmTotal,
    this.oilTypeRmOip,
    this.oilTypeFgId,
    this.oilTypeFg,
    this.oilTypeFgAwalJam,
    this.oilTypeFgAwalFlowmeter,
    this.oilTypeFgAkhirJam,
    this.oilTypeFgAkhirFlowmeter,
    this.oilTypeFgTotal,
    this.oilTypeFgToTank,
    this.oilTypeBpId,
    this.oilTypeBp,
    this.bpAwalJam,
    this.bpAwalFlowmeter,
    this.bpAkhirJam,
    this.bpAkhirFlowmeter,
    this.bpTotal,
    this.bpToTank,
    this.beRefTank,
    this.beRefQty,
    this.beTotalBag,
    this.beTotalJenis,
    this.beLotBatchNumber,
    this.beYieldPercent,
    this.paRefTank,
    this.paRefQty,
    this.paTotal,
    this.paLotBatchNumber,
    this.paYieldPercent,
    this.remarks,
    this.flag,
    this.uuItem,
    this.uuBudgetRefTank,
    this.uuBudgetQty,
    this.uuTotalCpo,
    this.uuTotalSteam,
    this.uuSteamCpo,
    this.uuYieldPercent,
    this.entryBy,
    this.entryDate,
    this.preparedBy,
    this.preparedDate,
    this.preparedStatus,
    this.preparedStatusRemarks,
    this.verifiedBy,
    this.verifiedDate,
    this.verifiedStatus,
    this.checkedBy,
    this.checkedDate,
    this.checkedStatus,
    this.checkedStatusRemarks,
    this.formNo,
    this.dateIssued,
    this.revisionNo,
    this.revisionDate,
    this.isCompleted,
  });

  factory DailyProductionRefineryEntity.fromMap(Map<String, dynamic> map) {
    int? parseInt(dynamic value) {
      if (value == null) return null;
      if (value is int) return value;
      if (value is double) return value.toInt();
      if (value is String) return int.tryParse(value);
      return null;
    }

    DateTime? parseDateTime(dynamic value) {
      if (value is String) return DateTime.tryParse(value);
      if (value is DateTime) return value;
      return null;
    }

    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value);
      return null;
    }

    TimeOfDay? parseTimeOfDay(dynamic value) {
      if (value == null) return null;
      if (value is String && value.isNotEmpty) {
        final parts = value.split(':');
        final hour = int.tryParse(parts[0]);
        final minute = int.tryParse(parts[1]);
        if (hour != null && minute != null) {
          return TimeOfDay(hour: hour, minute: minute);
        }
      }
      return null;
    }

    bool? parseBool(dynamic value) {
      if (value == null) return null;
      if (value is bool) return value;
      if (value is int) return value == 1;
      if (value is String) return value == '1' || value.toLowerCase() == 'true';
      return null;
    }

    return DailyProductionRefineryEntity(
      ticketId: parseInt(map['ticket_id']), // Primary Key Baru
      id: map['id'] as String, // Grouping Key
      company: map['company'] as String?,
      plant: map['plant'] as String?,
      transactionDate: parseDateTime(map['transaction_date']),
      postingDate: parseDateTime(map['posting_date']),
      workCenter: map['work_center'] as String?,
      shift: map['shift'] as String?,
      no: parseInt(map['no']),
      cpoTank: map['cpo_tank'] as String?,
      oilTypeRmId: map['oil_type_rm_id'] as String?,
      oilTypeRm: map['oil_type_rm'] as String?,
      oilTypeRmAwalJam: parseTimeOfDay(map['oil_type_rm_awal_jam']),
      oilTypeRmAwalFlowmeter: parseDouble(map['oil_type_rm_awal_flowmeter']),
      oilTypeRmAkhirJam: parseTimeOfDay(map['oil_type_rm_akhir_jam']),
      oilTypeRmAkhirFlowmeter: parseDouble(map['oil_type_rm_akhir_flowmeter']),
      oilTypeRmOip: parseDouble(map['oil_type_rm_oip']),
      oilTypeRmTotal: parseDouble(map['oil_type_rm_total']),
      oilTypeFgId: map['oil_type_fg_id'] as String?,
      oilTypeFg: map['oil_type_fg'] as String?,
      oilTypeFgAwalJam: parseTimeOfDay(map['oil_type_fg_awal_jam']),
      oilTypeFgAwalFlowmeter: parseDouble(map['oil_type_fg_awal_flowmeter']),
      oilTypeFgAkhirJam: parseTimeOfDay(map['oil_type_fg_akhir_jam']),
      oilTypeFgAkhirFlowmeter: parseDouble(map['oil_type_fg_akhir_flowmeter']),
      oilTypeFgTotal: parseDouble(map['oil_type_fg_total']),
      oilTypeFgToTank: map['oil_type_fg_to_tank'] as String?,
      bpAwalJam: parseTimeOfDay(map['bp_awal_jam']),
      bpAwalFlowmeter: parseDouble(map['bp_awal_flowmeter']),
      bpAkhirJam: parseTimeOfDay(map['bp_akhir_jam']),
      bpAkhirFlowmeter: parseDouble(map['bp_akhir_flowmeter']),
      oilTypeBpId: map['bp_oil_type_id'] as String?,
      oilTypeBp: map['bp_oil_type'] as String?,
      bpTotal: parseDouble(map['bp_total']),
      bpToTank: map['bp_to_tank'] as String?,
      beRefTank: map['be_ref_tank'] as String?,
      beRefQty: map['be_ref_qty'] as String?,
      beTotalBag: map['be_total_bag'] as String?,
      beTotalJenis: map['be_total_jenis'] as String?,
      beLotBatchNumber: parseInt(map['be_lot_batch_number']),
      beYieldPercent: parseDouble(map['be_yield_percent']),
      paRefTank: map['pa_ref_tank'] as String?,
      paRefQty: map['pa_ref_qty'] as String?,
      paTotal: map['pa_total'] as String?,
      paLotBatchNumber: parseInt(map['pa_lot_batch_number']),
      paYieldPercent: parseDouble(map['pa_yield_percent']),
      remarks: map['remarks'] as String?,
      flag: map['flag'] as String?,
      uuItem: map['uu_item'] as String?,
      uuBudgetRefTank: map['uu_budget_ref_tank'] as String?,
      uuBudgetQty: parseDouble(map['uu_budget_qty']),
      uuTotalCpo: parseDouble(map['uu_total_cpo']),
      uuTotalSteam: parseDouble(map['uu_total_steam']),
      uuSteamCpo: parseDouble(map['uu_steam_cpo']),
      uuYieldPercent: parseDouble(map['uu_yield_percent']),
      entryBy: map['entry_by'] as String?,
      entryDate: parseDateTime(map['entry_date']),
      preparedBy: map['prepared_by'] as String?,
      preparedDate: parseDateTime(map['prepared_date']),
      preparedStatus: map['prepared_status'] as String?,
      verifiedBy: map['verified_by'] as String?,
      verifiedDate: parseDateTime(map['verified_date']),
      verifiedStatus: map['verified_status'] as String?,
      checkedBy: map['checked_by'] as String?,
      checkedDate: parseDateTime(map['checked_date']),
      checkedStatus: map['checked_status'] as String?,
      formNo: map['form_no'] as String?,
      dateIssued: parseDateTime(map['date_issued']),
      revisionNo: parseInt(map['revision_no']),
      revisionDate: parseDateTime(map['revision_date']),
      checkedStatusRemarks: map['checked_status_remarks'] as String?,
      preparedStatusRemarks: map['prepared_status_remarks'] as String?,
      isCompleted: parseBool(map['is_completed']),
    );
  }

  Map<String, dynamic> toMap() {
    String? formatTimeOfDay(TimeOfDay? time) {
      if (time == null) return null;
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute:00';
    }

    return {
      // 'ticket_id': ticketId, // Tidak perlu disertakan saat insert karena auto increment
      'id': id, // Grouping Key
      'company': company,
      'plant': plant,
      'transaction_date': transactionDate?.toIso8601String(),
      'posting_date': postingDate?.toIso8601String(),
      'work_center': workCenter,
      'shift': shift,
      'no': no,
      'cpo_tank': cpoTank,
      'oil_type_rm': oilTypeRmId,
      'oil_type_rm_awal_jam': formatTimeOfDay(oilTypeRmAwalJam),
      'oil_type_rm_awal_flowmeter': oilTypeRmAwalFlowmeter,
      'oil_type_rm_akhir_jam': formatTimeOfDay(oilTypeRmAkhirJam),
      'oil_type_rm_akhir_flowmeter': oilTypeRmAkhirFlowmeter,
      'oil_type_rm_oip': oilTypeRmOip,
      'oil_type_rm_total': oilTypeRmTotal,
      'oil_type_fg': oilTypeFgId,
      'oil_type_fg_awal_jam': formatTimeOfDay(oilTypeFgAwalJam),
      'oil_type_fg_awal_flowmeter': oilTypeFgAwalFlowmeter,
      'oil_type_fg_akhir_jam': formatTimeOfDay(oilTypeFgAkhirJam),
      'oil_type_fg_akhir_flowmeter': oilTypeFgAkhirFlowmeter,
      'oil_type_fg_total': oilTypeFgTotal,
      'oil_type_fg_to_tank': oilTypeFgToTank,
      'bp_awal_jam': formatTimeOfDay(bpAwalJam),
      'bp_awal_flowmeter': bpAwalFlowmeter,
      'bp_akhir_jam': formatTimeOfDay(bpAkhirJam),
      'bp_akhir_flowmeter': bpAkhirFlowmeter,
      'bp_oil_type': oilTypeBpId,
      'bp_total': bpTotal,
      'bp_to_tank': bpToTank,
      'be_ref_tank': beRefTank,
      'be_ref_qty': beRefQty,
      'be_total_bag': beTotalBag,
      'be_total_jenis': beTotalJenis,
      'be_lot_batch_number': beLotBatchNumber,
      'be_yield_percent': beYieldPercent,
      'pa_ref_tank': paRefTank,
      'pa_ref_qty': paRefQty,
      'pa_total': paTotal,
      'pa_lot_batch_number': paLotBatchNumber,
      'pa_yield_percent': paYieldPercent,
      'remarks': remarks,
      'flag': flag,
      'uu_item': uuItem,
      'uu_budget_ref_tank': uuBudgetRefTank,
      'uu_budget_qty': uuBudgetQty,
      'uu_total_cpo': uuTotalCpo,
      'uu_total_steam': uuTotalSteam,
      'uu_steam_cpo': uuSteamCpo,
      'uu_yield_percent': uuYieldPercent,
      'entry_by': entryBy,
      'entry_date': entryDate?.toIso8601String(),
      'prepared_by': preparedBy,
      'prepared_date': preparedDate?.toIso8601String(),
      'prepared_status': preparedStatus,
      'verified_by': verifiedBy,
      'verified_date': verifiedDate?.toIso8601String(),
      'verified_status': verifiedStatus,
      'checked_by': checkedBy,
      'checked_date': checkedDate?.toIso8601String(),
      'checked_status': checkedStatus,
      'form_no': formNo,
      'date_issued': dateIssued?.toIso8601String(),
      'revision_no': revisionNo,
      'revision_date': revisionDate?.toIso8601String(),
      'is_completed': isCompleted == null ? null : (isCompleted! ? 1 : 0),
    };
  }

  DailyProductionRefineryEntity copyWith({
    int? ticketId,
    String? id,
    String? company,
    String? plant,
    DateTime? transactionDate,
    DateTime? postingDate,
    String? workCenter,
    String? shift,
    int? no,
    String? cpoTank,
    String? oilTypeRmId,
    String? oilTypeRm,
    TimeOfDay? oilTypeRmAwalJam,
    double? oilTypeRmAwalFlowmeter,
    TimeOfDay? oilTypeRmAkhirJam,
    double? oilTypeRmAkhirFlowmeter,
    double? oilTypeRmOip,
    double? oilTypeRmTotal,
    String? oilTypeFgId,
    String? oilTypeFg,
    TimeOfDay? oilTypeFgAwalJam,
    double? oilTypeFgAwalFlowmeter,
    TimeOfDay? oilTypeFgAkhirJam,
    double? oilTypeFgAkhirFlowmeter,
    double? oilTypeFgTotal,
    String? oilTypeFgToTank,
    String? oilTypeBpId,
    String? oilTypeBp,
    TimeOfDay? bpAwalJam,
    double? bpAwalFlowmeter,
    TimeOfDay? bpAkhirJam,
    double? bpAkhirFlowmeter,
    double? bpTotal,
    String? bpToTank,
    String? beRefTank,
    String? beRefQty,
    String? beTotalBag,
    String? beTotalJenis,
    int? beLotBatchNumber,
    double? beYieldPercent,
    String? paRefTank,
    String? paRefQty,
    String? paTotal,
    int? paLotBatchNumber,
    double? paYieldPercent,
    String? remarks,
    String? flag,
    String? uuItem,
    String? uuBudgetRefTank,
    double? uuBudgetQty,
    double? uuTotalCpo,
    double? uuTotalSteam,
    double? uuSteamCpo,
    double? uuYieldPercent,
    String? entryBy,
    DateTime? entryDate,
    String? preparedBy,
    DateTime? preparedDate,
    String? preparedStatus,
    String? verifiedBy,
    DateTime? verifiedDate,
    String? verifiedStatus,
    String? checkedBy,
    DateTime? checkedDate,
    String? checkedStatus,
    String? checkedStatusRemarks,
    String? formNo,
    DateTime? dateIssued,
    int? revisionNo,
    DateTime? revisionDate,
    bool? isCompleted,
  }) {
    return DailyProductionRefineryEntity(
      ticketId: ticketId ?? this.ticketId,
      id: id ?? this.id,
      company: company ?? this.company,
      plant: plant ?? this.plant,
      transactionDate: transactionDate ?? this.transactionDate,
      postingDate: postingDate ?? this.postingDate,
      workCenter: workCenter ?? this.workCenter,
      shift: shift ?? this.shift,
      no: no ?? this.no,
      cpoTank: cpoTank ?? this.cpoTank,
      oilTypeRmId: oilTypeRmId ?? this.oilTypeRmId,
      oilTypeRm: oilTypeRm ?? this.oilTypeRm,
      oilTypeRmAwalJam: oilTypeRmAwalJam ?? this.oilTypeRmAwalJam,
      oilTypeRmAwalFlowmeter: oilTypeRmAwalFlowmeter ?? this.oilTypeRmAwalFlowmeter,
      oilTypeRmAkhirJam: oilTypeRmAkhirJam ?? this.oilTypeRmAkhirJam,
      oilTypeRmAkhirFlowmeter: oilTypeRmAkhirFlowmeter ?? this.oilTypeRmAkhirFlowmeter,
      oilTypeRmOip: oilTypeRmOip ?? this.oilTypeRmOip,
      oilTypeRmTotal: oilTypeRmTotal ?? this.oilTypeRmTotal,
      oilTypeFgId: oilTypeFgId ?? this.oilTypeFgId,
      oilTypeFg: oilTypeFg ?? this.oilTypeFg,
      oilTypeFgAwalJam: oilTypeFgAwalJam ?? this.oilTypeFgAwalJam,
      oilTypeFgAwalFlowmeter: oilTypeFgAwalFlowmeter ?? this.oilTypeFgAwalFlowmeter,
      oilTypeFgAkhirJam: oilTypeFgAkhirJam ?? this.oilTypeFgAkhirJam,
      oilTypeFgAkhirFlowmeter: oilTypeFgAkhirFlowmeter ?? this.oilTypeFgAkhirFlowmeter,
      oilTypeFgTotal: oilTypeFgTotal ?? this.oilTypeFgTotal,
      oilTypeFgToTank: oilTypeFgToTank ?? this.oilTypeFgToTank,
      oilTypeBpId: oilTypeBpId ?? this.oilTypeBpId,
      oilTypeBp: oilTypeBp ?? this.oilTypeBp,
      bpAwalJam: bpAwalJam ?? this.bpAwalJam,
      bpAwalFlowmeter: bpAwalFlowmeter ?? this.bpAwalFlowmeter,
      bpAkhirJam: bpAkhirJam ?? this.bpAkhirJam,
      bpAkhirFlowmeter: bpAkhirFlowmeter ?? this.bpAkhirFlowmeter,
      bpTotal: bpTotal ?? this.bpTotal,
      bpToTank: bpToTank ?? this.bpToTank,
      beRefTank: beRefTank ?? this.beRefTank,
      beRefQty: beRefQty ?? this.beRefQty,
      beTotalBag: beTotalBag ?? this.beTotalBag,
      beTotalJenis: beTotalJenis ?? this.beTotalJenis,
      beLotBatchNumber: beLotBatchNumber ?? this.beLotBatchNumber,
      beYieldPercent: beYieldPercent ?? this.beYieldPercent,
      paRefTank: paRefTank ?? this.paRefTank,
      paRefQty: paRefQty ?? this.paRefQty,
      paTotal: paTotal ?? this.paTotal,
      paLotBatchNumber: paLotBatchNumber ?? this.paLotBatchNumber,
      paYieldPercent: paYieldPercent ?? this.paYieldPercent,
      remarks: remarks ?? this.remarks,
      flag: flag ?? this.flag,
      uuItem: uuItem ?? this.uuItem,
      uuBudgetRefTank: uuBudgetRefTank ?? this.uuBudgetRefTank,
      uuBudgetQty: uuBudgetQty ?? this.uuBudgetQty,
      uuTotalCpo: uuTotalCpo ?? this.uuTotalCpo,
      uuTotalSteam: uuTotalSteam ?? this.uuTotalSteam,
      uuSteamCpo: uuSteamCpo ?? this.uuSteamCpo,
      uuYieldPercent: uuYieldPercent ?? this.uuYieldPercent,
      entryBy: entryBy ?? this.entryBy,
      entryDate: entryDate ?? this.entryDate,
      preparedBy: preparedBy ?? this.preparedBy,
      preparedDate: preparedDate ?? this.preparedDate,
      preparedStatus: preparedStatus ?? this.preparedStatus,
      verifiedBy: verifiedBy ?? this.verifiedBy,
      verifiedDate: verifiedDate ?? this.verifiedDate,
      verifiedStatus: verifiedStatus ?? this.verifiedStatus,
      checkedBy: checkedBy ?? this.checkedBy,
      checkedDate: checkedDate ?? this.checkedDate,
      checkedStatus: checkedStatus ?? this.checkedStatus,
      checkedStatusRemarks: checkedStatusRemarks ?? this.checkedStatusRemarks,
      formNo: formNo ?? this.formNo,
      dateIssued: dateIssued ?? this.dateIssued,
      revisionNo: revisionNo ?? this.revisionNo,
      revisionDate: revisionDate ?? this.revisionDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}