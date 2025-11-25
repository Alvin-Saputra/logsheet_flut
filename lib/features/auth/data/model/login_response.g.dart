// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      success: json['success'] as bool,
      message: json['message'] as String,
      user:
          json['user'] == null
              ? null
              : User.fromJson(json['user'] as Map<String, dynamic>),
      businessUnit:
          json['business_unit'] == null
              ? null
              : BusinessUnit.fromJson(
                json['business_unit'] as Map<String, dynamic>,
              ),
      plant:
          json['plant'] == null
              ? null
              : Plant.fromJson(json['plant'] as Map<String, dynamic>),
      menus:
          (json['menus'] as List<dynamic>?)
              ?.map((e) => Menu.fromJson(e as Map<String, dynamic>))
              .toList(),
      token: json['token'] as String,
      tokenType: json['token_type'] as String,
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'success': instance.success,
      'message': instance.message,
      'user': instance.user,
      'business_unit': instance.businessUnit,
      'plant': instance.plant,
      'menus': instance.menus,
      'token': instance.token,
      'token_type': instance.tokenType,
    };

User _$UserFromJson(Map<String, dynamic> json) => User(
  userid: json['userid'] as String,
  username: json['username'] as String,
  roles: json['roles'] as String,
  isactive: json['isactive'] as String,
  fullname: json['fullname'] as String?,
);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'userid': instance.userid,
  'username': instance.username,
  'roles': instance.roles,
  'isactive': instance.isactive,
  'fullname': instance.fullname,
};

BusinessUnit _$BusinessUnitFromJson(Map<String, dynamic> json) =>
    BusinessUnit(code: json['code'] as String, name: json['name'] as String);

Map<String, dynamic> _$BusinessUnitToJson(BusinessUnit instance) =>
    <String, dynamic>{'code': instance.code, 'name': instance.name};

Plant _$PlantFromJson(Map<String, dynamic> json) =>
    Plant(code: json['code'] as String, name: json['name'] as String);

Map<String, dynamic> _$PlantToJson(Plant instance) => <String, dynamic>{
  'code': instance.code,
  'name': instance.name,
};

Menu _$MenuFromJson(Map<String, dynamic> json) => Menu(
  menuId: (json['menu_id'] as num).toInt(),
  menuName: json['menu_name'] as String,
  routeName: json['route_name'] as String?,
  icon: json['icon'] as String,
  parentId: (json['parent_id'] as num?)?.toInt(),
  sortOrder: (json['sort_order'] as num).toInt(),
  isactive: json['isactive'] as String,
  children:
      (json['children'] as List<dynamic>?)
          ?.map((e) => Menu.fromJson(e as Map<String, dynamic>))
          .toList(),
);

Map<String, dynamic> _$MenuToJson(Menu instance) => <String, dynamic>{
  'menu_id': instance.menuId,
  'menu_name': instance.menuName,
  'route_name': instance.routeName,
  'icon': instance.icon,
  'parent_id': instance.parentId,
  'sort_order': instance.sortOrder,
  'isactive': instance.isactive,
  'children': instance.children,
};
