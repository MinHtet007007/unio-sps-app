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
  final double height;
  final double weight;
  final double bmi;
  final String planPackages;
  final String receivePackageStatus;
  final List<SupportPackage> receivePackages;
  final String reimbursementStatus;
  final int? reimbursementMonth;
  final String? reimbursementMonthYear;
  final double? amount;
  final String? remark;
  final int status;

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
    required this.status,
  });

  factory SupportMonth.fromJson(Map<String, dynamic> json) {
    return SupportMonth(
      id: json['id'],
      patientId: json['patient_id'],
      patientName: json['patient']['name'],
      townshipId: json['township_id'],
      township: Township.fromJson(json['township']),
      date: json['date'],
      month: json['month'],
      monthYear: json['month_year'],
      height: json['height'].toDouble(),
      weight: json['weight'].toDouble(),
      bmi: json['BMI'].toDouble(),
      planPackages: json['plan_packages'],
      receivePackageStatus: json['receive_package_status'],
      receivePackages: (json['receive_packages'] as List)
          .map((e) => SupportPackage.fromJson(e))
          .toList(),
      reimbursementStatus: json['reimbursement_status'],
      reimbursementMonth: json['reimbursement_month'],
      reimbursementMonthYear: json['reimbursement_month_year'],
      amount: json['amount']?.toDouble(),
      remark: json['remark'],
      status: json['status'],
    );
  }
  Map<String, dynamic> toJson() => _$SupportMonthToJson(this);
}