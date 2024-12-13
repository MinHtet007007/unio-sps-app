
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/local_database/entity/patient_package_entity.dart';
import 'package:sps/local_database/entity/receive_package_entity.dart';
import 'package:sps/local_database/entity/support_month_entity.dart';
import 'package:sps/local_database/local_database.dart';
import 'package:sps/local_database/tables/local_database_tables.dart';
import 'package:floor/floor.dart';

@dao
abstract class PatientDao {
  @Query('SELECT * FROM ${LocalDataBase.patient_table}')
  Future<List<PatientEntity>> findAllLocalPatients();

  @Query('SELECT * FROM ${LocalDataBase.patient_table} WHERE id = :id')
  Future<PatientEntity?> findLocalPatientById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMany(List<PatientEntity> patients);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertLocalPatient(PatientEntity patient);

  @Query('DELETE FROM ${LocalDataBase.patient_table}')
  Future<void> deleteAll();
}
