import 'dart:math';

import 'package:flutter/widgets.dart';
import 'package:logsheet_app/features/auth/data/datasources/local/storage_service/storage_service.dart';
import 'package:logsheet_app/features/auth/data/datasources/remote/api_service.dart';
import 'package:logsheet_app/features/master_data/data/model/master/user_entity.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService;
  final StorageService _storageService;

  AuthProvider(this._apiService, this._storageService);

  bool _isAuthenticated = false;
  bool get isAuthenticated => _isAuthenticated;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  void _setAuthenticationStatus(bool status) {
    _isAuthenticated = status;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<UserEntity?> loginUser(
    String username,
    String password,
    String businessUnit,
    String plant,
  ) async {
    _setLoading(true);
    _setErrorMessage(null);

    try {
      final body = {
        "username": username,
        "password": password,
        "business_unit": businessUnit,
        "plant": plant,
      };

      final response = await _apiService.login(body);

      if (response != null && response.success == true) {
        final user = UserEntity(
          userid: response.user?.userid ?? '',
          username: response.user?.username ?? '',
          isActive: response.user?.isactive ?? 'T',
          role: response.user?.roles ?? '',
          password: '',
        );

        await _saveLoginSession(
          username: username,
          businessUnit: businessUnit,
          plant: plant,
          token: response.token,
        );

        print("token: ${response.token}");

        _setAuthenticationStatus(true);
        return user;
      } else {
        _setErrorMessage(response?.message ?? 'Login gagal.');
        return null;
      }
    } catch (e) {
      _setErrorMessage('API login error: $e');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _saveLoginSession({
    required String username,
    required String businessUnit,
    required String plant,
    String? token,
  }) async {
    await _storageService.saveUsername(username);
    await _storageService.saveBusinessUnit(businessUnit);
    await _storageService.savePlant(plant);
    if (token != null) {
      await _storageService.saveSessionToken(token);
      var savedLoginInfo = await _storageService.readAllLoginData();
      print("Saved token: $savedLoginInfo");
    }
    // Jika ingin fitur "Remember Me", simpan credential lain di sini
  }
}
