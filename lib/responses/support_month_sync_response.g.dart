// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_month_sync_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportMonthSyncResponse _$SupportMonthSyncResponseFromJson(
        Map<String, dynamic> json) =>
    SupportMonthSyncResponse(
      status: json['status'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => SupportMonth.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SupportMonthSyncResponseToJson(
        SupportMonthSyncResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'data': instance.data,
    };
