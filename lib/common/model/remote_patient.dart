class RemotePatientResult {
  String status;
  List<RemotePatient>? data;

  RemotePatientResult({required this.status, this.data});

  factory RemotePatientResult.fromJson(Map<String, dynamic> json) {
    return RemotePatientResult(
      status: json['status'],
      data: json['data'] != null
          ? (json['data'] as List<dynamic>)
              .map((data) => RemotePatient.fromJson(data))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'status': status,
    };

    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class RemotePatient {
  int id;
  String name;
  String phone;
  String address;
  int patientId;
  int volunteerId;
  String? unionTemporaryCode;
  String? tbType;
  String? treatmentRegimen;
  String? dotsStartDate;
  String? dotsEndDate;
  String? treatmentOutcome;
  String? treatmentOutcomeDate;
  String? dotsPatientType;
  String? actualTreatmentStartDate;
  String? type;
  String? remark;

  RemotePatient(
      {required this.id,
      required this.name,
      required this.phone,
      required this.address,
      required this.patientId,
      required this.volunteerId,
      this.unionTemporaryCode,
      this.tbType,
      this.dotsStartDate,
      this.treatmentRegimen,
      this.dotsEndDate,
      this.treatmentOutcome,
      this.treatmentOutcomeDate,
      this.dotsPatientType,
      this.actualTreatmentStartDate,
      this.type,
      this.remark});

  factory RemotePatient.fromJson(Map<String, dynamic> json) {
    return RemotePatient(
        id: json['id'] ?? 0,
        name: json['name'] ?? '',
        phone: json['phone'] ?? '',
        address: json['address'] ?? '',
        unionTemporaryCode: json['union_temporary_code'] ?? '',
        tbType: json['defined_TB_type'] ?? '',
        treatmentRegimen: json['treatment_regimen'] ?? '',
        patientId: json['patient_id'] ?? 0,
        volunteerId: json['volunteer_id'] ?? 0,
        dotsStartDate: json['dots_start_date'] ?? '',
        dotsEndDate: json['dots_end_date'] ?? '',
        treatmentOutcome: json['treatment_outcome'] ?? '',
        treatmentOutcomeDate: json['treatment_outcome_date'] ?? '',
        dotsPatientType: json['dots_patient_type'] ?? '',
        actualTreatmentStartDate: json['actual_treatment_start_date'] ?? '',
        type: json['type'] ?? '',
        remark: json['remark'] ?? '');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['address'] = address;
    data['union_temporary_code'] = unionTemporaryCode;
    data['treatment_regimen'] = treatmentRegimen;
    data['patient_id'] = patientId;
    data['volunteer_id'] = volunteerId;
    data['defined_TB_type'] = tbType;
    data['dots_start_date'] = dotsStartDate;
    data['dots_end_date'] = dotsEndDate;
    data['treatment_outcome'] = treatmentOutcome;
    data['treatment_outcome_date'] = treatmentOutcomeDate;
    data['dots_patient_type'] = dotsPatientType;
    data['actual_treatment_start_date'] = actualTreatmentStartDate;
    data['type'] = type;
    data['remark'] = remark;
    return data;
  }
}
