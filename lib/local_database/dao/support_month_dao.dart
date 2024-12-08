import 'package:floor/floor.dart';
import 'package:sps/local_database/entity/support_month_entity.dart';
import 'package:sps/local_database/tables/local_database_tables.dart';

@dao
abstract class SupportMonthDao {
  /// Retrieve all support months
  @Query('SELECT * FROM ${LocalDataBase.patient_support_month_table}')
  Future<List<SupportMonthEntity>> getAllSupportMonths();

  /// Retrieve support months by patient ID
  @Query('SELECT * FROM ${LocalDataBase.patient_support_month_table} WHERE localPatientId = :localPatientId')
  Future<List<SupportMonthEntity>> getSupportMonthsByLocalPatientId(int localPatientId);

  /// Retrieve support months by township ID
  @Query('SELECT * FROM ${LocalDataBase.patient_support_month_table} WHERE townshipId = :townshipId')
  Future<List<SupportMonthEntity>> getSupportMonthsByTownshipId(int townshipId);

  /// Retrieve a single support month by its ID
  @Query('SELECT * FROM ${LocalDataBase.patient_support_month_table} WHERE id = :id')
  Future<SupportMonthEntity?> getSupportMonthById(int id);

  /// Insert a new support month
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<int> insertSupportMonth(SupportMonthEntity supportMonth);

  /// Insert multiple support months
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertMany(List<SupportMonthEntity> supportMonths);

  /// Update a support month
  @Update(onConflict: OnConflictStrategy.replace)
  Future<void> updateSupportMonth(SupportMonthEntity supportMonth);

  /// Delete a support month by its ID
  @Query('DELETE FROM ${LocalDataBase.patient_support_month_table} WHERE id = :id')
  Future<void> deleteSupportMonthById(int id);

  /// Delete all support months for a specific patient
  @Query('DELETE FROM ${LocalDataBase.patient_support_month_table} WHERE patientId = :patientId')
  Future<void> deleteSupportMonthsByPatientId(int patientId);
}
