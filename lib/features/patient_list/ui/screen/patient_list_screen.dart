import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:sps/common/widgets/loading_widget.dart';
import 'package:sps/common/widgets/refresh_when_failed_widget.dart';
import 'package:sps/common/widgets/sync_button.dart';
import 'package:sps/features/patient_list/provider/local_patients_provider.dart';
import 'package:sps/features/patient_list/provider/local_patients_state/local_patients_state.dart';
import 'package:sps/features/patient_list/provider/local_unsynced_counselings_count_provider.dart';
import 'package:sps/features/patient_list/provider/local_unsynced_counselings_count_state/local_unsynced_counseling_count_state.dart';
import 'package:sps/features/patient_list/ui/widget/list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatientScreen extends ConsumerStatefulWidget {
  const PatientScreen({super.key});

  @override
  ConsumerState<PatientScreen> createState() => _PatientScreenState();
}

class _PatientScreenState extends ConsumerState<PatientScreen> {
  @override
  void initState() {
    super.initState();
    _fetchPatients();
    _getUnsyncedCounselingCount();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _fetchPatients() async {
    await Future.delayed(Duration.zero);

    final patientNotifier = ref.read(localPatientsProvider.notifier);
    patientNotifier.fetchPatients();
  }

  void _getUnsyncedCounselingCount() async {
    await Future.delayed(Duration.zero);

    final counselingCountNotifier =
        ref.read(localUnsyncedCounselingsCountProvider.notifier);
    counselingCountNotifier.getNotSyncedCounselingsCount();
  }

  @override
  Widget build(BuildContext context) {
    final localState = ref.watch(localPatientsProvider);
    final countState = ref.watch(localUnsyncedCounselingsCountProvider);

    return Scaffold(
        appBar: AppBar(
          title: CustomLabelWidget(
            text: "လူနာစာရင်း",
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          backgroundColor: ColorTheme.primary,
          actions: (countState is LocalUnsyncedCounselingCountSuccessState &&
                  countState.count == 0)
              ? [
                  SyncButton(
                      isLoading: localState is LocalPatientsLoadingState,
                      onPressed: _onSync),
                ]
              : null,
        ),
        body: _patientListWidget(localState));
  }

  void _onSync() async {
    await Future.delayed(Duration.zero);
    final counselingCountNotifier =
        ref.read(localUnsyncedCounselingsCountProvider.notifier);
    counselingCountNotifier.getNotSyncedCounselingsCount();
    ref.read(localPatientsProvider.notifier).insertRemotePatients();
  }

  Widget _patientListWidget(LocalPatientsState state) {
    return _buildWidgetBasedOnState(state);
  }

  Widget _buildWidgetBasedOnState(LocalPatientsState state) {
    switch (state) {
      case LocalPatientsFailedState():
        return RefreshWhenFailedWidget(
          refresh: _fetchPatients,
          errorMessage: state.errorMessage,
        );
      case LocalPatientsLoadingState():
        return const LoadingWidget();
      case LocalPatientsSuccessState():
        return CustomListView(patients: state.localPatients);
    }
  }
}
