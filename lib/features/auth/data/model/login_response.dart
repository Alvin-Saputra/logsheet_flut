import 'package:json_annotation/json_annotation.dart';

part 'login_response.g.dart';

@JsonSerializable()
class LoginResponse {
  final bool success;
  final String message;
  final User? user;
  @JsonKey(name: "business_unit")
  final BusinessUnit? businessUnit;
  final Plant? plant;
  final List<Menu>? menus;
  final String token;
  @JsonKey(name: "token_type")
  final String tokenType;

  LoginResponse({
    required this.success,
    required this.message,
    this.user,
    this.businessUnit,
    this.plant,
    this.menus,
    required this.token,
    required this.tokenType,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) =>
      _$LoginResponseFromJson(json);

  Map<String, dynamic> toJson() => _$LoginResponseToJson(this);
}

@JsonSerializable()
class User {
  final String userid;
  final String username;
  final String roles;
  final String isactive;
  final String? fullname;

  User({
    required this.userid,
    required this.username,
    required this.roles,
    required this.isactive,
    this.fullname,
  });

  factory User.fromJson(Map<String, dynamic> json) =>
      _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}

@JsonSerializable()
class BusinessUnit {
  final String code;
  final String name;

  BusinessUnit({required this.code, required this.name});

  factory BusinessUnit.fromJson(Map<String, dynamic> json) =>
      _$BusinessUnitFromJson(json);
  Map<String, dynamic> toJson() => _$BusinessUnitToJson(this);
}

@JsonSerializable()
class Plant {
  final String code;
  final String name;

  Plant({required this.code, required this.name});

  factory Plant.fromJson(Map<String, dynamic> json) =>
      _$PlantFromJson(json);
  Map<String, dynamic> toJson() => _$PlantToJson(this);
}

@JsonSerializable()
class Menu {
  @JsonKey(name: "menu_id")
  final int menuId;

  @JsonKey(name: "menu_name")
  final String menuName;

  @JsonKey(name: "route_name")
  final String? routeName;

  final String icon;

  @JsonKey(name: "parent_id")
  final int? parentId;

  @JsonKey(name: "sort_order")
  final int sortOrder;

  final String isactive;

  final List<Menu>? children;

  Menu({
    required this.menuId,
    required this.menuName,
    this.routeName,
    required this.icon,
    this.parentId,
    required this.sortOrder,
    required this.isactive,
    this.children,
  });

  factory Menu.fromJson(Map<String, dynamic> json) =>
      _$MenuFromJson(json);
  Map<String, dynamic> toJson() => _$MenuToJson(this);
}
