class SupportPackage {
  final int id;
  final int amount;
  final int patientSupportMonthId; // Foreign key referencing SupportMonth
  final int patientPackageId; // ID of the package
  final String patientPackageName; // Name of the package
  final int reimbursementMonth; // Month of reimbursement as an integer
  final String
      reimbursementMonthYear; // Year and month of reimbursement as a string (e.g., "2024-01")

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
      id: json['id'],
      amount: json['amount'],
      patientSupportMonthId: json['patient_support_month_id'],
      patientPackageId: json['patient_package_id'],
      patientPackageName: json['patient_package_name'],
      reimbursementMonth: int.parse(json['reimbursement_month']),
      reimbursementMonthYear: json['reimbursement_month_year'],
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
      'reimbursement_month': reimbursementMonth.toString(),
      'reimbursement_month_year': reimbursementMonthYear,
    };
  }
}
