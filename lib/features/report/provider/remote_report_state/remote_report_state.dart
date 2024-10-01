import 'package:sps/features/report/data/model/remote_report_result.dart';

sealed class RemoteReportState {}

class RemoteReportLoadingState extends RemoteReportState {}

class RemoteReportSuccessState extends RemoteReportState {
  final Report data;
  RemoteReportSuccessState(this.data);
}

class RemoteReportFailedState extends RemoteReportState {
  final String errorMessage;
  RemoteReportFailedState(this.errorMessage);
}
