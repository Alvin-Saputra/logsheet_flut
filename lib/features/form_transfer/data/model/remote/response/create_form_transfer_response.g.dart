// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'create_form_transfer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CreateFormTransferResponse _$CreateFormTransferResponseFromJson(
  Map<String, dynamic> json,
) => CreateFormTransferResponse(
  success: json['success'] as bool,
  idHeader: json['id_header'] as String,
  idDet: (json['id_det'] as List<dynamic>).map((e) => e as String).toList(),
);

Map<String, dynamic> _$CreateFormTransferResponseToJson(
  CreateFormTransferResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'id_header': instance.idHeader,
  'id_det': instance.idDet,
};
