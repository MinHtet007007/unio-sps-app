import 'package:sps/models/support_month.dart';
import 'package:json_annotation/json_annotation.dart';

part 'support_month_sync_request.g.dart';

@JsonSerializable()
class SupportMonthSyncRequest {
  final List<SupportMonth> supportMonths;

  SupportMonthSyncRequest({required this.supportMonths});

  factory SupportMonthSyncRequest.fromJson(Map<String, dynamic> json) =>
      _$SupportMonthSyncRequestFromJson(json);

  Map<String, dynamic> toJson() => _$SupportMonthSyncRequestToJson(this);
}
