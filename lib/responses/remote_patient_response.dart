import 'package:sps/models/remote_patient.dart';

class RemotePatientResponse {
  String status;
  List<Patient> data;

  RemotePatientResponse({
    required this.status,
    required this.data,
  });

  factory RemotePatientResponse.fromJson(Map<String, dynamic> json) =>
      RemotePatientResponse(
        status: json["status"],
        data: List<Patient>.from(json["data"].map((x) => Patient.fromJson(x))),
      );
}
