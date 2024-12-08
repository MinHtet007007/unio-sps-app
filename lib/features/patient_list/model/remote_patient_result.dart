import 'package:sps/models/remote_patient.dart';

class RemotePatientResult {
  String status;
  List<Patient> data;

  RemotePatientResult({
    required this.status,
    required this.data,
  });

  factory RemotePatientResult.fromJson(Map<String, dynamic> json) =>
      RemotePatientResult(
        status: json["status"],
        data: List<Patient>.from(json["data"].map((x) => Patient.fromJson(x))),
      );
}
