import 'package:flutter/material.dart';

class DailyProductionFractionationEntity {
  // General Information
  final int? ticketId;
  final String id;
  final String? company;
  final String? plant;
  final DateTime? transactionDate;
  final DateTime? postingDate;
  final String? workCenter;
  final String? shift;
  final int? no;

  final String? oilTypeRmId;
  final String? oilTypeRmName;
  final String? oilTypeRmCr;
  final String? oilTypeRmFromTank;
  final TimeOfDay? oilTypeRmAwalJam;
  final int? oilTypeRmAwalFlowmeter;
  final TimeOfDay? oilTypeRmAkhirJam;
  final int? oilTypeRmAkhirFlowmeter;
  final double? oilTypeRmTotal;

  final String? oilTypeFgsId;
  final String? oilTypeFgsName;
  final String? oilTypeFgsCr;
  final TimeOfDay? oilTypeFgsAwalJam;
  final int? oilTypeFgsAwalFlowmeter;
  final TimeOfDay? oilTypeFgsAkhirJam;
  final int? oilTypeFgsAkhirFlowmeter;
  final double? oilTypeFgsTotal;
  final String? oilTypeFgsToTank;

  final String? oilTypeFghId;
  final String? oilTypeFghName;
  final TimeOfDay? oilTypeFghAwalJam;
  final double? oilTypeFghAwalFlowmeter;
  final TimeOfDay? oilTypeFghAkhirJam;
  final double? oilTypeFghAkhirFlowmeter;
  final double? oilTypeFghTotal;
  final String? oilTypeFghToTank;

  // Remarks & Flag
  final String? remarks;
  final String? flag;

  // Utility Usage
  final String? uuItem;
  final String? uuBudgetRefQty;
  final int? uuFlowmeterBefore;
  final int? uuFlowmeterAfter;
  final int? uuFlowmeterTotal;
  final double? uuYieldPercent;
  final int? uuListrik;
  final int? uuAir;

  // Signatures & Status
  String? entryBy;
  DateTime? entryDate;
  String? preparedBy;
  DateTime? preparedDate;
  String? preparedStatus;
  String? preparedStatusRemarks;
  String? verifiedBy;
  DateTime? verifiedDate;
  String? verifiedStatus;
  String? verifiedStatusRemarks;
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

  DailyProductionFractionationEntity({
    this.ticketId,
    required this.id,
    required this.company,
    required this.plant,
    required this.transactionDate,
    required this.postingDate,
    required this.workCenter,
    required this.shift,
    required this.no,
    required this.oilTypeRmId,
    this.oilTypeRmName,
    required this.oilTypeRmCr,
    required this.oilTypeRmFromTank,
    required this.oilTypeRmAwalJam,
    required this.oilTypeRmAwalFlowmeter,
    required this.oilTypeRmAkhirJam,
    required this.oilTypeRmAkhirFlowmeter,
    required this.oilTypeRmTotal,

    required this.oilTypeFgsId,
    this.oilTypeFgsName,
    required this.oilTypeFgsCr,
    required this.oilTypeFgsAwalJam,
    required this.oilTypeFgsAwalFlowmeter,
    required this.oilTypeFgsAkhirJam,
    required this.oilTypeFgsAkhirFlowmeter,
    required this.oilTypeFgsTotal,
    required this.oilTypeFgsToTank,

    required this.oilTypeFghId,
    this.oilTypeFghName,
    required this.oilTypeFghAwalJam,
    required this.oilTypeFghAwalFlowmeter,
    required this.oilTypeFghAkhirJam,
    required this.oilTypeFghAkhirFlowmeter,
    required this.oilTypeFghTotal,
    required this.oilTypeFghToTank,
    required this.remarks,
    required this.flag,
    required this.uuItem,
    required this.uuBudgetRefQty,
    required this.uuFlowmeterBefore,
    required this.uuFlowmeterAfter,
    required this.uuFlowmeterTotal,
    required this.uuYieldPercent,
    required this.uuListrik,
    required this.uuAir,
    required this.entryBy,
    required this.entryDate,
    required this.preparedBy,
    required this.preparedDate,
    required this.preparedStatus,
    required this.preparedStatusRemarks,
    required this.verifiedBy,
    required this.verifiedDate,
    required this.verifiedStatus,
    required this.verifiedStatusRemarks,
    required this.checkedBy,
    required this.checkedDate,
    required this.checkedStatus,
    required this.checkedStatusRemarks,
    required this.formNo,
    required this.dateIssued,
    required this.revisionNo,
    required this.revisionDate,
    required this.isCompleted,
  });

