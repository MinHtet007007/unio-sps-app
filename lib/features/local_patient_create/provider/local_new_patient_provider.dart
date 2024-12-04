import 'package:sps/common/provider/local_database/local_database_provider.dart';
import 'package:sps/features/local_patient_create/provider/local_new_patient_state/local_new_patient_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sps/local_database/entity/patient_entity.dart';

class LocalNewPatientProvider extends StateNotifier<LocalNewPatientState> {
  LocalNewPatientState localNewPatientState =
      LocalNewPatientFormState();
  LocalDatabase localDatabase;

  LocalNewPatientProvider(this.localDatabase)
      : super(LocalNewPatientFormState());
  void addPatient(Patient formData) async {
    try {
      state = LocalNewPatientLoadingState();
      final database = await localDatabase.database;

      final patientDao = database.patientDao;
      final id = await patientDao.insertLocalPatient(formData);
      if (id > 0) {
        state = LocalNewPatientSuccessState();
        return;
      }
      state = LocalNewPatientFailedState('Patient Not Found');
      return;
    } catch (error) {
      state = LocalNewPatientFailedState(error.toString());
    }
  }
}

final localNewPatientProvider =
    StateNotifierProvider<LocalNewPatientProvider, LocalNewPatientState>(
        (ref) => LocalNewPatientProvider(ref.read(localDatabaseProvider)));
