import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sps/common/constants/form_options.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/error_screen.dart';
import 'package:sps/common/widgets/snack_bar_utils.dart';
import 'package:sps/features/local_patient_create/provider/local_new_patient_provider.dart';
import 'package:sps/features/local_patient_create/provider/local_new_patient_state/local_new_patient_state.dart';
import 'package:sps/features/user/provider/user_provider.dart';
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/local_database/entity/user_township_entity.dart';
import 'package:sps/screens/new_patient/widgets/new_patient_form.dart';

import '../../common/widgets/custom_label_widget.dart';

class NewPatientScreen extends ConsumerStatefulWidget {
  const NewPatientScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewPatientScreenState();
}

class _NewPatientScreenState extends ConsumerState<NewPatientScreen> {
  Future<void> onSubmit(Map<String, dynamic> formData) async {
    try {
      final patient = PatientEntity(
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
        height: formData['height'] ?? 0,
        weight: formData['weight'] ?? 0,
        bmi: formData['bmi'] ?? 0,
        currentTownshipId:
            int.tryParse(formData['townshipId']?.toString() ?? '0') ?? 0,
        isSynced: false,
      );

      final localPatientCreateNotifier =
          ref.read(localNewPatientProvider.notifier);
      await localPatientCreateNotifier.addPatient(patient);
    } catch (e, stackTrace) {
      print('Error $e');
      print('stackTrace $stackTrace');
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);
    final localNewPatientState = ref.watch(localNewPatientProvider);

    ref.listen(localNewPatientProvider, (state, _) {
      if (state is LocalNewPatientSuccessState) {
        SnackbarUtils.showSuccessToast(context, 'Patient Create Success');
        // Future.delayed(Duration(seconds: 2), () {
        //   context.pop();
        // });
      }
      if (state is LocalNewPatientFailedState) {
        SnackbarUtils.showError(context, 'Patient Cannot be Created');
      }
    });

    if (userState!.townships!.isNotEmpty) {
      List<DropdownMenuItem<String>> townshipOptions =
          convertTownshipsToDropdownOptions(
              userState.townships as List<UserTownshipEntity>);

      return Scaffold(
        appBar: AppBar(
          title: CustomLabelWidget(
            text: 'New Patient',
            style: AppBarTextStyle,
          ),
          backgroundColor: ColorTheme.primary,
          elevation: 0,
          iconTheme: const IconThemeData(color: ColorTheme.white),
        ),
        body: localNewPatientState is LocalNewPatientLoadingState
            ? const Center(child: CircularProgressIndicator())
            : NewPatientForm(
                townshipOptions: townshipOptions,
                onSubmit: onSubmit,
              ),
      );
    }
    return const ErrorScreen(
        title: 'Create Patient', message: 'Cannot Create Patient');
  }
}
