class RemoteCounselingResult {
  String status;
  List<RemoteCounseling>? data;

  RemoteCounselingResult({required this.status, this.data});

  factory RemoteCounselingResult.fromJson(Map<String, dynamic> json) {
    return RemoteCounselingResult(
      status: json['status'],
      data: json['data'] != null
          ? (json['data'] as List<dynamic>)
              .map((data) => RemoteCounseling.fromJson(data))
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

class RemoteCounseling {
  int id;
  int dotsPatientId;
  String phase;
  String type;
  String date;

  RemoteCounseling(
      {required this.id,
      required this.dotsPatientId,
      required this.phase,
      required this.type,
      required this.date});

  factory RemoteCounseling.fromJson(Map<String, dynamic> json) {
    return RemoteCounseling(
      id: json['id'] ?? 0,
      dotsPatientId: json['dots_patient_id'] ?? 0,
      phase: json['phase'] ?? '',
      type: json['type'] ?? '',
      date: json['date'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['dots_patient_id'] = this.dotsPatientId;
    data['phase'] = this.phase;
    data['type'] = this.type;
    data['date'] = this.date;
    return data;
  }
}
