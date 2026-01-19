import 'package:flutter/material.dart';
import 'package:logsheet_app/features/production/data/model/dry_fractionation/local/dry_fractionation_detail_entity.dart';

class DryFractionationHeaderEntity {
  final String id;
  final DateTime? date;
  final DateTime? postingDate;
  final String? company;
  final String? plant;
  final String? crystallizer;
  final double? feedOilIv;
  final TimeOfDay? fillingStartTime;
  final TimeOfDay? fillingEndTime;
  final double? initialOilLevel;
  final double? coolingStartTemp;
  final TimeOfDay? coolingStartTime;
  final int? agitatorSpeed;
  final double? waterPumpPres;
  final String? remarks;
  final String? flag;
  final String? entryBy;
  final DateTime? entryDate;
  final String? preparedBy;
  final DateTime? preparedDate;
  final String? preparedStatus;
  final String? preparedStatusRemarks;
  final String? approvedBy;
  final DateTime? approvedDate;
  final String? approvedStatus;
  final String? approvedStatusRemarks;
  final String? updatedBy;
  final DateTime? updatedDate;
  final String? formNo;
  final DateTime? dateIssued;
  final String? revisionNo;
  final DateTime? revisionDate;
  final bool? isCompleted;

  final List<DryFractionationDetailEntity> details;

  DryFractionationHeaderEntity({
    required this.id,
    required this.date,
    required this.postingDate,
    required this.company,
    required this.plant,
    required this.crystallizer,
    required this.feedOilIv,
    required this.fillingStartTime,
    required this.fillingEndTime,
    required this.initialOilLevel,
    required this.coolingStartTemp,
    required this.coolingStartTime,
    required this.agitatorSpeed,
    required this.waterPumpPres,
    required this.flag,
    required this.entryBy,
    required this.entryDate,
    required this.preparedBy,
    required this.preparedDate,
    required this.preparedStatus,
    required this.preparedStatusRemarks,
    required this.approvedBy,
    required this.approvedDate,
    required this.approvedStatus,
    required this.approvedStatusRemarks,
    required this.updatedBy,
    required this.updatedDate,
    required this.formNo,
    required this.dateIssued,
    required this.revisionNo,
    required this.revisionDate,
    required this.details,
    required this.remarks,
    required this.isCompleted,
  });


  DryFractionationHeaderEntity copyWith({
    String? id,
    DateTime? date,
    DateTime? postingDate,
    String? company,
    String? plant,
    String? crystallizer,
    double? feedOilIv,
    TimeOfDay? fillingStartTime,
    TimeOfDay? fillingEndTime,
    double? initialOilLevel,
    double? coolingStartTemp,
    TimeOfDay? coolingStartTime,
    int? agitatorSpeed,
    double? waterPumpPres,
    String? remarks,
    String? flag,
    String? entryBy,
    DateTime? entryDate,
    String? preparedBy,
    DateTime? preparedDate,
    String? preparedStatus,
    String? preparedStatusRemarks,
    String? approvedBy,
    DateTime? approvedDate,
    String? approvedStatus,
    String? approvedStatusRemarks,
    String? updatedBy,
    DateTime? updatedDate,
    String? formNo,
    DateTime? dateIssued,
    String? revisionNo,
    DateTime? revisionDate,
    bool? isCompleted,
    List<DryFractionationDetailEntity>? details,
  }) {
    return DryFractionationHeaderEntity(
      id: id ?? this.id,
      date: date ?? this.date,
      postingDate: postingDate ?? this.postingDate,
      company: company ?? this.company,
      plant: plant ?? this.plant,
      crystallizer: crystallizer ?? this.crystallizer,
      feedOilIv: feedOilIv ?? this.feedOilIv,
      fillingStartTime: fillingStartTime ?? this.fillingStartTime,
      fillingEndTime: fillingEndTime ?? this.fillingEndTime,
      initialOilLevel: initialOilLevel ?? this.initialOilLevel,
      coolingStartTemp: coolingStartTemp ?? this.coolingStartTemp,
      coolingStartTime: coolingStartTime ?? this.coolingStartTime,
      agitatorSpeed: agitatorSpeed ?? this.agitatorSpeed,
      waterPumpPres: waterPumpPres ?? this.waterPumpPres,
      remarks: remarks ?? this.remarks,
      flag: flag ?? this.flag,
      entryBy: entryBy ?? this.entryBy,
      entryDate: entryDate ?? this.entryDate,
      preparedBy: preparedBy ?? this.preparedBy,
      preparedDate: preparedDate ?? this.preparedDate,
      preparedStatus: preparedStatus ?? this.preparedStatus,
      preparedStatusRemarks: preparedStatusRemarks ?? this.preparedStatusRemarks,
      approvedBy: approvedBy ?? this.approvedBy,
      approvedDate: approvedDate ?? this.approvedDate,
      approvedStatus: approvedStatus ?? this.approvedStatus,
      approvedStatusRemarks: approvedStatusRemarks ?? this.approvedStatusRemarks,
      updatedBy: updatedBy ?? this.updatedBy,
      updatedDate: updatedDate ?? this.updatedDate,
      formNo: formNo ?? this.formNo,
      dateIssued: dateIssued ?? this.dateIssued,
      revisionNo: revisionNo ?? this.revisionNo,
      revisionDate: revisionDate ?? this.revisionDate,
      isCompleted: isCompleted ?? this.isCompleted,
      details: details ?? this.details,
    );
  }
}
