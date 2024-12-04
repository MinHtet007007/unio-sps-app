import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:sps/common/provider/local_database/local_database_provider.dart';
import 'package:sps/features/patient_list/provider/local_patients_state/local_patients_state.dart';
import 'package:sps/features/patient_list/provider/patient_service_provider.dart';
import 'package:sps/features/patient_list/service/patient_service.dart';
import 'package:sps/local_database/entity/patient_entity.dart';

class LocalPatientsProvider extends StateNotifier<LocalPatientsState> {
  LocalPatientsState localPatientState = LocalPatientsLoadingState();
  LocalDatabase localDatabase;
  PatientService patientService;

  LocalPatientsProvider(this.localDatabase, this.patientService)
      : super(LocalPatientsLoadingState());

  void fetchPatients() async {
    try {
      state = LocalPatientsLoadingState();
      final database = await localDatabase.database;

      final patientDao = database.patientDao;
      final List<Patient> patients = await patientDao.findAllLocalPatients();
      state = LocalPatientsSuccessState(patients);
      return;
    } catch (error) {
      state = LocalPatientsFailedState(error.toString());
    }
  }

  void insertRemotePatients() async {
    try {
      state = LocalPatientsLoadingState();
      // PatientService patientService = PatientService(_dio);
      final response = await patientService.fetchRemotePatients();
      if (response.data!.isNotEmpty) {
        final database = await localDatabase.database;

        // final int? count = await counselingDao.getNotSyncedCounselingsCount();
        // if (count! > 0) {
        //   state =
        //       LocalPatientsFailedState('Please submit counselings data first');
        //   return;
        // }

        // List<Patient> patients =
        //     (response.data as List).map((e) => Patient.fromMap(e)).toList();

        // await counselingDao.deleteAll();
        // await patientDao.deleteAllLocalPatients();
        // await patientDao.insertLocalPatients(patients);

        // final List<Patient> localPatients =
        //     await patientDao.findAllLocalPatients();
        // state = LocalPatientsSuccessState(localPatients);
        return;
      } else {
        state =
            LocalPatientsFailedState('There is no patients assigned to you');
      }
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