  factory DailyProductionFractionationEntity.fromMap(Map<String, dynamic> map) {
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

    return DailyProductionFractionationEntity(
      ticketId: parseInt(map['ticket_id']),
      id: map['id'] as String,
      company: map['company'] as String?,
      plant: map['plant'] as String?,
      transactionDate: parseDateTime(map['transaction_date']),
      postingDate: parseDateTime(map['posting_date']),
      workCenter: map['work_center'] as String?,
      shift: map['shift'] as String?,
      no: parseInt(map['no']),
      oilTypeRmId: map['oil_type_rm'] as String?,
      oilTypeRmName: map['oil_type_rm_name'] as String?,
      oilTypeRmCr: map['oil_type_rm_cr'] as String?,
      oilTypeRmFromTank: map['oil_type_rm_from_tank'] as String?,
      oilTypeRmAwalJam: parseTimeOfDay(map['oil_type_rm_awal_jam']),
      oilTypeRmAwalFlowmeter: parseInt(map['oil_type_rm_awal_flowmeter']),
      oilTypeRmAkhirJam: parseTimeOfDay(map['oil_type_rm_akhir_jam']),
      oilTypeRmAkhirFlowmeter: parseInt(map['oil_type_rm_akhir_flowmeter']),
      oilTypeRmTotal: parseDouble(map['oil_type_rm_total']),
      oilTypeFgsId: map['oil_type_fgs'] as String?,
      oilTypeFgsName: map['oil_type_fgs_name'] as String?,
      oilTypeFgsCr: map['oil_type_fgs_cr'] as String?,
      oilTypeFgsAwalJam: parseTimeOfDay(map['oil_type_fgs_awal_jam']),
      oilTypeFgsAwalFlowmeter: parseInt(map['oil_type_fgs_awal_flowmeter']),
      oilTypeFgsAkhirJam: parseTimeOfDay(map['oil_type_fgs_akhir_jam']),
      oilTypeFgsAkhirFlowmeter: parseInt(map['oil_type_fgs_akhir_flowmeter']),
      oilTypeFgsTotal: parseDouble(map['oil_type_fgs_total']),
      oilTypeFgsToTank: map['oil_type_fgs_to_tank'] as String?,
      oilTypeFghId: map['oil_type_fgh'] as String?,
      oilTypeFghName: map['oil_type_fgh_name'] as String?,
      oilTypeFghAwalJam: parseTimeOfDay(map['oil_type_fgh_awal_jam']),
      oilTypeFghAwalFlowmeter: parseDouble(map['oil_type_fgh_awal_flowmeter']),
      oilTypeFghAkhirJam: parseTimeOfDay(map['oil_type_fgh_akhir_jam']),
      oilTypeFghAkhirFlowmeter: parseDouble(
        map['oil_type_fgh_akhir_flowmeter'],
      ),
      oilTypeFghTotal: parseDouble(map['oil_type_fgh_total']),
      oilTypeFghToTank: map['oil_type_fgh_to_tank'] as String?,
      remarks: map['remarks'] as String?,
      flag: map['flag'] as String?,
      uuItem: map['uu_item'] as String?,
      uuBudgetRefQty: map['uu_budget_ref_qty'] as String?,
      uuFlowmeterBefore: parseInt(map['uu_flowmeter_before']),
      uuFlowmeterAfter: parseInt(map['uu_flowmeter_after']),
      uuFlowmeterTotal: parseInt(map['uu_flowmeter_total']),
      uuYieldPercent: parseDouble(map['uu_yield_percent']),
      uuListrik: parseInt(map['uu_listrik']),
      uuAir: parseInt(map['uu_air']),
      entryBy: map['entry_by'] as String?,
      entryDate: parseDateTime(map['entry_date']),
      preparedBy: map['prepared_by'] as String?,
      preparedDate: parseDateTime(map['prepared_date']),
      preparedStatus: map['prepared_status'] as String?,
      preparedStatusRemarks: map['prepared_status_remarks'] as String?,
      verifiedBy: map['verified_by'] as String?,
      verifiedDate: parseDateTime(map['verified_date']),
      verifiedStatus: map['verified_status'] as String?,
      verifiedStatusRemarks: map['verified_status_remarks'] as String?,
      checkedBy: map['checked_by'] as String?,
      checkedDate: parseDateTime(map['checked_date']),
      checkedStatus: map['checked_status'] as String?,
      checkedStatusRemarks: map['checked_status_remarks'] as String?,
      formNo: map['form_no'] as String?,
      dateIssued: parseDateTime(map['date_issued']),
      revisionNo: parseInt(map['revision_no']),
      revisionDate: parseDateTime(map['revision_date']),
      isCompleted: parseBool(map['is_completed']),
    );
  }

