import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/local_database/tables/local_database_tables.dart';
import 'package:floor/floor.dart';

@dao
abstract class PatientDao {
  @Query('SELECT * FROM ${LocalDataBase.patient_table}')
  Future<List<PatientEntity>> findAllLocalPatients();

  @Query('SELECT * FROM ${LocalDataBase.patient_table} WHERE isSynced = 0')
  Future<List<PatientEntity>> findUnsyncedPatients();

  @Query('SELECT * FROM ${LocalDataBase.patient_table} WHERE id = :id')
  Future<PatientEntity?> findLocalPatientById(int id);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMany(List<PatientEntity> patients);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertLocalPatient(PatientEntity patient);

  @Query('DELETE FROM ${LocalDataBase.patient_table}')
  Future<void> deleteAll();

  // @Query('''
  // SELECT 
  //       patients.*,
  //       support_months.*,
  //       receive_packages.*,
  //       patient_packages.*,
  //   FROM patients
  //   LEFT JOIN support_months ON patients.id = support_months.localPatientId
  //   LEFT JOIN receive_packages ON support_months.id = receive_packages.localPatientSupportMonthId
  //   LEFT JOIN patient_packages ON patients.id = patient_packages.localPatientId
  // WHERE 
  //   patients.isSynced = 0;
  // ''')
  // Future<List<LocalPatientsAllData>> fetchAllData();
}
