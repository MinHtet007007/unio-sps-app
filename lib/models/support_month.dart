import 'package:sps/models/support_package.dart';
import 'package:sps/models/remote_township.dart';
import 'package:json_annotation/json_annotation.dart';

part 'support_month.g.dart';

@JsonSerializable()
class SupportMonth {
  final int id;
  final int patientId;
  final String patientName;
  final int townshipId;
  final Township township;
  final String date;
  final int month;
  final String monthYear;
  final int height;
  final int weight;
  final int bmi;
  final String planPackages;
  final String receivePackageStatus;
  final List<SupportPackage> receivePackages;
  final String reimbursementStatus;
  final int? reimbursementMonth;
  final String? reimbursementMonthYear;
  final int? amount;
  final String? remark;

  SupportMonth({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.townshipId,
    required this.township,
    required this.date,
    required this.month,
    required this.monthYear,
    required this.height,
    required this.weight,
    required this.bmi,
    required this.planPackages,
    required this.receivePackageStatus,
    required this.receivePackages,
    required this.reimbursementStatus,
    this.reimbursementMonth,
    this.reimbursementMonthYear,
    this.amount,
    this.remark,
  });

  factory SupportMonth.fromJson(Map<String, dynamic> json) {
    return SupportMonth(
      id: json['id'] as int,
      patientId: json['patient_id'] as int,
      patientName: json['patient']['name'] as String,
      townshipId: json['township_id'] as int,
      township: Township.fromJson(json['township'] as Map<String, dynamic>),
      date: json['date'] as String,
      month: int.tryParse(json['month'].toString()) ?? 0,
      monthYear: json['month_year'] as String,
      height: json['height'] as int,
      weight: json['weight'] as int,
      bmi: int.tryParse(json['BMI'].toString()) ?? 0,
      planPackages: json['plan_packages'] as String,
      receivePackageStatus: json['receive_package_status'] as String,
      receivePackages: (json['receive_packages'] as List<dynamic>)
          .map((e) => SupportPackage.fromJson(e as Map<String, dynamic>))
          .toList(),
      reimbursementStatus: '${json['reimbursement_status']}',
      reimbursementMonth: json['reimbursement_month'] != null
          ? (json['reimbursement_month'] is String
              ? int.parse(json['reimbursement_month'])
              : json['reimbursement_month'] as int)
          : null,
      reimbursementMonthYear: json['reimbursement_month_year'] as String?,
      amount: json['amount'] as int?,
      remark: json['remark'] as String?,
    );
  }

  Map<String, dynamic> toJson() => _$SupportMonthToJson(this);
}
