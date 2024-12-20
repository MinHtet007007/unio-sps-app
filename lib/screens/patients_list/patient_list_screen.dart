import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sps/common/constants/route_list.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:sps/common/widgets/loading_widget.dart';
import 'package:sps/common/widgets/refresh_when_failed_widget.dart';
import 'package:sps/common/widgets/snack_bar_utils.dart';
import 'package:sps/common/widgets/sync_button.dart';
import 'package:sps/features/local_patients_sync/provider/local_patients_sync_provider.dart';
import 'package:sps/features/local_patients_sync/state/local_patients_sync_state.dart';
import 'package:sps/features/patient_list/provider/local_patients_provider.dart';
import 'package:sps/features/patient_list/provider/local_patients_state/local_patients_state.dart';
import 'package:sps/screens/patients_list/widget/list_view.dart';

class PatientListScreen extends ConsumerStatefulWidget {
  const PatientListScreen({super.key});

  @override
  ConsumerState<PatientListScreen> createState() => _PatientListScreenState();
}

class _PatientListScreenState extends ConsumerState<PatientListScreen> {
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
    patientNotifier.fetchPatients();
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
        SnackbarUtils.showSuccessToast(
            context, 'လူနာငါးယောက်ဒေတာများ ပို့ပြီးပါပြီ');
        _fetchPatients();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: CustomLabelWidget(
          text: "လူနာစာရင်း",
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: ColorTheme.primary,
        actions: [
          SyncButton(
              title: "local data ပို့မည်",
              isLoading:
                  localPatientsSyncState is LocalPatientsSyncLoadingState,
              onPressed: _sendLocalPatients)
        ],
      ),
      body: _patientListWidget(localState),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          context.push(RouteName.patientCreate);
        },
        backgroundColor: Colors.blue, // Icon to display
        tooltip: 'Add', // Button color
        child: const Icon(Icons.add),
      ),
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
        return CustomListView(patients: state.localPatients);
    }
  }
}
