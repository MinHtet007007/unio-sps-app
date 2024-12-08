import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sps/common/provider/local_database/local_database_provider.dart';
import 'package:sps/features/patient_list/provider/local_patients_state/local_patients_state.dart';
import 'package:sps/features/patient_list/provider/patient_service_provider.dart';
import 'package:sps/features/patient_list/service/patient_service.dart';
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/local_database/entity/support_month_entity.dart';

class LocalPatientsProvider extends StateNotifier<LocalPatientsState> {
  LocalPatientsState localPatientState = LocalPatientsLoadingState();
  LocalDatabase localDatabase;
  PatientService patientService;

  LocalPatientsProvider(this.localDatabase, this.patientService)
      : super(LocalPatientsLoadingState());

  Future<void> fetchPatients() async {
    try {
      state = LocalPatientsLoadingState();
      final database = await localDatabase.database;

      final patientDao = database.patientDao;
      final List<PatientEntity> patients =
          await patientDao.findAllLocalPatients();
          print(patients);
      state = LocalPatientsSuccessState(patients);
      return;
    } catch (error) {
      state = LocalPatientsFailedState(error.toString());
    }
  }
}

final localPatientsProvider =
    StateNotifierProvider<LocalPatientsProvider, LocalPatientsState>((ref) =>
        LocalPatientsProvider(
            ref.read(localDatabaseProvider), ref.read(patientServiceProvider)));
