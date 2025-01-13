class PatientPackage {
  final int id;
  final int patientId; // Foreign key referencing Patient
  final String packageName;
  final int eligibleAmount;
  final int? updatedEligibleAmount;
  final int remainingAmount;

  PatientPackage({
    required this.id,
    required this.patientId,
    required this.packageName,
    required this.eligibleAmount,
    this.updatedEligibleAmount,
    required this.remainingAmount,
  });

  /// Factory constructor to create an instance of `PatientPackage` from JSON
  factory PatientPackage.fromJson(Map<String, dynamic> json) {
    return PatientPackage(
      id: json['id'],
      patientId: json['patient_id'],
      packageName: json['package_name'],
      eligibleAmount: int.parse(json['eligible_amount']),
      updatedEligibleAmount: json['updated_eligible_amount'] is String
          ? int.tryParse(json['updated_eligible_amount'] as String)
          : json['updated_eligible_amount'] as int?,
      remainingAmount: json['remaining_amount'],
    );
  }

  /// Method to convert `PatientPackage` instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patient_id': patientId,
      'package_name': packageName,
      'eligible_amount': eligibleAmount.toString(),
      'updated_eligible_amount': updatedEligibleAmount?.toString(),
      'remaining_amount': remainingAmount,
    };
  }
}
