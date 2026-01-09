import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/features/master_data/data/model/master/crystallizer_entity.dart';
import 'package:logsheet_app/features/master_data/data/model/master/product_entity.dart';
import 'package:logsheet_app/features/master_data/data/repository/master/crystallizer_repository.dart';
import 'package:logsheet_app/features/master_data/data/repository/master/product_repository.dart';

class CrystallizerProvider extends ChangeNotifier {
  final CrystallizerRepository _repository;

  CrystallizerProvider(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<CrystallizerEntity> _crystallizerList = [];
  List<CrystallizerEntity> get crystallizerList => _crystallizerList;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> fetchCrystallizer() async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      _crystallizerList = await _repository.fetchCrystallizer();
      notifyListeners();

      log("Crystallizer Length From Provider: ${crystallizerList.length}");
    } catch (e) {
      _setErrorMessage("$e");
    } finally {
      _setLoading(false);
    }
  }
}
