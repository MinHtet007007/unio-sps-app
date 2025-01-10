import 'package:sps/models/remote_patient.dart';

class RemoteLimitedPatientResponse {
  String status;
  bool hasMore;
  List<Patient> data;

  RemoteLimitedPatientResponse({
    required this.status,
    required this.data,
    required this.hasMore,
  });

  factory RemoteLimitedPatientResponse.fromJson(Map<String, dynamic> json) =>
      RemoteLimitedPatientResponse(
        status: json["status"],
        data: List<Patient>.from(json["data"].map((x) => Patient.fromJson(x))),
        hasMore: json["hasMore"]
      );
}
