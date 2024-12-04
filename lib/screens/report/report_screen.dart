import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:sps/common/widgets/loading_widget.dart';
import 'package:sps/common/widgets/refresh_when_failed_widget.dart';
import 'package:sps/features/report/provider/remote_report_provider.dart';
import 'package:sps/features/report/provider/remote_report_state/remote_report_state.dart';
import 'package:sps/screens/report/widget/report_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportScreen extends ConsumerStatefulWidget {
  const ReportScreen({super.key});

  @override
  ConsumerState<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends ConsumerState<ReportScreen> {
  @override
  @override
  void initState() {
    super.initState();
    _fetchReport();
  }

  void _fetchReport() async {
    await Future.delayed(Duration.zero);

    final reportNotifier = ref.read(remoteReportProvider.notifier);
    reportNotifier.fetchReport();
  }

  @override
  Widget build(BuildContext context) {
    final localState = ref.watch(remoteReportProvider);

    return Scaffold(
        appBar: AppBar(
          title: CustomLabelWidget(
            text: "အနှစ်ချုပ်",
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          backgroundColor: ColorTheme.primary,
        ),
        body: RefreshIndicator(
            onRefresh: () async => _fetchReport(),
            child: _reportWidget(localState)));
  }

  Widget _reportWidget(RemoteReportState state) {
    return _buildWidgetBasedOnState(state);
  }

  Widget _buildWidgetBasedOnState(RemoteReportState state) {
    switch (state) {
      case RemoteReportFailedState():
        return RefreshWhenFailedWidget(
          refresh: _fetchReport,
          errorMessage: state.errorMessage,
        );
      case RemoteReportLoadingState():
        return const LoadingWidget();
      case RemoteReportSuccessState():
        return ReportWidget(data: state.data);
    }
  }
}
