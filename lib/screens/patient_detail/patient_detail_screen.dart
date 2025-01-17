import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:sps/common/widgets/loading_widget.dart';
import 'package:sps/features/patient_details/provider/local_patient_provider.dart';
import 'package:sps/features/patient_details/provider/local_patient_state/local_patient_state.dart';
import 'package:sps/screens/patient_detail/widget/details_view.dart';
import 'package:go_router/go_router.dart';
import 'package:sps/common/constants/route_list.dart';

class PatientDetailScreen extends ConsumerStatefulWidget {
  final int patientId;
  final bool isReadOnly;
  const PatientDetailScreen(
      {super.key, required this.patientId, required this.isReadOnly});

  @override
  ConsumerState<PatientDetailScreen> createState() =>
      _PatientDetailScreenState();
}

class _PatientDetailScreenState extends ConsumerState<PatientDetailScreen> {
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
            text: "Patient Details",
            style: AppBarTextStyle,
          ),
          backgroundColor: ColorTheme.primary,
          actions: [
            if (widget.isReadOnly)
              ElevatedButton(
                onPressed: () async {
                  context
                      .push('${RouteName.packageCreate}/${widget.patientId}');
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorTheme.success,
                ),
                child: const Text(
                  'Add New Package',
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
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
        return PatientDetailsWidget(
          patient: state.localPatient,
          supportMonths: state.localSupportMonths,
          alreadyReceivedPackagesByPatientId:
              state.localReceivedPackagesByPatientId!,
          isReadOnly: widget.isReadOnly,
        );
    }
  }
}
