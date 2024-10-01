import 'package:sps/common/provider/dio/dio_provider.dart';
import 'package:sps/common/provider/local_database/local_database_provider.dart';
import 'package:sps/features/patient_list/provider/local_patients_state/local_patients_state.dart';
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/shared_api_services/patient/patient_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

class LocalPatientsProvider extends Notifier<LocalPatientsState> {
  LocalPatientsState localPatientState = LocalPatientsLoadingState();
  @override
  build() {
    return localPatientState;
  }

  late final Dio _dio = ref.read(dioProvider);

  void fetchPatients() async {
    try {
      state = LocalPatientsLoadingState();
      final database = await DatabaseProvider().database;

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
      PatientService patientService = PatientService(_dio);
      final response = await patientService.fetchRemotePatients();
      if (response.data!.isNotEmpty) {
        final database = await DatabaseProvider().database;
        final patientDao = database.patientDao;
        final counselingDao = database.counselingDao;

        final int? count = await counselingDao.getNotSyncedCounselingsCount();
        if (count! > 0) {
          state =
              LocalPatientsFailedState('Please submit counselings data first');
          return;
        }

        List<Patient> patients =
            (response.data as List).map((e) => Patient.fromMap(e)).toList();

        await counselingDao.deleteAll();
        await patientDao.deleteAllLocalPatients();
        await patientDao.insertLocalPatients(patients);

        final List<Patient> localPatients =
            await patientDao.findAllLocalPatients();
        state = LocalPatientsSuccessState(localPatients);
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
    NotifierProvider<LocalPatientsProvider, LocalPatientsState>(
        () => LocalPatientsProvider());
