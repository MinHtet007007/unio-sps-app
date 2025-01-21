import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sps/common/constants/form_options.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/error_screen.dart';
import 'package:sps/common/widgets/loading_widget.dart';
import 'package:sps/common/widgets/snack_bar_utils.dart';
import 'package:sps/features/local_patient_edit/provider/local_edit_patient_provider.dart';
import 'package:sps/features/local_patient_edit/provider/local_edit_patient_state/local_edit_patient_state.dart';
import 'package:sps/features/patient_details/provider/local_patient_provider.dart';
import 'package:sps/features/patient_details/provider/local_patient_state/local_patient_state.dart';
import 'package:sps/features/user/provider/user_provider.dart';
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/local_database/entity/user_township_entity.dart';
import 'package:sps/screens/edit_patient/widget/edit_patient_form.dart';

import '../../common/widgets/custom_label_widget.dart';

class EditPatientScreen extends ConsumerStatefulWidget {
  final int patientId; // Pass patient ID to fetch the data.
  const EditPatientScreen({super.key, required this.patientId});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _EditPatientScreenState();
}

class _EditPatientScreenState extends ConsumerState<EditPatientScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch patient data when screen initializes
    _fetchPatient();
  }

  void _fetchPatient() async {
    await Future.delayed(Duration.zero);

    final patientNotifier = ref.read(localPatientProvider.notifier);
    patientNotifier.fetchPatient(widget.patientId);
  }

  Future<void> onSubmit(Map<String, dynamic> formData) async {
    try {
      final updatedPatient = PatientEntity(
        id: widget.patientId, // Use the existing patient ID
        year: formData['year']?.toString() ?? '',
        spsStartDate: formData['spsStartDate']?.toString() ?? '',
        townshipId:
            int.tryParse(formData['townshipId']?.toString() ?? '0') ?? 0,
        rrCode: formData['rrCode']?.toString() ?? '',
        drtbCode: formData['drtbCode']?.toString() ?? '',
        name: formData['name']?.toString() ?? '',
        age: int.tryParse(formData['age']?.toString() ?? '0') ?? 0,
        sex: formData['sex']?.toString() ?? '',
        diedBeforeTreatmentEnrollment:
            formData['diedBeforeTreatmentEnrollment']?.toString() ?? '',
        treatmentStartDate: formData['treatmentStartDate']?.toString() ?? '',
        treatmentRegimen: formData['treatmentRegimen']?.toString() ?? '',
        treatmentRegimenOther:
            formData['treatmentRegimenOther']?.toString() ?? '',
        patientAddress: formData['address']?.toString() ?? '',
        patientPhoneNo: formData['phone']?.toString() ?? '',
        contactInfo: formData['contactInfo']?.toString() ?? '',
        contactPhoneNo: formData['contactPhone']?.toString() ?? '',
        primaryLanguage: formData['primaryLanguage']?.toString() ?? '',
        secondaryLanguage: formData['secondaryLanguage']?.toString() ?? '',
        height: int.tryParse(formData['height']?.toString() ?? '0') ?? 0,
        weight: int.tryParse(formData['weight']?.toString() ?? '0') ?? 0,
        bmi: int.tryParse(formData['bmi']?.toString() ?? '0') ?? 0,
        currentTownshipId:
            int.tryParse(formData['townshipId']?.toString() ?? '0') ?? 0,
        isSynced: false,
      );

      final localPatientEditNotifier =
          ref.read(localEditPatientProvider.notifier);
      await localPatientEditNotifier.updatePatient(updatedPatient);
    } catch (e, stackTrace) {
      print('Error $e');
      print('stackTrace $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    final localState = ref.watch(localPatientProvider);
    final userState = ref.watch(userProvider);

    ref.listen(localEditPatientProvider, (state, _) {
      if (state is LocalEditPatientSuccessState) {
        SnackbarUtils.showSuccessToast(context, 'Patient Edit Success');
        context.pop();
      }
      if (state is LocalEditPatientFailedState) {
        SnackbarUtils.showError(context, 'Patient Cannot be Updated');
      }
    });

    if (userState?.townships?.isNotEmpty ?? false) {
      List<DropdownMenuItem<String>> townshipOptions =
          convertTownshipsToDropdownOptions(
              userState!.townships as List<UserTownshipEntity>);

      return Scaffold(
          appBar: AppBar(
            title: CustomLabelWidget(
              text: "Patient Details",
              style: AppBarTextStyle,
            ),
            backgroundColor: ColorTheme.primary,
          ),
          body: _buildWidgetBasedOnState(localState, townshipOptions));
    }

    return const ErrorScreen(
        title: 'Create Patient', message: 'Cannot Create Patient');
  }

  Widget _buildWidgetBasedOnState(
      LocalPatientState state, List<DropdownMenuItem<String>> townshipOptions) {
    switch (state) {
      case LocalPatientFailedState():
        return const Text("Failed");
      case LocalPatientLoadingState():
        return const LoadingWidget();
      case LocalPatientSuccessState():
        return EditPatientForm(
          onSubmit: onSubmit,
          townshipOptions: townshipOptions,
          patient: state.localPatient,
        );
    }
  }
}
