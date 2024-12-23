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

      // Retrieve the database instance
      final database = await localDatabase.database;

      // Insert the Support Month data
      final supportMonthDao = database.supportMonthDao;
      final supportMonthId = await supportMonthDao.insertSupportMonth(formData);

      // Update patient's `isSynced` status
      final patientDao = database.patientDao;
      await patientDao.updatePatientSyncedStatus(
          formData.localPatientId, false);

      if (supportMonthId > 0) {
        // Insert related Patient Received Packages and update their amounts
        final receivePackageDao = database.receivePackageDao;
        final patientPackageDao = database.patientPackageDao;

        for (var package in receivedPackages) {
          await receivePackageDao.insertReceivePackage(
            ReceivePackageEntity(
              id: null, // Ensure the ID is auto-generated
              amount: package.amount,
              localPatientSupportMonthId: supportMonthId,
              patientPackageName: package.patientPackageName,
              reimbursementMonth: package.reimbursementMonth,
              reimbursementMonthYear: package.reimbursementMonthYear,
              localPatientPackageId: package.localPatientPackageId,
            ),
          );

          // Subtract from the remaining amount in the patient's package
          if (package.localPatientPackageId != null) {
            await patientPackageDao.subtractFromRemainingAmount(
              package.localPatientPackageId!,
              package.amount,
            );
          }
        }

        // Update state to success
        state = LocalNewSupportMonthSuccessState();
        return;
      }

      // Handle case where supportMonthId is not valid
      state =
          LocalNewSupportMonthFailedState('Support Month could not be created');
    } catch (e, stackTrace) {
      // Handle exceptions and update state to failure
      print('Error: $e');
      print('StackTrace: $stackTrace');
      state = LocalNewSupportMonthFailedState(e.toString());
    }
  }
}

final localNewSupportMonthProvider = StateNotifierProvider<
    LocalNewSupportMonthProvider, LocalNewSupportMonthState>(
  (ref) => LocalNewSupportMonthProvider(ref.read(localDatabaseProvider)),
);
