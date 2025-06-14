import 'package:floor/floor.dart';
import 'package:sps/local_database/entity/receive_package_entity.dart';
import 'package:sps/local_database/tables/local_database_tables.dart';

@dao
abstract class ReceivePackageDao {
  @Query('SELECT * FROM ${LocalDataBase.patient_support_package_table}')
  Future<List<ReceivePackageEntity>> getAllReceivePackages();

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertReceivePackage(ReceivePackageEntity receivePackage);

  @Query(
      'DELETE FROM ${LocalDataBase.patient_support_package_table} WHERE id = :id')
  Future<void> deleteReceivePackage(int id);

  @Query(
      'SELECT * FROM ${LocalDataBase.patient_support_package_table} WHERE localPatientSupportMonthId = :supportMonthId')
  Future<List<ReceivePackageEntity>> getReceivePackagesBySupportMonth(
      int supportMonthId);

  /// Insert multiple support months
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMany(List<ReceivePackageEntity> receivePackages);

  @Query('DELETE FROM ${LocalDataBase.patient_support_package_table}')
  Future<void> deleteAll();

  @Query('DELETE FROM ${LocalDataBase.patient_support_package_table} '
      'WHERE localPatientSupportMonthId IN '
      '(SELECT id FROM ${LocalDataBase.patient_support_month_table} WHERE localPatientId IN (:patientIds))')
  Future<void> deleteByPatientIds(List<int> patientIds);

  @Query(
      'SELECT * FROM ${LocalDataBase.patient_support_package_table} WHERE localPatientSupportMonthId = :id')
  Future<List<ReceivePackageEntity>> getPackagesBySupportMonthId(int id);

  @Query(
      'DELETE FROM ${LocalDataBase.patient_support_package_table} WHERE localPatientSupportMonthId = :id')
  Future<void> deletePackagesBySupportMonthId(int id);

  @Query('''
  SELECT * FROM ${LocalDataBase.patient_support_package_table} WHERE localPatientSupportMonthId IN (
    SELECT id FROM ${LocalDataBase.patient_support_month_table} WHERE localPatientId = :localPatientId
  )
''')
  Future<List<ReceivePackageEntity>> getReceivedPackagesByLocalPatientId(
      int localPatientId);
}
