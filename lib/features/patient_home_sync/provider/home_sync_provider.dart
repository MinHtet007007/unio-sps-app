import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sps/common/helpers/cache.dart';
import 'package:sps/common/provider/dio/dio_provider.dart';

import 'package:sps/common/provider/local_database/local_database_provider.dart';
import 'package:sps/features/patient_home_sync/provider/home_sync_state.dart';
import 'package:sps/features/patient_home_sync/service/patient_sync_service.dart';

class HomePatientSyncProvider extends StateNotifier<HomePatientsSyncState> {
  LocalDatabase localDatabase;
  final Dio _dio;

  HomePatientSyncProvider(this.localDatabase, this._dio)
      : super(HomePatientsSyncInitialState());

  Future<void> insertRemotePatients() async {
    try {
      state = HomePatientsSyncLoadingState();
      final patientService = PatientSyncService(_dio);
      final lastSyncedTime = await Cache.getLastSyncedTime();

      final database = await localDatabase.database;

      final patientDao = database.patientDao;
      final List<int> remoteIds = await patientDao.getRemoteIds();
      final String remoteIdsAsString = remoteIds.join(',');

      final response = await patientService.fetchRemotePatients(
          alreadySyncedIds: remoteIdsAsString, last_sync_date: lastSyncedTime);
      if (response.data.isNotEmpty) {
        final database = await localDatabase.database;

        for (var patient in response.data) {
          await database.syncPatient(patient);
        }
        await Cache.saveLastSyncedTime();
      }
      if(response.hasMore) {
        state = HomePatientsSyncSuccessHasMoreState();
        return;
      }
      state = HomePatientsSyncSuccessState();
    } catch (error, stackTrace) {
      print(error);
      print("StackTrace: $stackTrace");

      state = HomePatientsSyncFailedState('Error');
    } finally {
      state = HomePatientsSyncInitialState();
    }
  }
}

final homePatientSyncProvider =
    StateNotifierProvider<HomePatientSyncProvider, HomePatientsSyncState>(
        (ref) => HomePatientSyncProvider(
            ref.read(localDatabaseProvider), ref.read(dioProvider)));
