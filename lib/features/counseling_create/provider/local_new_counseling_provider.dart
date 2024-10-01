import 'package:sps/common/provider/local_database/local_database_provider.dart';
import 'package:sps/features/counseling_create/provider/local_new_counseling_state/local_new_counseling_state.dart';
import 'package:sps/local_database/entity/counseling_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LocalNewCounselingProvider extends Notifier<LocalNewCounselingState> {
  LocalNewCounselingState localNewCounselingState =
      LocalNewCounselingFormState();
  @override
  build() {
    return localNewCounselingState;
  }

  void addCounseling(Counseling formData) async {
    try {
      state = LocalNewCounselingLoadingState();
      final database = await DatabaseProvider().database;

      final counselingDao = database.counselingDao;
      final id = await counselingDao.addCounseling(formData);
      if (id > 0) {
        state = LocalNewCounselingSuccessState();
        return;
      }
      state = LocalNewCounselingFailedState('Counseling Not Found');
      return;
    } catch (error) {
      state = LocalNewCounselingFailedState(error.toString());
    }
  }
}

final localNewCounselingProvider =
    NotifierProvider<LocalNewCounselingProvider, LocalNewCounselingState>(
        () => LocalNewCounselingProvider());
