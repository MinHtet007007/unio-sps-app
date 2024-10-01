import 'package:sps/common/model/remote_counseling.dart';
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/local_database/tables/local_database_tables.dart';
import 'package:floor/floor.dart';

@Entity(tableName: LocalDataBase.counseling_table, foreignKeys: [
  ForeignKey(
      childColumns: ['patientId'], parentColumns: ['id'], entity: Patient)
])
class Counseling {
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final int patientId;
  final String phase;
  final String type;
  final String date;
  final bool isSynced;

  Counseling(this.patientId, this.phase, this.type, this.date, this.isSynced,
      {this.id});
  factory Counseling.fromMap(RemoteCounseling e) {
    return Counseling(e.dotsPatientId, e.phase, e.type, e.date, true, id: e.id);
  }
}