  Map<String, dynamic> toMap() {
    String? formatTimeOfDay(TimeOfDay? time) {
      if (time == null) {
        return null;
      }
      // padLeft ensures that single-digit hours/minutes get a leading zero (e.g., 9 becomes '09')
      final hour = time.hour.toString().padLeft(2, '0');
      final minute = time.minute.toString().padLeft(2, '0');
      return '$hour:$minute:00'; // We add ':00' for seconds to match the standard TIME format
    }

    return {
      'id': id,
      'company': company,
      'plant': plant,
      'transaction_date': transactionDate?.toIso8601String(),
      'posting_date': postingDate?.toIso8601String(),
      'work_center': workCenter,
      'shift': shift,
      'no': no,
      'oil_type_rm': oilTypeRmId,
      'oil_type_rm_cr': oilTypeRmCr,
      'oil_type_rm_from_tank': oilTypeRmFromTank,
      'oil_type_rm_awal_jam': formatTimeOfDay(oilTypeRmAwalJam),
      'oil_type_rm_awal_flowmeter': oilTypeRmAwalFlowmeter,
      'oil_type_rm_akhir_jam': formatTimeOfDay(oilTypeRmAkhirJam),
      'oil_type_rm_akhir_flowmeter': oilTypeRmAkhirFlowmeter,
      'oil_type_rm_total': oilTypeRmTotal,
      'oil_type_fgs': oilTypeFgsId,
      'oil_type_fgs_cr': oilTypeFgsCr,
      'oil_type_fgs_awal_jam': formatTimeOfDay(oilTypeFgsAwalJam),
      'oil_type_fgs_awal_flowmeter': oilTypeFgsAwalFlowmeter,
      'oil_type_fgs_akhir_jam': formatTimeOfDay(oilTypeFgsAkhirJam),
      'oil_type_fgs_akhir_flowmeter': oilTypeFgsAkhirFlowmeter,
      'oil_type_fgs_total': oilTypeFgsTotal,
      'oil_type_fgs_to_tank': oilTypeFgsToTank,
      'oil_type_fgh': oilTypeFghId,
      'oil_type_fgh_awal_jam': formatTimeOfDay(oilTypeFghAwalJam),
      'oil_type_fgh_awal_flowmeter': oilTypeFghAwalFlowmeter,
      'oil_type_fgh_akhir_jam': formatTimeOfDay(oilTypeFghAkhirJam),
      'oil_type_fgh_akhir_flowmeter': oilTypeFghAkhirFlowmeter,
      'oil_type_fgh_total': oilTypeFghTotal,
      'oil_type_fgh_to_tank': oilTypeFghToTank,
      'remarks': remarks,
      'flag': flag,
      'uu_item': uuItem,
      'uu_budget_ref_qty': uuBudgetRefQty,
      'uu_flowmeter_before': uuFlowmeterBefore,
      'uu_flowmeter_after': uuFlowmeterAfter,
      'uu_flowmeter_total': uuFlowmeterTotal,
      'uu_yield_percent': uuYieldPercent,
      'uu_listrik': uuListrik,
      'uu_air': uuAir,
      'entry_by': entryBy,
      'entry_date': entryDate?.toIso8601String(),
      'prepared_by': preparedBy,
      'prepared_date': preparedDate?.toIso8601String(),
      'prepared_status': preparedStatus,
      'prepared_status_remarks': preparedStatusRemarks,
      'verified_by': verifiedBy,
      'verified_date': verifiedDate?.toIso8601String(),
      'verified_status': verifiedStatus,
      'verified_status_remarks': verifiedStatusRemarks,
      'checked_by': checkedBy,
      'checked_date': checkedDate?.toIso8601String(),
      'checked_status': checkedStatus,
      'checked_status_remarks': checkedStatusRemarks,
      'form_no': formNo,
      'date_issued': dateIssued?.toIso8601String(),
      'revision_no': revisionNo,
      'revision_date': revisionDate?.toIso8601String(),
      'is_completed': isCompleted == null ? null : (isCompleted! ? 1 : 0),
    };
  }
}
