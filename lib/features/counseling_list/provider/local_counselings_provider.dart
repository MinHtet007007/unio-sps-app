import 'package:sps/common/provider/dio/dio_provider.dart';
import 'package:sps/common/provider/local_database/local_database_provider.dart';
import 'package:sps/features/auth/data/model/counseling_sync_request.dart';
import 'package:sps/features/counseling_list/provider/local_counselings_state/local_counselings_state.dart';
import 'package:sps/local_database/entity/counseling_entity.dart';
import 'package:sps/shared_api_services/counseling/counseling_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

class LocalCounselingsProvider extends Notifier<LocalCounselingsState> {
  LocalCounselingsState localCounselingstate = LocalCounselingsLoadingState();
  @override
  build() {
    return localCounselingstate;
  }

  late final Dio _dio = ref.read(dioProvider);

  void fetchCounselings(int patientId) async {
    try {
      state = LocalCounselingsLoadingState();
      final database = await DatabaseProvider().database;

      final counselingDao = database.counselingDao;
      final List<Counseling> counselings =
          await counselingDao.findAll(patientId);
      state = LocalCounselingsSuccessState(counselings);
      return;
    } catch (error) {
      state = LocalCounselingsFailedState(error.toString());
    }
  }

  void deleteCounseling(Counseling counseling) async {
    try {
      state = LocalCounselingsLoadingState();
      final database = await DatabaseProvider().database;

      final counselingDao = database.counselingDao;
      final int deletedId = await counselingDao.deleteCounseling(counseling);
      if (deletedId > 0) {
        final List<Counseling> counselings =
            await counselingDao.findAll(counseling.patientId);
        state = LocalCounselingsSuccessState(counselings);
        return;
      }
      return;
    } catch (error) {
      state = LocalCounselingsFailedState(error.toString());
    }
  }

  void syncLocalCounselings(int patientId) async {
    try {
      state = LocalCounselingsLoadingState();

      final database = await DatabaseProvider().database;

      final counselingDao = database.counselingDao;
      final List<Counseling> unsyncedCounselings =
          await counselingDao.findNotSyncedCounselings(patientId);
      // if (unsyncedCounselings.isEmpty) {
      //   state = LocalCounselingsFailedState('No Data To Upload!');
      //   return;
      // }
      final List<Map<String, dynamic>> counselingData =
          unsyncedCounselings.map((counseling) {
        return {
          'dots_patient_id': counseling.patientId,
          'phase': counseling.phase,
          'type': counseling.type,
          'date': counseling.date,
        };
      }).toList();

      CounselingService counselingService = CounselingService(_dio);
      final response = await counselingService.syncCounselings(
          CounselingSyncRequest(
              counselingData: counselingData, dotsPatientId: patientId));
      if (response.data!.isNotEmpty) {
        final database = await DatabaseProvider().database;
        final patientDao = database.patientDao;

        List<Counseling> counselings =
            (response.data as List).map((e) => Counseling.fromMap(e)).toList();

        await counselingDao.deleteAll();
        await counselingDao.insertAll(counselings);

        final List<Counseling> localCounselings =
            await counselingDao.findAll(patientId);
        state = LocalCounselingsSuccessState(localCounselings);
        return;
      } else {
        state = LocalCounselingsFailedState('No New Counselings Data');
      }
      return;
    } catch (error) {
      print(error);
      state = LocalCounselingsFailedState(error.toString());
    }
  }
}

final localCounselingsProvider =
    NotifierProvider<LocalCounselingsProvider, LocalCounselingsState>(
        () => LocalCounselingsProvider());
