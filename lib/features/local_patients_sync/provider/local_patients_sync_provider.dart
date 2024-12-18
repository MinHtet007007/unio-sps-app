import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sps/common/provider/dio/dio_provider.dart';

import 'package:sps/common/provider/local_database/local_database_provider.dart';
import 'package:sps/features/local_patients_sync/model/local_patient_with_relations.dart';
import 'package:sps/features/local_patients_sync/model/local_support_month_with_relations.dart';
import 'package:sps/features/local_patients_sync/service/local_patients_sync_service.dart';
import 'dart:async';

import 'package:sps/features/local_patients_sync/state/local_patients_sync_state.dart';
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/models/remote_patient.dart';
import 'dart:convert';

import 'package:sps/utils/file.dart';

class LocalPatientsSyncProvider extends StateNotifier<LocalPatientsSyncState> {
  LocalDatabase localDatabase;
  final Dio _dio;

  LocalPatientsSyncProvider(this.localDatabase, this._dio)
      : super(LocalPatientsSyncInitialState());

  Future<void> syncLocalPatients() async {
    try {
      state = LocalPatientsSyncLoadingState();
      final database = await localDatabase.database;
      List<PatientEntity> patients =
          await database.patientDao.findAllLocalPatients();
      List<LocalPatientWithRelations> result = [];
      var patientIndex = 0;
      var supportMonthIndex = 0;
      List<int> syncedPatientIds = [];
      for (final patient in patients) {
        final List<LocalSupportMonthWithRelations>
            localSupportMonthWithRelations = [];
        if (patient.id == null) {
          throw Error();
        }

        final supportMonths = await database.supportMonthDao
            .getSupportMonthsByLocalPatientId(patient.id as int);
        for (final supportMonth in supportMonths) {
          if (supportMonth.id == null) {
            throw Error();
          }
          final receivePackages = await database.receivePackageDao
              .getReceivePackagesBySupportMonth(supportMonth.id as int);
          final localSupportMonth = createLocalSupportMonthWithRelations(
              supportMonth, receivePackages);
          localSupportMonthWithRelations.add(localSupportMonth);

          //add signature
          // if (supportMonth.signature != null) {
          //   String path = await getFilePath(supportMonth.signature);

          //   formData.files.add(MapEntry(
          //       'month_0_signature$patientIndex$supportMonthIndex',
          //       await MultipartFile.fromFile(path)));
          // }
          supportMonthIndex++;
        }
        final patientPackages = await database.patientPackageDao
            .getPatientPackagesByPatientId(patient.id as int);

        // Combine into the LocalPatientWithRelations structure
        result.add(createLocalPatientWithRelations(
            patient, patientPackages, localSupportMonthWithRelations));
        patientIndex++;

        // track synced ids to delete after syn
        syncedPatientIds.add(patient.id as int);
      }

      final signature1 =
          await createDummyFile('signature1.txt', 'Dummy signature content 1');

      final signatures = [signature1];

      // Serialize the list to JSON
      final patientsJson = result.map((patient) => patient.toJson()).toList();
      // Convert to JSON string
      final jsonString = jsonEncode(patientsJson);
      await uploadPatientsWithSignatures(
          jsonString, signatures, syncedPatientIds);
      state = LocalPatientsSyncSuccessState();
    } catch (e, stackTrace) {
      state = LocalPatientsSyncFailedState('Cannot sync local patients');
      print('Error $e');
      print('stackTrace $stackTrace');
    }
  }

  Future<void> uploadPatientsWithSignatures(String patientsJson,
      List<File> signatures, List<int> syncedPatientIds) async {
    final patientService = LocalPatientsSyncService(_dio);
    final response = await patientService.uploadPatientsWithSignatures(
        patients: patientsJson, signatures: signatures);

    print('Response: ${response.data}');
    final database = await localDatabase.database;

    await database.deleteSyncedPatients(syncedPatientIds);
    await handleResponsePatients(response.data);
  }

  Future<void> handleResponsePatients(List<Patient> data) async {
    if (data.isNotEmpty) {
      final database = await localDatabase.database;
      for (var patient in data) {
        await database.syncPatient(patient);
      }
    }
  }
}

final localPatientsSyncProvider =
    StateNotifierProvider<LocalPatientsSyncProvider, LocalPatientsSyncState>(
        (ref) => LocalPatientsSyncProvider(
            ref.read(localDatabaseProvider), ref.read(dioProvider)));
