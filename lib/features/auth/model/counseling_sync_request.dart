class CounselingSyncRequest {
  final List<Map<String, dynamic>> counselingData;
  final int dotsPatientId;

  CounselingSyncRequest(
      {required this.counselingData, required this.dotsPatientId});

  Map<String, dynamic> toJson() =>
      {'counseling_data': counselingData, 'dots_patient_id': dotsPatientId};
}
