import 'package:sps/common/provider/local_database/local_database_provider.dart';
import 'package:sps/features/patient_details/provider/local_patient_state/local_patient_state.dart';
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocalPatientProvider extends StateNotifier<LocalPatientState> {
  LocalPatientState localPatientState = LocalPatientLoadingState();
  LocalDatabase localDatabase;

  LocalPatientProvider(this.localDatabase) : super(LocalPatientLoadingState());

  void fetchPatient(int id) async {
    try {
      state = LocalPatientLoadingState();
      final database = await localDatabase.database;

      final patientDao = database.patientDao;
      final Patient? patient = await patientDao.findLocalPatientById(id);
      if (patient != null) {
        state = LocalPatientSuccessState(patient);
        return;
      }
      state = LocalPatientFailedState('Patient Not Found');
      return;
    } catch (error) {
      state = LocalPatientFailedState(error.toString());
    }
  }
}

final localPatientProvider =
    StateNotifierProvider<LocalPatientProvider, LocalPatientState>(
        (ref) => LocalPatientProvider(ref.read(localDatabaseProvider)));
