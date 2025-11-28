import 'package:logsheet_app/features/auth/data/datasources/remote/auth_api_service.dart';
import 'package:logsheet_app/features/auth/data/model/login_response.dart';
import 'package:logsheet_app/features/master_data/data/model/master/role_entity.dart';
import 'package:logsheet_app/features/master_data/data/model/master/user_entity.dart';
import 'package:logsheet_app/features/master_data/data/datasources/master/user_mysql_service.dart';

class UserRepository {
  final UserMySQLService _mySQLService;
  final AuthApiService _apiService;

  UserRepository(this._mySQLService, this._apiService);

  // -- CRUD OPERATIONS, FETCH DATA FROM THE MYSQL DATABASE
  // REGISTER
  Future<bool> registerUser(UserEntity user) async {
    return await _mySQLService.registerUser(
      user.userid,
      user.username,
      user.password,
      user.isActive,
      user.role,
    );
  }

  // LOGIN
  Future<({UserEntity? user, String? errorMessage})> login(
    String username,
    String password,
  ) async {
    final loginResult = await _mySQLService.loginUser(username, password);
    if (loginResult.errorMessage != null) {
      return (user: null, errorMessage: loginResult.errorMessage);
    } else if (loginResult.user == null) {
      return (user: null, errorMessage: 'Invalid username or password.');
    } else {
      return (user: UserEntity.fromMap(loginResult.user!), errorMessage: null);
    }
  }

  // GET ALL USER
  Future<List<UserEntity>> getAllUser() async {
    final List<Map<String, dynamic>> userMaps =
        await _mySQLService.getAllUsers();

    return userMaps.map((map) => UserEntity.fromMap(map)).toList();
  }

  // UPDATE A USER
  Future<bool> updateUser(UserEntity user) async {
    return await _mySQLService.updateUser(user);
  }

  // DELETE A USER
  Future<bool> deleteUser(String userId) async {
    return await _mySQLService.deleteUser(userId);
  }

  // GET ALL ROLES
  Future<List<RoleEntity>> getAllRoles() async {
    final List<Map<String, dynamic>> roleMaps =
        await _mySQLService.getAllRoles();

    return roleMaps.map((map) => RoleEntity.fromMap(map)).toList();
  }

  Future<LoginResponse?> loginAPI(String username, String password, String businessUnit, String plant) async {
    try {
      // buat Map<String, dynamic> sesuai body yang diharapkan API
      final body = {"username": username, "password": password, "business_unit": businessUnit, "plant": plant};

      return await _apiService.login(body);
    } catch (e) {
      print("API login error: $e");
      return null;
    }
  }
}
