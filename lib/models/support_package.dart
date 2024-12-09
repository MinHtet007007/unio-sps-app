class SupportPackage {
  final int id;
  final int amount;
  final int patientSupportMonthId;
  final int patientPackageId;
  final String patientPackageName;
  final int? reimbursementMonth;
  final String? reimbursementMonthYear;

  SupportPackage({
    required this.id,
    required this.amount,
    required this.patientSupportMonthId,
    required this.patientPackageId,
    required this.patientPackageName,
    required this.reimbursementMonth,
    required this.reimbursementMonthYear,
  });

  /// Factory constructor to create an instance of `SupportPackage` from JSON
  factory SupportPackage.fromJson(Map<String, dynamic> json) {
    return SupportPackage(
      id: json['id'] as int,
      amount: json['amount'] is String
          ? int.parse(json['amount'])
          : json['amount'] as int,
      patientSupportMonthId: json['patient_support_month_id'] is String
          ? int.parse(json['patient_support_month_id'])
          : json['patient_support_month_id'] as int,
      patientPackageId: json['patient_package_id'] is String
          ? int.parse(json['patient_package_id'])
          : json['patient_package_id'] as int,
      patientPackageName: json['patient_package_name'] as String,
      reimbursementMonth: json['reimbursement_month'] != null
          ? (json['reimbursement_month'] is String
              ? int.parse(json['reimbursement_month'])
              : json['reimbursement_month'] as int)
          : null,
      reimbursementMonthYear: json['reimbursement_month_year'] as String?,
    );
  }

  /// Method to convert `SupportPackage` instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'amount': amount,
      'patient_support_month_id': patientSupportMonthId,
      'patient_package_id': patientPackageId,
      'patient_package_name': patientPackageName,
      'reimbursement_month': reimbursementMonth,
      'reimbursement_month_year': reimbursementMonthYear,
    };
  }
}
