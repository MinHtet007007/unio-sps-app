import 'dart:async';
import 'package:sps/local_database/dao/patient_dao.dart';
import 'package:sps/local_database/dao/patient_package_dao.dart';
import 'package:sps/local_database/dao/receive_package_dao.dart';
import 'package:sps/local_database/dao/support_month_dao.dart';
import 'package:sps/local_database/dao/user_township_dao.dart';
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:floor/floor.dart';
import 'package:sps/local_database/entity/patient_package_entity.dart';
import 'package:sps/local_database/entity/receive_package_entity.dart';
import 'package:sps/local_database/entity/support_month_entity.dart';
import 'package:sps/local_database/entity/user_township_entity.dart';
import 'package:sps/models/remote_patient.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'local_database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [
  PatientEntity,
  SupportMonthEntity,
  ReceivePackageEntity,
  PatientPackageEntity,
  UserTownshipEntity
])
abstract class AppDatabase extends FloorDatabase {
  PatientDao get patientDao;
  SupportMonthDao get supportMonthDao;
  ReceivePackageDao get receivePackageDao;
  PatientPackageDao get patientPackageDao;
  UserTownshipDao get userTownshipDao;

  @transaction
  Future<void> resetDatabase() async {
    patientDao.deleteAll();
    patientPackageDao.deleteAll();
    supportMonthDao.deleteAll();
    receivePackageDao.deleteAll();
  }

  @transaction
  Future<void> syncPatient(Patient remotePatient) async {
    try {
      final PatientEntity patientEntity =
          PatientEntity.mapRemotePatientToLocalEntity(remotePatient);

      final int patientId = await patientDao.insertLocalPatient(patientEntity);

      final List<PatientPackageEntity> patientPackages = remotePatient
          .patientPackages
          .map((package) =>
              PatientPackageEntity.mapRemotePatientPackageToLocalEntity(
                  package, patientId))
          .toList();

      await patientPackageDao.insertMany(patientPackages);

      final List<SupportMonthEntity> supportMonths = remotePatient.supportMonths
          .map((supportMonth) =>
              SupportMonthEntity.mapRemoteSupportMonthToLocalEntity(
                  supportMonth, patientId))
          .toList();

      for (var supportMonthEntity in supportMonths) {
        final int supportMonthId =
            await supportMonthDao.insertSupportMonth(supportMonthEntity);

        List<ReceivePackageEntity> receivePackages = (remotePatient
                .supportMonths as List<dynamic>)
            .expand((supportMonth) => (supportMonth.receivePackages
                    as List<dynamic>)
                .map((receivePackage) =>
                    ReceivePackageEntity.mapRemoteReceivePackageToLocalEntity(
                        receivePackage, supportMonthId)))
            .toList();

        await receivePackageDao.insertMany(receivePackages);
      }
    } catch (e) {
      // Handle exceptions and ensure rollback
      throw Exception("Transaction failed: $e");
    }
  }
}
