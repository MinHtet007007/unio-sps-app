// required package imports
import 'dart:async';
import 'package:sps/local_database/dao/patient_dao.dart';
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:floor/floor.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

part 'local_database.g.dart'; // the generated code will be there

@Database(version: 1, entities: [Patient])
abstract class AppDatabase extends FloorDatabase {
  PatientDao get patientDao;
}
