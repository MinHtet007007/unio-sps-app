// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_patient_with_relations.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LocalPatientWithRelations _$LocalPatientWithRelationsFromJson(
        Map<String, dynamic> json) =>
    LocalPatientWithRelations(
      id: (json['id'] as num).toInt(),
      year: json['year'] as String,
      remoteId: (json['remoteId'] as num?)?.toInt(),
      spsStartDate: json['spsStartDate'] as String?,
      townshipId: (json['townshipId'] as num).toInt(),
      rrCode: json['rrCode'] as String?,
      drtbCode: json['drtbCode'] as String,
      spCode: json['spCode'] as String,
      uniqueId: json['uniqueId'] as String?,
      name: json['name'] as String,
      age: (json['age'] as num).toInt(),
      sex: json['sex'] as String,
      diedBeforeTreatmentEnrollment:
          json['diedBeforeTreatmentEnrollment'] as String?,
      treatmentStartDate: json['treatmentStartDate'] as String?,
      treatmentRegimen: json['treatmentRegimen'] as String,
      treatmentRegimenOther: json['treatmentRegimenOther'] as String?,
      patientAddress: json['patientAddress'] as String,
      patientPhoneNo: json['patientPhoneNo'] as String,
      contactInfo: json['contactInfo'] as String,
      contactPhoneNo: json['contactPhoneNo'] as String,
      primaryLanguage: json['primaryLanguage'] as String,
      secondaryLanguage: json['secondaryLanguage'] as String?,
      height: (json['height'] as num).toInt(),
      weight: (json['weight'] as num).toInt(),
      bmi: (json['bmi'] as num).toInt(),
      toStatus: json['toStatus'] as String?,
      toYear: (json['toYear'] as num?)?.toInt(),
      toDate: json['toDate'] as String?,
      toRrCode: json['toRrCode'] as String?,
      toDrtbCode: json['toDrtbCode'] as String?,
      toUniqueId: json['toUniqueId'] as String?,
      toTownshipId: (json['toTownshipId'] as num?)?.toInt(),
      outcome: json['outcome'] as String?,
      remark: json['remark'] as String?,
      treatmentFinished: json['treatmentFinished'] as String?,
      treatmentFinishedDate: json['treatmentFinishedDate'] as String?,
      outcomeDate: json['outcomeDate'] as String?,
      isReported: json['isReported'] as String?,
      reportPeriod: json['reportPeriod'] as String?,
      currentTownshipId: (json['currentTownshipId'] as num).toInt(),
      isSynced: json['isSynced'] as bool,
      patientPackages: (json['patientPackages'] as List<dynamic>)
          .map((e) => PatientPackageEntity.fromJson(e as Map<String, dynamic>))
          .toList(),
      supportMonths: (json['supportMonths'] as List<dynamic>)
          .map((e) => LocalSupportMonthWithRelations.fromJson(
              e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$LocalPatientWithRelationsToJson(
        LocalPatientWithRelations instance) =>
    <String, dynamic>{
      'id': instance.id,
      'remoteId': instance.remoteId,
      'year': instance.year,
      'spsStartDate': instance.spsStartDate,
      'townshipId': instance.townshipId,
      'rrCode': instance.rrCode,
      'drtbCode': instance.drtbCode,
      'spCode': instance.spCode,
      'uniqueId': instance.uniqueId,
      'name': instance.name,
      'age': instance.age,
      'sex': instance.sex,
      'diedBeforeTreatmentEnrollment': instance.diedBeforeTreatmentEnrollment,
      'treatmentStartDate': instance.treatmentStartDate,
      'treatmentRegimen': instance.treatmentRegimen,
      'treatmentRegimenOther': instance.treatmentRegimenOther,
      'patientAddress': instance.patientAddress,
      'patientPhoneNo': instance.patientPhoneNo,
      'contactInfo': instance.contactInfo,
      'contactPhoneNo': instance.contactPhoneNo,
      'primaryLanguage': instance.primaryLanguage,
      'secondaryLanguage': instance.secondaryLanguage,
      'height': instance.height,
      'weight': instance.weight,
      'bmi': instance.bmi,
      'toStatus': instance.toStatus,
      'toYear': instance.toYear,
      'toDate': instance.toDate,
      'toRrCode': instance.toRrCode,
      'toDrtbCode': instance.toDrtbCode,
      'toUniqueId': instance.toUniqueId,
      'toTownshipId': instance.toTownshipId,
      'outcome': instance.outcome,
      'remark': instance.remark,
      'treatmentFinished': instance.treatmentFinished,
      'treatmentFinishedDate': instance.treatmentFinishedDate,
      'outcomeDate': instance.outcomeDate,
      'isReported': instance.isReported,
      'reportPeriod': instance.reportPeriod,
      'currentTownshipId': instance.currentTownshipId,
      'isSynced': instance.isSynced,
      'patientPackages': instance.patientPackages,
      'supportMonths': instance.supportMonths,
    };
