// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_support_month_with_relations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalSupportMonthWithRelations _$LocalSupportMonthWithRelationsFromJson(
        Map<String, dynamic> json) =>
    LocalSupportMonthWithRelations(
      id: (json['id'] as num?)?.toInt(),
      remoteId: (json['remoteId'] as num?)?.toInt(),
      localPatientId: (json['localPatientId'] as num).toInt(),
      remotePatientId: (json['remotePatientId'] as num).toInt(),
      patientName: json['patientName'] as String,
      townshipId: (json['townshipId'] as num).toInt(),
      date: json['date'] as String,
      month: (json['month'] as num).toInt(),
      monthYear: json['monthYear'] as String,
      height: (json['height'] as num).toInt(),
      weight: (json['weight'] as num).toInt(),
      bmi: (json['bmi'] as num).toInt(),
      planPackages: json['planPackages'] as String,
      receivePackageStatus: json['receivePackageStatus'] as String,
      reimbursementStatus: json['reimbursementStatus'] as String,
      amount: (json['amount'] as num?)?.toInt(),
      remark: json['remark'] as String?,
      isSynced: json['isSynced'] as bool,
      receivePackages: (json['receivePackages'] as List<dynamic>)
          .map((e) => ReceivePackageEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LocalSupportMonthWithRelationsToJson(
        LocalSupportMonthWithRelations instance) =>
    <String, dynamic>{
      'id': instance.id,
      'remoteId': instance.remoteId,
      'localPatientId': instance.localPatientId,
      'remotePatientId': instance.remotePatientId,
      'patientName': instance.patientName,
      'townshipId': instance.townshipId,
      'date': instance.date,
      'month': instance.month,
      'monthYear': instance.monthYear,
      'height': instance.height,
      'weight': instance.weight,
      'bmi': instance.bmi,
      'planPackages': instance.planPackages,
      'receivePackageStatus': instance.receivePackageStatus,
      'reimbursementStatus': instance.reimbursementStatus,
      'amount': instance.amount,
      'remark': instance.remark,
      'isSynced': instance.isSynced,
      'receivePackages': instance.receivePackages,
    };
