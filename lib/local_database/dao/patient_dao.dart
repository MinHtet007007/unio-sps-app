import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/local_database/tables/local_database_tables.dart';
import 'package:floor/floor.dart';

@dao
abstract class PatientDao {
  @Query('SELECT * FROM ${LocalDataBase.patient_table}')
  Future<List<PatientEntity>> findAllLocalPatients();

  @Query('SELECT * FROM ${LocalDataBase.patient_table}  WHERE isSynced = 1')
  Future<List<PatientEntity>> findAllSyncedLocalPatients();

  @Query('SELECT * FROM ${LocalDataBase.patient_table}  WHERE isSynced = 0')
  Future<List<PatientEntity>> findAllUnSyncedLocalPatients();

  @Update(onConflict: OnConflictStrategy.replace)
  Future<int> updatePatient(PatientEntity patient);

  @Query(
      'SELECT remoteId FROM ${LocalDataBase.patient_table} WHERE remoteId IS NOT NULL')
  Future<List<int>> getRemoteIds();

  @Query(
      'SELECT * FROM ${LocalDataBase.patient_table} WHERE isSynced = 0 LIMIT 5')
  Future<List<PatientEntity>> findUnsyncedPatients();

  @Query('SELECT * FROM ${LocalDataBase.patient_table} WHERE id = :id')
  Future<PatientEntity?> findLocalPatientById(int id);

  @Query('SELECT id FROM ${LocalDataBase.patient_table} WHERE remoteId = :id')
  Future<int?> findPatientByRemoteId(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMany(List<PatientEntity> patients);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertLocalPatient(PatientEntity patient);

  @Query('DELETE FROM ${LocalDataBase.patient_table}')
  Future<void> deleteAll();

  @Query('DELETE FROM ${LocalDataBase.patient_table} '
      'WHERE id IN (:patientIds)')
  Future<void> deletePatientsByIds(List<int> patientIds);

  @Query(
      'UPDATE ${LocalDataBase.patient_table} SET isSynced = :isSynced WHERE id = :id')
  Future<void> updatePatientSyncedStatus(int id, bool isSynced);
}
