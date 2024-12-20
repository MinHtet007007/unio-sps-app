// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'patient_package_entity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PatientPackageEntity _$PatientPackageEntityFromJson(
        Map<String, dynamic> json) =>
    PatientPackageEntity(
      id: (json['id'] as num?)?.toInt(),
      remoteId: (json['remoteId'] as num?)?.toInt(),
      localPatientId: (json['localPatientId'] as num).toInt(),
      remotePatientId: (json['remotePatientId'] as num?)?.toInt(),
      packageName: json['packageName'] as String,
      eligibleAmount: (json['eligibleAmount'] as num).toInt(),
      updatedEligibleAmount: (json['updatedEligibleAmount'] as num?)?.toInt(),
      remainingAmount: (json['remainingAmount'] as num).toInt(),
    );

Map<String, dynamic> _$PatientPackageEntityToJson(
        PatientPackageEntity instance) =>
    <String, dynamic>{
      'id': instance.id,
      'remoteId': instance.remoteId,
      'localPatientId': instance.localPatientId,
      'remotePatientId': instance.remotePatientId,
      'packageName': instance.packageName,
      'eligibleAmount': instance.eligibleAmount,
      'updatedEligibleAmount': instance.updatedEligibleAmount,
      'remainingAmount': instance.remainingAmount,
    };
