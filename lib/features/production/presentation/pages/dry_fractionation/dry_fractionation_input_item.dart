import 'package:flutter/material.dart';

class DryFractionationInputItem {
  String? id;
  int? filtrationCycleNumber;
  TimeOfDay? timeStartFiltration;
  TimeOfDay? timeEndFiltration;

  final TextEditingController filtrationTempController = TextEditingController();
  final TextEditingController loadController = TextEditingController();
  final TextEditingController oleinIvController = TextEditingController();
  final TextEditingController oleinCpController = TextEditingController();
  final TextEditingController oleinFfaController = TextEditingController();
  final TextEditingController oleinColorRedController = TextEditingController();
  final TextEditingController stearinIvController = TextEditingController();
  final TextEditingController stearinFfaController = TextEditingController();
  final TextEditingController stearinColorRedController = TextEditingController();
  final TextEditingController stearinPvController = TextEditingController();
}  