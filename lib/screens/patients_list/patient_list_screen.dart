import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sps/common/constants/route_list.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:sps/common/widgets/loading_widget.dart';
import 'package:sps/common/widgets/refresh_when_failed_widget.dart';
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

  @override
  Widget build(BuildContext context) {
    final localState = ref.watch(localPatientsProvider);

    return Scaffold(
        appBar: AppBar(
          title: CustomLabelWidget(
            text: "လူနာစာရင်း",
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          backgroundColor: ColorTheme.primary,
          actions: [
            TextButton(
                onPressed: () {
                  context.push(RouteName.patientCreate);
                },
                child: CustomLabelWidget(
                  text: 'New Patient',
                  style: const TextStyle(fontSize: 16, color: Colors.white),
                ))
          ],
        ),
        body: _patientListWidget(localState));
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
