// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'fetch_dry_fractionation_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FetchDryFractionationResponse _$FetchDryFractionationResponseFromJson(
  Map<String, dynamic> json,
) => FetchDryFractionationResponse(
  success: json['success'] as bool,
  data:
      (json['data'] as List<dynamic>)
          .map(
            (e) =>
                DryFractionationHeaderModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
);

Map<String, dynamic> _$FetchDryFractionationResponseToJson(
  FetchDryFractionationResponse instance,
) => <String, dynamic>{
  'success': instance.success,
  'data': instance.data.map((e) => e.toJson()).toList(),
};
