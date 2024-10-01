import 'package:sps/common/provider/dio/dio_provider.dart';
import 'package:sps/common/provider/local_database/local_database_provider.dart';
import 'package:sps/features/patient_list/provider/local_unsynced_counselings_count_state/local_unsynced_counseling_count_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

class LocalUnsyncedCounselingsCountProvider
    extends Notifier<LocalUnsyncedCounselingCountState> {
  LocalUnsyncedCounselingCountState countState =
      LocalUnsyncedCounselingCountLoadingState();
  @override
  build() {
    return countState;
  }

  late final Dio _dio = ref.read(dioProvider);

  void getNotSyncedCounselingsCount() async {
    try {
      final database = await DatabaseProvider().database;
      final counselingDao = database.counselingDao;
      final int? count = await counselingDao.getNotSyncedCounselingsCount();
      if (count! > 0) {
        state = LocalUnsyncedCounselingCountSuccessState(count);
      } else {
        state = LocalUnsyncedCounselingCountSuccessState(0);
      }
      return;
    } catch (error) {
      state = LocalUnsyncedCounselingCountFailedState(error.toString());
    }
  }
}

final localUnsyncedCounselingsCountProvider = NotifierProvider<
        LocalUnsyncedCounselingsCountProvider,
        LocalUnsyncedCounselingCountState>(
    () => LocalUnsyncedCounselingsCountProvider());
