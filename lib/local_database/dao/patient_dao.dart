
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/local_database/tables/local_database_tables.dart';
import 'package:floor/floor.dart';

@dao
abstract class PatientDao {
  @Query('SELECT * FROM ${LocalDataBase.patient_table}')
  Future<List<Patient>> findAllLocalPatients();

  @Query('SELECT * FROM ${LocalDataBase.patient_table} WHERE id = :id')
  Future<Patient?> findLocalPatientById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertLocalPatients(List<Patient> patients);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertLocalPatient(Patient patient);

  @Query('DELETE FROM ${LocalDataBase.patient_table}')
  Future<void> deleteAllLocalPatients();
}
