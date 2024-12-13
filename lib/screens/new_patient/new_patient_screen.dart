import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sps/common/constants/form_options.dart';
import 'package:sps/common/constants/route_list.dart';
import 'package:sps/common/widgets/snack_bar_utils.dart';
import 'package:sps/features/local_patient_create/provider/local_new_patient_provider.dart';
import 'package:sps/features/local_patient_create/provider/local_new_patient_state/local_new_patient_state.dart';
import 'package:sps/features/user/provider/user_provider.dart';
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/local_database/entity/user_township_entity.dart';
import 'package:sps/screens/new_patient/widgets/new_patient_form.dart';

class NewPatientScreen extends ConsumerStatefulWidget {
  const NewPatientScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _NewPatientScreenState();
}

class _NewPatientScreenState extends ConsumerState<NewPatientScreen> {
  Future<void> onSubmit(Map<String, dynamic> formData) async {
    final patient = PatientEntity(
      year: formData['year'],
      spsStartDate: formData['spsStartDate'],
      townshipId: int.parse(formData['townshipId']),
      rrCode: formData['rrCode'],
      spCode: '',
      drtbCode: formData['drtbCode'] ?? '',
      name: formData['name'] ?? '',
      age: int.parse(formData['age']),
      sex: formData['sex'],
      diedBeforeTreatmentEnrollment: formData['diedBeforeTreatmentEnrollment'],
      treatmentStartDate: formData['treatmentStartDate'],
      treatmentRegimen: formData['treatmentRegimen'] ?? '',
      treatmentRegimenOther: formData['treatmentRegimenOther'],
      patientAddress: formData['address'],
      patientPhoneNo: formData['phone'],
      contactInfo: formData['contactInfo'],
      contactPhoneNo: formData['contactPhoneNo'],
      primaryLanguage: formData['primaryLanguage'],
      secondaryLanguage: formData['secondaryLanguage'],
      height: int.parse(formData['height']),
      weight: int.parse(formData['weight']),
      bmi: int.parse(formData['bmi']),
      currentTownshipId:
          int.parse(formData['townshipId']),
      isSynced: false,
    );

    final localPatientCreateNotifier =
        ref.read(localNewPatientProvider.notifier);
    await localPatientCreateNotifier.addPatient(patient);
  }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);

    ref.listen(localNewPatientProvider, (state, _) {
      if (state is LocalNewPatientSuccessState) {
        SnackbarUtils.showSuccessToast(context, 'Patient Create Success');
        context.pushReplacementNamed(RouteName.patient);
      }
    });

    if (userState!.townships!.isNotEmpty) {
      List<DropdownMenuItem<String>> townshipOptions =
          convertTownshipsToDropdownOptions(
              userState.townships as List<UserTownshipEntity>);

      return NewPatientForm(
        townshipOptions: townshipOptions,
        onSubmit: onSubmit,
      );
    }
    return const Center(child: Text('Cannot create patient'));
  }
}
