import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:sps/common/widgets/loading_widget.dart';
import 'package:sps/features/patient_details/provider/local_patient_state/local_patient_state.dart';
import 'package:sps/features/patient_details/provider/local_patient_provider.dart';
import 'package:sps/features/patient_details/ui/screen/widget/details_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PatientDetailsScreen extends ConsumerStatefulWidget {
  final int patientId;
  const PatientDetailsScreen({super.key, required this.patientId});

  @override
  ConsumerState<PatientDetailsScreen> createState() =>
      _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends ConsumerState<PatientDetailsScreen> {
  @override
  @override
  void initState() {
    super.initState();
    _fetchPatient();
  }

  void _fetchPatient() async {
    await Future.delayed(Duration.zero);

    final patientNotifier = ref.read(localPatientProvider.notifier);
    patientNotifier.fetchPatient(widget.patientId);
  }

  @override
  Widget build(BuildContext context) {
    final localState = ref.watch(localPatientProvider);

    return Scaffold(
        appBar: AppBar(
          title: CustomLabelWidget(
            text: "လူနာ အချက်အလက်",
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          backgroundColor: ColorTheme.primary,
        ),
        body: _patientListWidget(localState));
  }

  Widget _patientListWidget(LocalPatientState state) {
    return _buildWidgetBasedOnState(state);
  }

  Widget _buildWidgetBasedOnState(LocalPatientState state) {
    switch (state) {
      case LocalPatientFailedState():
        return const Text("Failed");
      case LocalPatientLoadingState():
        return const LoadingWidget();
      case LocalPatientSuccessState():
        return PatientDetailsWidget(patient: state.localPatient);
    }
  }
}
