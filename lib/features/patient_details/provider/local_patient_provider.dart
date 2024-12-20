import 'package:sps/common/provider/local_database/local_database_provider.dart';
import 'package:sps/features/patient_details/provider/local_patient_state/local_patient_state.dart';
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sps/local_database/entity/patient_package_entity.dart';
import 'package:sps/local_database/entity/receive_package_entity.dart';
import 'package:sps/local_database/entity/support_month_entity.dart';

class LocalPatientProvider extends StateNotifier<LocalPatientState> {
  LocalPatientState localPatientState = LocalPatientLoadingState();
  LocalDatabase localDatabase;

  LocalPatientProvider(this.localDatabase) : super(LocalPatientLoadingState());

  void fetchPatient(int id, {int? supportMonthId}) async {
    try {
      state = LocalPatientLoadingState();
      final database = await localDatabase.database;

      final patientDao = database.patientDao;
      final supportMonthDao = database.supportMonthDao;
      final patientPackageDao = database.patientPackageDao;
      final receivePackageDao = database.receivePackageDao;
      final PatientEntity? patient = await patientDao.findLocalPatientById(id);
      List<SupportMonthEntity> supportMonths =
          await supportMonthDao.getSupportMonthsByLocalPatientId(id);

      SupportMonthEntity? supportMonth;
      List<ReceivePackageEntity>? receivedPackages;

      if (supportMonthId != null) {
        // handle supportMonthId logic here if needed
        supportMonth =
            await supportMonthDao.getSupportMonthById(supportMonthId);
        receivedPackages = await receivePackageDao
            .getReceivePackagesBySupportMonth(supportMonthId);
      }

      final List<PatientPackageEntity> patientPackages =
          await patientPackageDao.getPatientPackagesByPatientId(id);
      if (patient != null) {
        state = LocalPatientSuccessState(patient, supportMonths,
            patientPackages, supportMonth, receivedPackages);
        return;
      }
      state = LocalPatientFailedState('Patient Not Found');
      return;
    } catch (error) {
      state = LocalPatientFailedState(error.toString());
    }
  }
}

final localPatientProvider =
    StateNotifierProvider<LocalPatientProvider, LocalPatientState>(
        (ref) => LocalPatientProvider(ref.read(localDatabaseProvider)));
