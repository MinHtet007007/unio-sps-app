class ReceivedPackageRequest {
  final int? id;
  final int? remoteId;
  final int? localPatientSupportMonthId;
  final int? remotePatientPackageId;
  final int? localPatientPackageId;
  final int amount;
  final String patientPackageName;
  final int? reimbursementMonth;
  final String? reimbursementMonthYear;

  ReceivedPackageRequest({
    this.id,
    this.remoteId,
    this.localPatientSupportMonthId,
    this.remotePatientPackageId,
    this.localPatientPackageId,
    required this.amount,
    required this.patientPackageName,
    this.reimbursementMonth,
    this.reimbursementMonthYear,
  });

  /// Factory constructor to create an instance of `ReceivedPackageRequest` from JSON
  factory ReceivedPackageRequest.fromJson(Map<String, dynamic> json) {
    return ReceivedPackageRequest(
      id: json['id'],
      remoteId: json['remote_id'],
      localPatientSupportMonthId: json['local_patient_support_month_id'],
      remotePatientPackageId: json['remote_patient_package_id'],
      localPatientPackageId: json['local_patient_package_id'],
      amount: json['amount'],
      patientPackageName: json['patient_package_name'],
      reimbursementMonth: json['reimbursement_month'],
      reimbursementMonthYear: json['reimbursement_month_year'],
    );
  }

  /// Method to convert `ReceivedPackageRequest` instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'remote_id': remoteId,
      'local_patient_support_month_id': localPatientSupportMonthId,
      'remote_patient_package_id': remotePatientPackageId,
      'local_patient_package_id': localPatientPackageId,
      'amount': amount,
      'patient_package_name': patientPackageName,
      'reimbursement_month': reimbursementMonth,
      'reimbursement_month_year': reimbursementMonthYear,
    };
  }
}
