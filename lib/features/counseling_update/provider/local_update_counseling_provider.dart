import 'package:sps/common/provider/local_database/local_database_provider.dart';
import 'package:sps/features/counseling_update/provider/local_update_counseling_state/local_update_counseling_state.dart';
import 'package:sps/local_database/entity/counseling_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocalUpdateCounselingProvider
    extends Notifier<LocalUpdateCounselingState> {
  LocalUpdateCounselingState localUpdateCounselingState =
      LocalUpdateCounselingLoadingState();
  @override
  build() {
    return localUpdateCounselingState;
  }

  void updateCounseling(Counseling formData) async {
    try {
      state = LocalUpdateCounselingLoadingState();
      final database = await DatabaseProvider().database;

      final counselingDao = database.counselingDao;
      final id = await counselingDao.updateCounseling(formData);
      if (id > 0) {
        state = LocalUpdateCounselingSuccessState(id);
        return;
      }
      state = LocalUpdateCounselingFailedState('Counseling Not Found');
      return;
    } catch (error) {
      state = LocalUpdateCounselingFailedState(error.toString());
    }
  }

  void fetchCounseling(int id) async {
    try {
      state = LocalUpdateCounselingLoadingState();
      final database = await DatabaseProvider().database;

      final counselingDao = database.counselingDao;
      final Counseling? counseling = await counselingDao.findCounselingById(id);
      if (counseling != null) {
        state = LocalCounselingFetchSuccessState(counseling);
        return;
      }
      state = LocalUpdateCounselingFailedState('Counseling Not Found');
      return;
    } catch (error) {
      state = LocalUpdateCounselingFailedState(error.toString());
    }
  }
}

final localUpdateCounselingProvider =
    NotifierProvider<LocalUpdateCounselingProvider, LocalUpdateCounselingState>(
        () => LocalUpdateCounselingProvider());
