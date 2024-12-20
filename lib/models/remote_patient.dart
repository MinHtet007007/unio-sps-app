import 'package:sps/models/patient_package.dart';
import 'package:sps/models/support_month.dart';
import 'package:sps/models/remote_township.dart';

class Patient {
  final int id;
  final String year;
  final String? spsStartDate;
  final Township township;
  final String? rrCode;
  final String drtbCode;
  final String? spCode;
  final String uniqueId;
  final String name;
  final int age;
  final String sex;
  final String? diedBeforeTreatmentEnrollment;
  final String? treatmentStartDate;
  final String treatmentRegimen;
  final String? treatmentRegimenOther;
  final String patientAddress;
  final String patientPhoneNo;
  final String contactInfo;
  final String contactPhoneNo;
  final String primaryLanguage;
  final String? secondaryLanguage;
  final int height;
  final int weight;
  final int bmi;
  final String toStatus;
  final int? toYear;
  final String? toDate;
  final String? toRrCode;
  final String? toDrtbCode;
  final String? toUniqueId;
  final Township? toTownship;
  final List<Township> toTownships;
  final String? treatmentFinished;
  final String? treatmentFinishedDate;
  final String? outcomeDate;
  final String? outcome;
  final String? remark;
  final String? isReported;
  final String? reportPeriod;
  final Township currentTownship;
  final List<SupportMonth> supportMonths;
  final List<PatientPackage> patientPackages;

  Patient({
    required this.id,
    required this.year,
    this.spsStartDate,
    required this.township,
    this.rrCode,
    required this.drtbCode,
    required this.spCode,
    required this.uniqueId,
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
    required this.toStatus,
    this.toYear,
    this.toDate,
    this.toRrCode,
    this.toDrtbCode,
    this.toUniqueId,
    this.toTownship,
    required this.toTownships,
    this.treatmentFinished,
    this.treatmentFinishedDate,
    this.outcomeDate,
    this.outcome,
    this.remark,
    this.isReported,
    this.reportPeriod,
    required this.currentTownship,
    required this.supportMonths,
    required this.patientPackages,
  });

  factory Patient.fromJson(Map<String, dynamic> json) {
    return Patient(
      id: json['id'],
      year: json['year'],
      spsStartDate: json['SPS_start_date'],
      township: Township.fromJson(json['township']),
      rrCode: json['RR_code'],
      drtbCode: json['DRTB_code'],
      spCode: json['SP_code'],
      uniqueId: json['unique_id'],
      name: json['name'],
      age: json['age'],
      sex: json['sex'],
      diedBeforeTreatmentEnrollment: json['died_before_treatment_enrollment'],
      treatmentStartDate: json['treatment_start_date'],
      treatmentRegimen: json['treatment_regimen'],
      treatmentRegimenOther: json['treatment_regimen_other'],
      patientAddress: json['patient_address'],
      patientPhoneNo: json['patient_phone_no'],
      contactInfo: json['contact_info'],
      contactPhoneNo: json['contact_phone_no'],
      primaryLanguage: json['primary_language'],
      secondaryLanguage: json['secondary_language'],
      height: json['height'],
      weight: json['weight'],
      bmi: json['BMI'],
      toStatus: json['TO_status'],
      toYear: json['TO_year'],
      toDate: json['TO_date'],
      toRrCode: json['TO_RR_code'],
      toDrtbCode: json['TO_DRTB_code'],
      toUniqueId: json['TO_unique_id'],
      toTownship: json['TO_township'] != null
          ? Township.fromJson(json['TO_township'])
          : null,
      toTownships: (json['TO_townships'] as List)
          .map((e) => Township.fromJson(e))
          .toList(),
      treatmentFinished: json['treatment_finished'],
      treatmentFinishedDate: json['treatment_finished_date'],
      outcomeDate: json['outcome_date'],
      outcome: json['outcome'],
      remark: json['remark'],
      isReported: json['is_reported'],
      reportPeriod: json['report_period'],
      currentTownship: Township.fromJson(json['current_township']),
      supportMonths: (json['support_months'] as List)
          .map((e) => SupportMonth.fromJson(e))
          .toList(),
      patientPackages: (json['patient_packages'] as List)
          .map((e) => PatientPackage.fromJson(e))
          .toList(),
    );
  }
}
