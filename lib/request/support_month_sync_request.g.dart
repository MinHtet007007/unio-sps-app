// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'support_month_sync_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupportMonthSyncRequest _$SupportMonthSyncRequestFromJson(
        Map<String, dynamic> json) =>
    SupportMonthSyncRequest(
      supportMonths: (json['supportMonths'] as List<dynamic>)
          .map((e) => SupportMonth.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SupportMonthSyncRequestToJson(
        SupportMonthSyncRequest instance) =>
    <String, dynamic>{
      'supportMonths': instance.supportMonths,
    };
