import 'package:sps/features/local_patients_sync/model/local_support_month_with_relations.dart';
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/local_database/entity/patient_package_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'local_patient_with_relations.g.dart';

@JsonSerializable()
class LocalPatientWithRelations {
  final int id;
  final int? remoteId;
  final String year;
  final String? spsStartDate;
  final int townshipId;
  final String? rrCode;
  final String? drtbCode;
  final String? spCode;
  final String? uniqueId;
  final String name;
  final int age;
  final String sex;
  final String? diedBeforeTreatmentEnrollment;
  final String? treatmentStartDate;
  final String? treatmentRegimen;
  final String? treatmentRegimenOther;
  final String patientAddress;
  final String patientPhoneNo;
  final String contactInfo;
  final String contactPhoneNo;
  final String primaryLanguage;
  final String? secondaryLanguage;
  final double height;
  final double weight;
  final double bmi;
  final String? toStatus;
  final int? toYear;
  final String? toDate;
  final String? toRrCode;
  final String? toDrtbCode;
  final String? toUniqueId;
  final int? toTownshipId;
  final String? outcome;
  final String? remark;
  final String? treatmentFinished;
  final String? treatmentFinishedDate;
  final String? outcomeDate;
  final String? isReported;
  final String? reportPeriod;
  final int currentTownshipId;
  final bool isSynced;
  final List<PatientPackageEntity> patientPackages;
  final List<LocalSupportMonthWithRelations> supportMonths;

  LocalPatientWithRelations({
    required this.id,
    required this.year,
    this.remoteId,
    this.spsStartDate,
    required this.townshipId,
    this.rrCode,
    required this.drtbCode,
    required this.spCode,
    this.uniqueId,
    required this.name,
    required this.age,
    required this.sex,
    this.diedBeforeTreatmentEnrollment,
    this.treatmentStartDate,
    required this.treatmentRegimen,
    this.treatmentRegimenOther,
    required this.patientAddress,
    required this.patientPhoneNo,
    required this.contactInfo,
    required this.contactPhoneNo,
    required this.primaryLanguage,
    this.secondaryLanguage,
    required this.height,
    required this.weight,
    required this.bmi,
    this.toStatus,
    this.toYear,
    this.toDate,
    this.toRrCode,
    this.toDrtbCode,
    this.toUniqueId,
    this.toTownshipId,
    this.outcome,
    this.remark,
    this.treatmentFinished,
    this.treatmentFinishedDate,
    this.outcomeDate,
    this.isReported,
    this.reportPeriod,
    required this.currentTownshipId,
    required this.isSynced,
    required this.patientPackages,
    required this.supportMonths,
  });

  factory LocalPatientWithRelations.fromJson(Map<String, dynamic> json) =>
      _$LocalPatientWithRelationsFromJson(json);

  Map<String, dynamic> toJson() => {
        'id': id,
        'remote_id': remoteId,
        'year': year,
        'SPS_start_date': spsStartDate,
        'township_id': townshipId,
        'RR_code': rrCode,
        'DRTB_code': drtbCode,
        'SP_code': spCode,
        'name': name,
        'age': age,
        'sex': sex,
        'died_before_treatment_enrollment': diedBeforeTreatmentEnrollment,
        'treatment_start_date': treatmentStartDate,
        'treatment_regimen': treatmentRegimen,
        'treatment_regimen_other': treatmentRegimenOther,
        'patient_address': patientAddress,
        'patient_phone_no': patientPhoneNo,
        'contact_info': contactInfo,
        'contact_phone_no': contactPhoneNo,
        'primary_language': primaryLanguage,
        'secondary_language': secondaryLanguage,
        'height': height,
        'weight': weight,
        'BMI': bmi,
        'remark': remark,
        'current_township_id': currentTownshipId,
        'patient_packages':
            patientPackages.map((package) => package.toJson()).toList(),
        'support_months': supportMonths.map((month) => month.toJson()).toList(),
      };
}

LocalPatientWithRelations createLocalPatientWithRelations(
  PatientEntity patientEntity,
  List<PatientPackageEntity> patientPackages,
  List<LocalSupportMonthWithRelations> supportMonths,
) {
  return LocalPatientWithRelations(
    id: patientEntity.id as int,
    year: patientEntity.year,
    remoteId: patientEntity.remoteId,
    spsStartDate: patientEntity.spsStartDate,
    townshipId: patientEntity.townshipId,
    rrCode: patientEntity.rrCode,
    drtbCode: patientEntity.drtbCode,
    spCode: patientEntity.spCode,
    uniqueId: patientEntity.uniqueId,
    name: patientEntity.name,
    age: patientEntity.age,
    sex: patientEntity.sex,
    diedBeforeTreatmentEnrollment: patientEntity.diedBeforeTreatmentEnrollment,
    treatmentStartDate: patientEntity.treatmentStartDate,
    treatmentRegimen: patientEntity.treatmentRegimen,
    treatmentRegimenOther: patientEntity.treatmentRegimenOther,
    patientAddress: patientEntity.patientAddress,
    patientPhoneNo: patientEntity.patientPhoneNo,
    contactInfo: patientEntity.contactInfo,
    contactPhoneNo: patientEntity.contactPhoneNo,
    primaryLanguage: patientEntity.primaryLanguage,
    secondaryLanguage: patientEntity.secondaryLanguage,
    height: patientEntity.height,
    weight: patientEntity.weight,
    bmi: patientEntity.bmi,
    toStatus: patientEntity.toStatus,
    toYear: patientEntity.toYear,
    toDate: patientEntity.toDate,
    toRrCode: patientEntity.toRrCode,
    toDrtbCode: patientEntity.toDrtbCode,
    toUniqueId: patientEntity.toUniqueId,
    toTownshipId: patientEntity.toTownshipId,
    outcome: patientEntity.outcome,
    remark: patientEntity.remark,
    treatmentFinished: patientEntity.treatmentFinished,
    treatmentFinishedDate: patientEntity.treatmentFinishedDate,
    outcomeDate: patientEntity.outcomeDate,
    isReported: patientEntity.isReported,
    reportPeriod: patientEntity.reportPeriod,
    currentTownshipId: patientEntity.currentTownshipId,
    isSynced: patientEntity.isSynced,
    patientPackages: patientPackages,
    supportMonths: supportMonths,
  );
}
