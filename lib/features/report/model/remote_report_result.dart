class RemoteReportResult {
  String status;
  Report data;
  RemoteReportResult({
    required this.status,
    required this.data,
  });

  factory RemoteReportResult.fromJson(Map<String, dynamic> json) =>
      RemoteReportResult(
        status: json["status"],
        data: Report.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data.toJson(),
      };
}

class Report {

  int patientMaleCount;
  int patientFemaleCount;
  int patientTotalCount;
  int ipCounselingPhCount;
  int ipCounselingInPersonCount;
  int cpCounselingPhCount;
  int cpCounselingInPersonCount;

  Report({
   required this.patientMaleCount,
   required this.patientFemaleCount,
   required this.patientTotalCount,
   required this.ipCounselingPhCount,
   required this.ipCounselingInPersonCount,
   required this.cpCounselingPhCount,
   required this.cpCounselingInPersonCount,
  });

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        patientMaleCount: json["patient_male_count"],
        patientFemaleCount: json["patient_female_count"],
        patientTotalCount: json["patient_total_count"],
        ipCounselingPhCount: json["IP_counseling_ph_count"],
        ipCounselingInPersonCount: json["IP_counseling_in_person_count"],
        cpCounselingPhCount: json["CP_counseling_ph_count"],
        cpCounselingInPersonCount: json["CP_counseling_in_person_count"],
      );

  Map<String, dynamic> toJson() => {
        "patient_male_count": patientMaleCount,
        "patient_female_count": patientFemaleCount,
        "patient_total_count": patientTotalCount,
        "IP_counseling_ph_count": ipCounselingPhCount,
        "IP_counseling_in_person_count": ipCounselingInPersonCount,
        "CP_counseling_ph_count": cpCounselingPhCount,
        "CP_counseling_in_person_count": cpCounselingInPersonCount,
      };
}
