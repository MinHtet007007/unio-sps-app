import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sps/common/provider/local_database/local_database_provider.dart';
import 'package:sps/features/local_support_month_create/provider/local_new_support_month_state/local_new_support_month_state.dart';
import 'package:sps/local_database/entity/receive_package_entity.dart';
import 'package:sps/local_database/entity/support_month_entity.dart';

class LocalNewSupportMonthProvider
    extends StateNotifier<LocalNewSupportMonthState> {
  LocalNewSupportMonthState localNewSupportMonthState =
      LocalNewSupportMonthFormState();
  LocalDatabase localDatabase;

  LocalNewSupportMonthProvider(this.localDatabase)
      : super(LocalNewSupportMonthFormState());

  Future<void> addSupportMonth(
    SupportMonthEntity formData,
    List<ReceivePackageEntity> receivedPackages,
  ) async {
    try {
      state = LocalNewSupportMonthLoadingState();
      final database = await localDatabase.database;

      // Insert the Support Month data
      final supportMonthDao = database.supportMonthDao;
      final supportMonthId = await supportMonthDao.insertSupportMonth(formData);

      // update patient isSynced status
      final patientDao = database.patientDao;
      await patientDao.updatePatientSyncedStatus(
          formData.localPatientId, false);

      if (supportMonthId > 0) {
        // Insert the related Patient received Packages
        final receivePackageDao = database.receivePackageDao;
        final patientPackageDap = database.patientPackageDao;
        for (var package in receivedPackages) {
          await receivePackageDao.insertReceivePackage(ReceivePackageEntity(
            amount: package.amount,
            localPatientSupportMonthId: supportMonthId,
            patientPackageName: package.patientPackageName,
            reimbursementMonth: package.reimbursementMonth,
            reimbursementMonthYear: package.reimbursementMonthYear,
            localPatientPackageId: package.localPatientPackageId,
          ));
          await patientPackageDap.subtractFromRemainingAmount(
              package.localPatientPackageId!, package.amount);
        }

        state = LocalNewSupportMonthSuccessState();
        return;
      }
      state = LocalNewSupportMonthFailedState('Support Month Not Found');
      return;
    } catch (e, stackTrace) {
      print(e);
      print(stackTrace);
      state = LocalNewSupportMonthFailedState(e.toString());
    }
  }

  // Future<void> addSupportMonth(SupportMonthEntity formData) async {
  //   try {
  //     state = LocalNewSupportMonthLoadingState();
  //     final database = await localDatabase.database;
  //     final supportMonthDao = database.supportMonthDao;
  //     final id = await supportMonthDao.insertSupportMonth(formData);
  //     if (id > 0) {
  //       state = LocalNewSupportMonthSuccessState();
  //       return;
  //     }
  //     state = LocalNewSupportMonthFailedState('Support Month Not Found');
  //     return;
  //   } catch (e, stackTrace) {
  //     print(e);
  //     print(stackTrace);
  //     state = LocalNewSupportMonthFailedState(e.toString());
  //   }
  // }
}

final localNewSupportMonthProvider = StateNotifierProvider<
        LocalNewSupportMonthProvider, LocalNewSupportMonthState>(
    (ref) => LocalNewSupportMonthProvider(ref.read(localDatabaseProvider)));
