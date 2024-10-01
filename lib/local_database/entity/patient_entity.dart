// entity/patient.dart

import 'package:sps/common/model/remote_patient.dart';
import 'package:sps/local_database/tables/local_database_tables.dart';
import 'package:floor/floor.dart';

@Entity(tableName: LocalDataBase.patient_table)
class Patient {
  @PrimaryKey(autoGenerate: true)
  int? id;
  final String name;
  final String phone;
  final String address;
  final String? unionTemporaryCode;
  final String? treatmentRegimen;
  final String? tbType;
  final int patientId;
  final int volunteerId;
  final String? dotsStartDate;
  final String? dotsEndDate;
  final String? treatmentOutcome;
  final String? treatmentOutcomeDate;
  final String? dotsPatientType;
  final String? actualTreatmentStartDate;
  final String? type;
  final String? remark;

  Patient(
      this.name,
      this.phone,
      this.address,
      this.unionTemporaryCode,
      this.treatmentRegimen,
      this.tbType,
      this.patientId,
      this.volunteerId,
      this.dotsStartDate,
      this.dotsEndDate,
      this.treatmentOutcome,
      this.treatmentOutcomeDate,
      this.dotsPatientType,
      this.actualTreatmentStartDate,
      this.type,
      this.remark,
      {this.id});

  factory Patient.fromMap(RemotePatient e) {
    return Patient(
        e.name,
        e.phone,
        e.address,
        e.unionTemporaryCode,
        e.treatmentRegimen,
        e.tbType,
        e.patientId,
        e.volunteerId,
        e.dotsStartDate,
        e.dotsEndDate,
        e.treatmentOutcome,
        e.treatmentOutcomeDate,
        e.dotsPatientType,
        e.actualTreatmentStartDate,
        e.type,
        e.remark,
        id: e.id);
  }
}
