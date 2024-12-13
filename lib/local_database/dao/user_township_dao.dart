import 'package:floor/floor.dart';
import 'package:sps/local_database/entity/user_township_entity.dart';
import 'package:sps/local_database/tables/local_database_tables.dart';

@dao
abstract class UserTownshipDao {
  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertUserTownshipEntity(UserTownshipEntity userTownshipEntity);

  @Insert(onConflict: OnConflictStrategy.replace)
  Future<void> insertAllUserTownships(List<UserTownshipEntity> userTownshipEntity);

  @Query('SELECT * FROM ${LocalDataBase.user_township_table}')
  Future<List<UserTownshipEntity>> getAllUserTownships();

  @Query('DELETE FROM ${LocalDataBase.user_township_table}')
  Future<void> deleteAllUserTownships();
}
