import 'package:floor/floor.dart';
import 'package:sps/local_database/entity/patient_package_entity.dart';
import 'package:sps/local_database/tables/local_database_tables.dart';

@dao
abstract class PatientPackageDao {
  @Query('SELECT * FROM ${LocalDataBase.patient_package_table}')
  Future<List<PatientPackageEntity>> getAllPatientPackages();

  @Query('SELECT * FROM ${LocalDataBase.patient_package_table} WHERE localPatientId = :patientId')
  Future<List<PatientPackageEntity>> getPatientPackagesByPatientId(
      int patientId);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertPatientPackage(PatientPackageEntity patientPackage);

  @Query('DELETE FROM ${LocalDataBase.patient_package_table} WHERE id = :id')
  Future<void> deletePatientPackage(int id);
    @Query('DELETE FROM ${LocalDataBase.patient_package_table}')
  Future<void> deleteAll();

    /// Insert multiple support months
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMany(List<PatientPackageEntity> patientPackages);
}
