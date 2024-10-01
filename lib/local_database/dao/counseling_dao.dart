// dao/counseling_dao.dart

import 'package:sps/local_database/entity/counseling_entity.dart';
import 'package:sps/local_database/tables/local_database_tables.dart';
import 'package:floor/floor.dart';

@dao
abstract class CounselingDao {
  @Query(
      'SELECT * FROM ${LocalDataBase.counseling_table} where patientId = :patientId ORDER BY isSynced, date DESC')
  Future<List<Counseling>> findAll(int patientId);

  @Query(
      'SELECT * FROM ${LocalDataBase.counseling_table} where patientId = :patientId AND isSynced = 0')
  Future<List<Counseling>> findNotSyncedCounselings(int patientId);

  @Query(
      'SELECT COUNT(*) FROM ${LocalDataBase.counseling_table} where isSynced = 0')
  Future<int?> getNotSyncedCounselingsCount();

  @Query('SELECT * FROM ${LocalDataBase.counseling_table} WHERE id = :id')
  Future<Counseling?> findCounselingById(int id);

  @insert
  Future<int> addCounseling(Counseling data);

  @delete
  Future<int> deleteCounseling(Counseling data);

  @update
  Future<int> updateCounseling(Counseling data);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAll(List<Counseling> data);

  @Query('DELETE FROM ${LocalDataBase.counseling_table}')
  Future<void> deleteAll();
}
