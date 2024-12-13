// import 'dart:nativewrappers/_internal/vm/lib/core_patch.dart';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:sps/common/widgets/loading_widget.dart';
import 'package:sps/features/patient_details/provider/local_patient_provider.dart';
import 'package:sps/features/patient_details/provider/local_patient_state/local_patient_state.dart';
import 'package:sps/screens/add_new_package/widget/add_new_package_form.dart';

class AddNewPackageScreen extends ConsumerStatefulWidget {
  final int patientId;
  const AddNewPackageScreen({super.key, required this.patientId});

  @override
  ConsumerState<AddNewPackageScreen> createState() =>
      _AddNewPackageScreenState();
}

class _AddNewPackageScreenState extends ConsumerState<AddNewPackageScreen> {
  void _fetchPatient() async {
    await Future.delayed(Duration.zero);

    final patientNotifier = ref.read(localPatientProvider.notifier);
    patientNotifier.fetchPatient(widget.patientId);
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _fetchPatient();
  }

  @override
  Widget build(BuildContext context) {
    final localState = ref.watch(localPatientProvider);
    // final support_months = localState is LocalPatientSuccessState
    //     ? localState.localSupportMonths
    //     : [];
    // final PatientEntity? patientDetails =
    //     localState is LocalPatientSuccessState ? localState.localPatient : null;
    // final List<PatientPackageEntity>? patientPackages =
    //     localState is LocalPatientSuccessState
    //         ? localState.localPatientPackages
    //         : null;
    // // final options = patientPackages
    // //     ?.map(
    // //       (p) => {'value': p, "label": p.packageName},
    // //     )
    // //     .toList();
    // final List<String> options = localState is LocalPatientSuccessState
    //     ? patientPackages!.map((p) => p.packageName).toList()
    //     : [];

    // if (localState is LocalPatientSuccessState) {
    //   final supportMonths = localState.localPatientPackages;
    //   for (var month in supportMonths) {
    //     debugPrint(month.eligibleAmount.toString());
    //   }
    //   // debugPrint(supportMonths.length.toString());
    // }

    return Scaffold(
      appBar: AppBar(
        title: CustomLabelWidget(
          text: "Create Package",
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: ColorTheme.primary,
      ),
      body: _buildWidgetBasedOnState(localState),
    );
  }

  Widget _buildWidgetBasedOnState(LocalPatientState state) {
    switch (state) {
      case LocalPatientFailedState():
        return const Text("Failed");
      case LocalPatientLoadingState():
        return const LoadingWidget();
      case LocalPatientSuccessState():
        return AddNewPackageForm(
            patientDetails: state.localPatient,
            patientPackages: state.localPatientPackages,
            patientSupportMonths: state.localSupportMonths);
    }
  }
}
