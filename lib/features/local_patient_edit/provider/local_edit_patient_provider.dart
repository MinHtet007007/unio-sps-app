import 'package:sps/common/provider/local_database/local_database_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sps/features/local_patient_edit/provider/local_edit_patient_state/local_edit_patient_state.dart';
import 'package:sps/local_database/entity/patient_entity.dart';

class LocalEditPatientProvider extends StateNotifier<LocalEditPatientState> {
  final LocalDatabase localDatabase;

  LocalEditPatientProvider(this.localDatabase)
      : super(LocalEditPatientInitialState());

  Future<void> updatePatient(PatientEntity formData) async {
    try {
      state = LocalEditPatientLoadingState();
      final database = await localDatabase.database;

      final patientDao = database.patientDao;
      final supportMonthDao = database.supportMonthDao;
      final rowsUpdated = await patientDao.updatePatient(formData);
      if (rowsUpdated > 0) {
        await supportMonthDao
            .updateSupportMonthTownshipIdByPatientIdAndIsSyncedStatus(
                formData.id!, formData.townshipId);
        state = LocalEditPatientSuccessState();
      } else {
        state = LocalEditPatientFailedState('Patient Not Found');
      }
    } catch (error, stackTrace) {
      print('Error: $error');
      print('StackTrace: $stackTrace');
      state = LocalEditPatientFailedState(error.toString());
    }
  }
}

final localEditPatientProvider =
    StateNotifierProvider<LocalEditPatientProvider, LocalEditPatientState>(
        (ref) => LocalEditPatientProvider(ref.read(localDatabaseProvider)));
