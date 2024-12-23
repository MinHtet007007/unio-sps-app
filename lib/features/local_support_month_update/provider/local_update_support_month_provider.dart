

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sps/common/provider/local_database/local_database_provider.dart';
import 'package:sps/features/local_support_month_update/provider/local_update_support_month_state/local_update_support_month_state.dart';
import 'package:sps/local_database/entity/receive_package_entity.dart';
import 'package:sps/local_database/entity/support_month_entity.dart';
import 'package:sps/models/received_package_request.dart';

class LocalUpdateSupportMonthProvider
    extends StateNotifier<LocalUpdateSupportMonthState> {
  final LocalDatabase localDatabase;

  LocalUpdateSupportMonthProvider(this.localDatabase)
      : super(LocalUpdateSupportMonthFormState());

Future<void> updateSupportMonth(
    SupportMonthEntity updatedFormData,
    List<ReceivedPackageRequest> updatedReceivedPackages,
  ) async {
    try {
      state = LocalUpdateSupportMonthLoadingState();

      // Retrieve the database instance
      final database = await localDatabase.database;
      final supportMonthDao = database.supportMonthDao;
      final patientDao = database.patientDao;
      final receivePackageDao = database.receivePackageDao;
      final patientPackageDao = database.patientPackageDao;

      // Update the Support Month data
      final rowsAffected =
          await supportMonthDao.updateSupportMonth(updatedFormData);

      if (rowsAffected == 0) {
        // Handle case where no rows were updated
        state = LocalUpdateSupportMonthFailedState(
            'Support Month could not be updated');
        return;
      }

      // Update patient's `isSynced` status
      final syncStatusFuture = patientDao.updatePatientSyncedStatus(
        updatedFormData.localPatientId,
        false,
      );

      // Retrieve and restore old packages in parallel
      final oldReceivePackages = await receivePackageDao
          .getPackagesBySupportMonthId(updatedFormData.id!);

      final restoreAmountsFutures = oldReceivePackages
          .where((pkg) => pkg.localPatientPackageId != null)
          .map((pkg) => patientPackageDao.addToRemainingAmount(
                pkg.localPatientPackageId!,
                pkg.amount,
              ));

      await Future.wait(restoreAmountsFutures);

      // Delete old packages for this support month
      final deleteOldPackagesFuture =
          receivePackageDao.deletePackagesBySupportMonthId(updatedFormData.id!);

      // Insert updated received packages and adjust their amounts
      final insertAndDeductFutures =
          updatedReceivedPackages.map((package) async {
        await receivePackageDao.insertReceivePackage(
          ReceivePackageEntity(
            id: null, // Ensure the ID is auto-generated
            amount: package.amount,
            localPatientSupportMonthId: updatedFormData.id!,
            patientPackageName: package.patientPackageName,
            reimbursementMonth: package.reimbursementMonth,
            reimbursementMonthYear: package.reimbursementMonthYear,
            localPatientPackageId: package.localPatientPackageId,
          ),
        );

        if (package.localPatientPackageId != null) {
          await patientPackageDao.subtractFromRemainingAmount(
            package.localPatientPackageId!,
            package.amount,
          );
        }
      });

      // Wait for all insertions and adjustments to complete
      await Future.wait([
        deleteOldPackagesFuture,
        ...insertAndDeductFutures,
        syncStatusFuture,
      ]);

      // Update state to success
      state = LocalUpdateSupportMonthSuccessState();
    } catch (e, stackTrace) {
      // Handle exceptions and update state to failure
      print('Error: $e\nStackTrace: $stackTrace');
      state = LocalUpdateSupportMonthFailedState(e.toString());
    }
  }

}

final localUpdateSupportMonthProvider = StateNotifierProvider<
    LocalUpdateSupportMonthProvider, LocalUpdateSupportMonthState>(
  (ref) => LocalUpdateSupportMonthProvider(ref.read(localDatabaseProvider)),
);
