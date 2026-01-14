import 'package:flutter/material.dart';
import 'package:logsheet_app/core/utils/parser_utils.dart';

class DryFractionationEntity {
  final String id;
  final String? company;
  final String? plant;
  final DateTime? date;
  final DateTime? postingDate;
  final String? crystallizer;
  final double? feedOilIv;
  final double? fillingStartTime;
  final double? fillingEndTime;
  final double? initalOilLevel;
  final double? coolingStartTime;
  final double? coolingEndTime;
  final double? agitatorSpeed;
  final double? waterPumpPres;

  final String? remarks;
  final String? flag;
  final String? entryBy;
  final DateTime? entryDate;

  String? preparedBy;
  DateTime? preparedDate;
  String? preparedStatus;
  String? preparedStatusRemarks;

  String? checkedBy;
  DateTime? checkedDate;
  String? checkedStatus;
  String? checkedStatusRemarks;

  String? updatedBy;
  DateTime? updatedDate;

  final String? formNo;
  final DateTime? dateIssued;
  final int? revisionNo;
  final DateTime? revisionDate;

  DryFractionationEntity({
    required this.id,
    required this.company,
    required this.plant,
    required this.date,
    required this.postingDate,
    required this.crystallizer,
    required this.feedOilIv,
    required this.fillingStartTime,
    required this.fillingEndTime,
    required this.initalOilLevel,
    required this.coolingStartTime,
    required this.coolingEndTime,
    required this.agitatorSpeed,
    required this.waterPumpPres,
    required this.remarks,
    required this.flag,
    required this.entryBy,
    required this.entryDate,
    required this.formNo,
    required this.dateIssued,
    required this.revisionNo,
    required this.revisionDate,
  });
}
