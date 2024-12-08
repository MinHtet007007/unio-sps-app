import 'package:sps/models/support_month.dart';
import 'package:json_annotation/json_annotation.dart';

part 'support_month_sync_response.g.dart';

@JsonSerializable()
class SupportMonthSyncResponse {
  String status;
  List<SupportMonth> data;

  SupportMonthSyncResponse({
    required this.status,
    required this.data,
  });

  factory SupportMonthSyncResponse.fromJson(Map<String, dynamic> json) =>
      SupportMonthSyncResponse(
        status: json["status"],
        data: List<SupportMonth>.from(
            json["data"].map((x) => SupportMonth.fromJson(x))),
      );

  Map<String, dynamic> toJson() => _$SupportMonthSyncResponseToJson(this);
}
