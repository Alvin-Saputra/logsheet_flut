import 'package:flutter/material.dart';

class DryFractionationDetailEntity {
  final String id;
  final String idHdr;
  final int filtrationCycleNumber;
  final DateTime? filtrationDate;
  final double? filtrationTemp;
  final TimeOfDay? timeStartFiltration;
  final TimeOfDay? timeEndFiltration;
  final double? load;

  final double? oleinIv;
  final double? oleinCp;
  final double? oleinFfa;
  final double? oleinColorRed;

  final double? stearinIv;
  final double? stearinFfa;
  final double? stearinColorRed;
  final double? stearinPv;

  DryFractionationDetailEntity({
    required this.id,
    required this.idHdr,
    required this.filtrationCycleNumber,
    required this.filtrationDate,
    required this.filtrationTemp,
    required this.timeStartFiltration,
    required this.timeEndFiltration,
    required this.load,
    required this.oleinIv,
    required this.oleinCp,
    required this.oleinFfa,
    required this.oleinColorRed,
    required this.stearinIv,
    required this.stearinFfa,
    required this.stearinColorRed,
    required this.stearinPv,
  });
}
