import 'package:sps/common/provider/dio/dio_provider.dart';
import 'package:sps/features/report/data/service/report_service.dart';
import 'package:sps/features/report/provider/remote_report_state/remote_report_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

class RemoteReportProvider extends Notifier<RemoteReportState> {
  RemoteReportState reportState = RemoteReportLoadingState();
  @override
  build() {
    return reportState;
  }

  late final Dio _dio = ref.read(dioProvider);

  void fetchReport({String? month, String? year, String? name}) async {
    try {
      state = RemoteReportLoadingState();

      ReportService reportService = ReportService(_dio);
      final response =
          await reportService.getReport(month: month, year: year, name: name);

      final report = response.data;
      state = RemoteReportSuccessState(report);
      return;
    } catch (error) {
      state = RemoteReportFailedState(error.toString());
    }
  }
}

final remoteReportProvider =
    NotifierProvider<RemoteReportProvider, RemoteReportState>(
        () => RemoteReportProvider());
