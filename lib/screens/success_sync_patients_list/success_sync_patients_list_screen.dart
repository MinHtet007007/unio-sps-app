import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:sps/common/widgets/loading_widget.dart';
import 'package:sps/common/widgets/no_data_state.dart';
import 'package:sps/common/widgets/refresh_when_failed_widget.dart';
import 'package:sps/common/widgets/snack_bar_utils.dart';
import 'package:sps/features/local_patients_sync/provider/local_patients_sync_provider.dart';
import 'package:sps/features/local_patients_sync/state/local_patients_sync_state.dart';
import 'package:sps/features/patient_list/provider/local_patients_provider.dart';
import 'package:sps/features/patient_list/provider/local_patients_state/local_patients_state.dart';
import 'package:sps/screens/success_sync_patients_list/widget/list_view.dart';

class SuccessSyncPatientsListScreen extends ConsumerStatefulWidget {
  const SuccessSyncPatientsListScreen({super.key});

  @override
  ConsumerState<SuccessSyncPatientsListScreen> createState() =>
      _SuccessSyncPatientsListScreenState();
}

class _SuccessSyncPatientsListScreenState
    extends ConsumerState<SuccessSyncPatientsListScreen> {
  @override
  void initState() {
    super.initState();
    _fetchPatients();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _fetchPatients() async {
    await Future.delayed(Duration.zero);

    final patientNotifier = ref.read(localPatientsProvider.notifier);
    patientNotifier.fetchSyncedPatients();
  }

  void _sendLocalPatients() async {
    await Future.delayed(Duration.zero);
    ref.read(localPatientsSyncProvider.notifier).syncLocalPatients();
  }

  @override
  Widget build(BuildContext context) {
    final localState = ref.watch(localPatientsProvider);
    final localPatientsSyncState = ref.watch(localPatientsSyncProvider);
    ref.listen(localPatientsSyncProvider, (state, _) {
      if (state is LocalPatientsSyncSuccessState) {
        SnackbarUtils.showSuccessToast(context, 'Success');
        _fetchPatients();
      }
      if (state is LocalPatientsSyncFailedState) {
        SnackbarUtils.showError(context, state.errorMessage);
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: CustomLabelWidget(
          text: "Patients List",
          style: AppBarTextStyle,
        ),
        backgroundColor: ColorTheme.primary,
        iconTheme: const IconThemeData(color: ColorTheme.white),
        // actions: [
        //   SyncButton(
        //       title: "Sync (Send patient data)",
        //       isLoading:
        //           localPatientsSyncState is LocalPatientsSyncLoadingState,
        //       onPressed: _sendLocalPatients,
        //       backgroundColor: ColorTheme.success)
        // ],
      ),
      body: _patientListWidget(localState),
    );
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
        return state.localPatients.isNotEmpty
            ? CustomListView(patients: state.localPatients)
            : const NoDataStateWidget(
                message: "There is no patient data. \nPlease sync data.",
              );
    }
  }
}
