import 'package:sps/local_database/entity/receive_package_entity.dart';
import 'package:sps/local_database/entity/support_month_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'local_support_month_with_relations.g.dart';

@JsonSerializable()
class LocalSupportMonthWithRelations {
  final int? id;
  final int? remoteId;
  final int localPatientId;
  final int? remotePatientId;
  final String patientName;
  final int townshipId;
  final String date;
  final int month;
  final String monthYear;
  final double height;
  final double weight;
  final double bmi;
  final String planPackages;
  final String receivePackageStatus;
  final String reimbursementStatus;
  final int? amount;
  final String? remark;
  final String? signature_key;
  final bool isSynced;
  final List<ReceivePackageEntity> receivePackages;

  LocalSupportMonthWithRelations(
      {this.id,
      this.remoteId,
      required this.localPatientId,
      required this.remotePatientId,
      required this.patientName,
      required this.townshipId,
      required this.date,
      required this.month,
      required this.monthYear,
      required this.height,
      required this.weight,
      required this.bmi,
      required this.planPackages,
      required this.receivePackageStatus,
      required this.reimbursementStatus,
      this.signature_key,
      this.amount,
      this.remark,
      required this.isSynced,
      required this.receivePackages});

  factory LocalSupportMonthWithRelations.fromJson(Map<String, dynamic> json) =>
      _$LocalSupportMonthWithRelationsFromJson(json);
  Map<String, dynamic> toJson() => {
        'id': id,
        'remote_id': remoteId,
        'local_patient_id': localPatientId,
        'remote_patient_id': remotePatientId,
        'patient_name': patientName,
        'township_id': townshipId,
        'date': date,
        'month': month,
        'month_year': monthYear,
        'height': height,
        'weight': weight,
        'BMI': bmi,
        'signature_key': signature_key,
        'plan_packages': planPackages,
        'receive_package_status': receivePackageStatus,
        'reimbursement_status': reimbursementStatus,
        'amount': amount,
        'remark': remark,
        'receive_packages':
            receivePackages.map((package) => package.toJson()).toList(),
      };
}

LocalSupportMonthWithRelations createLocalSupportMonthWithRelations(
  SupportMonthEntity supportMonthEntity,
  String? signature_key,
  List<ReceivePackageEntity> packages,
) {
  return LocalSupportMonthWithRelations(
    id: supportMonthEntity.id,
    signature_key: signature_key,
    remoteId: supportMonthEntity.remoteId,
    localPatientId: supportMonthEntity.localPatientId,
    remotePatientId: supportMonthEntity.remotePatientId,
    patientName: supportMonthEntity.patientName,
    townshipId: supportMonthEntity.townshipId,
    date: supportMonthEntity.date,
    month: supportMonthEntity.month,
    monthYear: supportMonthEntity.monthYear,
    height: supportMonthEntity.height,
    weight: supportMonthEntity.weight,
    bmi: supportMonthEntity.bmi,
    planPackages: supportMonthEntity.planPackages,
    receivePackageStatus: supportMonthEntity.receivePackageStatus,
    reimbursementStatus: supportMonthEntity.reimbursementStatus,
    amount: supportMonthEntity.amount,
    remark: supportMonthEntity.remark,
    isSynced: supportMonthEntity.isSynced,
    receivePackages: packages,
  );
}
