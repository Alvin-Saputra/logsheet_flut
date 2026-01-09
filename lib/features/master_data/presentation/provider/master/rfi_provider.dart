import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:logsheet_app/features/master_data/data/model/master/crystallizer_entity.dart';
import 'package:logsheet_app/features/master_data/data/model/master/rfi_entity.dart';
import 'package:logsheet_app/features/master_data/data/repository/master/rfi_repository.dart';

class RfiProvider extends ChangeNotifier {
  final RfiRepository _repository;

  RfiProvider(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  List<RfiEntity> _rfiList = [];
  List<RfiEntity> get rfiList => _rfiList;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> fetchRfi() async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      _rfiList = await _repository.fetchRFI();
      notifyListeners();

      log("Rfi Length From Provider: ${rfiList.length}");
    } catch (e) {
      _setErrorMessage("$e");
    } finally {
      _setLoading(false);
    }
  }
}
