// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_form_transfer_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchFormTransferResponse _$FetchFormTransferResponseFromJson(
  Map<String, dynamic> json,
) => FetchFormTransferResponse(
  success: json['success'] as bool,
  data:
      (json['data'] as List<dynamic>)
          .map(
            (e) => FormTransferHeaderModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
);

Map<String, dynamic> _$FetchFormTransferResponseToJson(
  FetchFormTransferResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.map((e) => e.toJson()).toList(),
};
