import 'package:sps/common/constants/route_list.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/model/counseling_route_extra_data.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:sps/common/widgets/refresh_when_failed_widget.dart';
import 'package:sps/common/widgets/loading_widget.dart';
import 'package:sps/common/widgets/sync_button.dart';
import 'package:sps/features/counseling_list/provider/local_counselings_provider.dart';
import 'package:sps/features/counseling_list/provider/local_counselings_state/local_counselings_state.dart';
import 'package:sps/features/counseling_list/ui/widget/list_view.dart';
import 'package:sps/features/patient_details/provider/local_patient_provider.dart';
import 'package:sps/features/patient_details/provider/local_patient_state/local_patient_state.dart';
import 'package:sps/features/patient_list/provider/local_patients_state/local_patients_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CounselingScreen extends ConsumerStatefulWidget {
  final int patientId;
  final String phase;
  const CounselingScreen(
      {super.key, required this.patientId, required this.phase});

  @override
  ConsumerState<CounselingScreen> createState() => _CounselingScreenState();
}

class _CounselingScreenState extends ConsumerState<CounselingScreen> {
  @override
  @override
  void initState() {
    super.initState();
    _fetchCounselings();
    _fetchPatient();
  }

  void _fetchCounselings() async {
    await Future.delayed(Duration.zero);

    final patientNotifier = ref.read(localCounselingsProvider.notifier);
    patientNotifier.fetchCounselings(widget.patientId);
  }

  void _fetchPatient() async {
    await Future.delayed(Duration.zero);
    final patientNotifier = ref.read(localPatientProvider.notifier);
    patientNotifier.fetchPatient(widget.patientId);
  }

  @override
  Widget build(BuildContext context) {
    final localState = ref.watch(localCounselingsProvider);
    final localPatientState = ref.watch(localPatientProvider);

    return Scaffold(
        appBar: AppBar(
          title: CustomLabelWidget(
              text: "Counseling စာရင်း", style: AppBarTextStyle),
          backgroundColor: ColorTheme.primary,
          actions: [
            SyncButton(
                isLoading: localState is LocalPatientsLoadingState,
                onPressed: _onSync),
          ],
        ),
        body: _counselingListWidget(localState, localPatientState),
        floatingActionButton: (localPatientState is LocalPatientSuccessState &&
                localPatientState.localPatient.dotsEndDate!.isEmpty)
            ? FloatingActionButton(
                heroTag: 'add',
                child: const Icon(Icons.add),
                onPressed: () {
                  final phaseData = CounselingRouteExtraData(
                      phase: widget.phase,
                      dotsStartDate: localPatientState
                          .localPatient.dotsStartDate as String);

                  context.push('${RouteName.newCounseling}/${widget.patientId}',
                      extra: phaseData);
                },
              )
            : null);
  }

  void _onSync() async {
    await Future.delayed(Duration.zero);
    ref
        .read(localCounselingsProvider.notifier)
        .syncLocalCounselings(widget.patientId);
  }

  Widget _counselingListWidget(
      LocalCounselingsState state, LocalPatientState patientState) {
    return _buildWidgetBasedOnState(state, patientState);
  }

  Widget _buildWidgetBasedOnState(
      LocalCounselingsState state, LocalPatientState patientState) {
    if (patientState is LocalPatientLoadingState) {
      return const LoadingWidget();
    }

    if (patientState is LocalPatientFailedState) {
      return RefreshWhenFailedWidget(
        refresh: _fetchPatient,
        errorMessage: patientState.errorMessage,
      );
    }
    switch (state) {
      case LocalCounselingsFailedState():
        return RefreshWhenFailedWidget(
          refresh: _fetchCounselings,
          errorMessage: state.errorMessage,
        );
      case LocalCounselingsLoadingState():
        return const LoadingWidget();
      case LocalCounselingsSuccessState():
        return CustomListView(counselings: state.localCounselings);
    }
  }
}
