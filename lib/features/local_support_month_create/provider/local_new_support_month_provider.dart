import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sps/common/provider/local_database/local_database_provider.dart';
import 'package:sps/features/local_support_month_create/provider/local_new_support_month_state/local_new_support_month_state.dart';
import 'package:sps/local_database/entity/receive_package_entity.dart';
import 'package:sps/local_database/entity/support_month_entity.dart';
import 'package:sps/models/received_package_request.dart';

class LocalNewSupportMonthProvider
    extends StateNotifier<LocalNewSupportMonthState> {
  final LocalDatabase localDatabase;

  LocalNewSupportMonthProvider(this.localDatabase)
      : super(LocalNewSupportMonthFormState());

  Future<void> addSupportMonth(
    SupportMonthEntity formData,
    List<ReceivedPackageRequest> receivedPackages,
  ) async {
    try {
      state = LocalNewSupportMonthLoadingState();

      // Retrieve the database instance and DAOs
      final database = await localDatabase.database;
      final supportMonthDao = database.supportMonthDao;
      final patientDao = database.patientDao;
      final receivePackageDao = database.receivePackageDao;
      final patientPackageDao = database.patientPackageDao;

      // Insert the Support Month data
      final supportMonthId = await supportMonthDao.insertSupportMonth(formData);

      if (supportMonthId <= 0) {
        state = LocalNewSupportMonthFailedState(
            'Support Month could not be created');
        return;
      }

      // Update patient's `isSynced` status
      final syncStatusFuture =
          patientDao.updatePatientSyncedStatus(formData.localPatientId, false);

      // Prepare bulk insert operations for received packages
      final receivePackageEntities = receivedPackages.map((package) {
        return ReceivePackageEntity(
          id: null, // Ensure the ID is auto-generated
          amount: package.amount,
          localPatientSupportMonthId: supportMonthId,
          patientPackageName: package.patientPackageName,
          reimbursementMonth: package.reimbursementMonth,
          reimbursementMonthYear: package.reimbursementMonthYear,
          localPatientPackageId: package.localPatientPackageId,
        );
      }).toList();

      final insertPackagesFuture = receivePackageDao.insertMany(
        receivePackageEntities,
      );

      // Prepare bulk update operations for subtracting package amounts
      final updateAmountsFutures = receivedPackages
          .where(
        (package) => package.localPatientPackageId != null && package.patientPackageName != "Package 8",
      )
          .map((package) {
        return patientPackageDao.subtractFromRemainingAmount(
          package.localPatientPackageId!,
          package.amount,
        );
      });

      // Execute bulk insert and updates in parallel
      await Future.wait([
        syncStatusFuture,
        insertPackagesFuture,
        ...updateAmountsFutures,
      ]);

      // Update state to success
      state = LocalNewSupportMonthSuccessState();
    } catch (e, stackTrace) {
      // Handle exceptions and update state to failure
      print('Error: $e\nStackTrace: $stackTrace');
      state = LocalNewSupportMonthFailedState(e.toString());
    }
  }
}

final localNewSupportMonthProvider = StateNotifierProvider<
    LocalNewSupportMonthProvider, LocalNewSupportMonthState>(
  (ref) => LocalNewSupportMonthProvider(ref.read(localDatabaseProvider)),
);
