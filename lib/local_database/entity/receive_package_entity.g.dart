// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'receive_package_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReceivePackageEntity _$ReceivePackageEntityFromJson(
        Map<String, dynamic> json) =>
    ReceivePackageEntity(
      id: (json['id'] as num?)?.toInt(),
      remoteId: (json['remoteId'] as num?)?.toInt(),
      amount: (json['amount'] as num).toInt(),
      localPatientSupportMonthId:
          (json['localPatientSupportMonthId'] as num).toInt(),
      remotePatientPackageId: (json['remotePatientPackageId'] as num?)?.toInt(),
      localPatientPackageId: (json['localPatientPackageId'] as num?)?.toInt(),
      patientPackageName: json['patientPackageName'] as String,
      reimbursementMonth: (json['reimbursementMonth'] as num?)?.toInt(),
      reimbursementMonthYear: json['reimbursementMonthYear'] as String?,
    );

Map<String, dynamic> _$ReceivePackageEntityToJson(
        ReceivePackageEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'remoteId': instance.remoteId,
      'localPatientSupportMonthId': instance.localPatientSupportMonthId,
      'remotePatientPackageId': instance.remotePatientPackageId,
      'localPatientPackageId': instance.localPatientPackageId,
      'amount': instance.amount,
      'patientPackageName': instance.patientPackageName,
      'reimbursementMonth': instance.reimbursementMonth,
      'reimbursementMonthYear': instance.reimbursementMonthYear,
    };
