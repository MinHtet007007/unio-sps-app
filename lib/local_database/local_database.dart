import 'dart:async';
import 'dart:typed_data';
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
    userTownshipDao.deleteAllUserTownships();
  }

  @transaction
  Future<void> syncPatient(Patient remotePatient) async {
    try {
      final PatientEntity patientEntity =
          PatientEntity.mapRemotePatientToLocalEntity(remotePatient);

      final existingPatientId =
          await patientDao.findPatientByRemoteId(remotePatient.id);
      if (existingPatientId != null) {
        // Delete the existing patient and all related records
        await receivePackageDao.deleteByPatientIds([existingPatientId]);
        await supportMonthDao.deleteByPatientIds([existingPatientId]);
        await patientPackageDao.deleteByPatientIds([existingPatientId]);
        await patientDao.deletePatientsByIds([existingPatientId]);

        print(
            "Deleted existing patient with ID $existingPatientId before re-inserting.");
      }

      final int patientId = await patientDao.insertLocalPatient(patientEntity);

      final List<PatientPackageEntity> patientPackages = remotePatient
          .patientPackages
          .map((package) =>
              PatientPackageEntity.mapRemotePatientPackageToLocalEntity(
                  package, patientId))
          .toList();

      await patientPackageDao.insertMany(patientPackages);

     for (final remoteSupportMonth
          in remotePatient.supportMonths as List<dynamic>) {
        // Map the remote support month to a local entity
        final SupportMonthEntity supportMonthEntity =
            SupportMonthEntity.mapRemoteSupportMonthToLocalEntity(
                remoteSupportMonth, patientId);

        // Insert the support month and retrieve its ID
        final int supportMonthId =
            await supportMonthDao.insertSupportMonth(supportMonthEntity);

        // Map the receive packages for the current support month
        final List<dynamic> remoteReceivePackages =
            remoteSupportMonth.receivePackages as List<dynamic>? ?? [];
        final List<ReceivePackageEntity> receivePackages =
            remoteReceivePackages.map(
          (receivePackage) {
            return ReceivePackageEntity.mapRemoteReceivePackageToLocalEntity(
                receivePackage, supportMonthId);
          },
        ).toList();

        // Insert the receive packages in batch, if any
        if (receivePackages.isNotEmpty) {
          await receivePackageDao.insertMany(receivePackages);
        }
      }

    } catch (e) {
      // Handle exceptions and ensure rollback
      throw Exception("Transaction failed: $e");
    }
  }

  @transaction
  Future<bool> deleteSyncedPatients(List<int> syncedPatientIds) async {
    if (syncedPatientIds.isEmpty) {
      print("No synced IDs provided. Skipping deletion.");
      return false;
    }

    try {
      await receivePackageDao.deleteByPatientIds(syncedPatientIds);
      await supportMonthDao.deleteByPatientIds(syncedPatientIds);
      await patientPackageDao.deleteByPatientIds(syncedPatientIds);
      await patientDao.deletePatientsByIds(syncedPatientIds);

      print("Successfully deleted all synced patients and related records.");
      return true;
    } catch (e) {
      print("Error while deleting synced patients: $e");
      throw Exception("Transaction failed: $e");
    }
  }
}
