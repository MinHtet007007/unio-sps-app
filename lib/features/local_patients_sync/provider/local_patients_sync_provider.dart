import 'dart:io';
import 'dart:typed_data';
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
          await database.patientDao.findUnsyncedPatients();
      if (patients.isEmpty) {
        state = LocalPatientsSyncFailedState('Not found any local patients');
        return;
      }
      List<LocalPatientWithRelations> result = [];
      var patientIndex = 0;
      var supportMonthIndex = 0;
      List<File> signatures = [];
      List<int> syncedPatientIds = [];
      for (final patient in patients) {
        final List<LocalSupportMonthWithRelations>
            localSupportMonthWithRelations = [];
        if (patient.id == null) {
          throw Error();
        }

        final supportMonths = await database.supportMonthDao
            .getUnSyncedSupportMonthsByLocalPatientId(patient.id as int);
        for (final supportMonth in supportMonths) {
          if (supportMonth.id == null) {
            throw Error();
          }
          final monthKey = 'signature_${patientIndex}_$supportMonthIndex';

          final receivePackages = await database.receivePackageDao
              .getReceivePackagesBySupportMonth(supportMonth.id as int);
          final signatureKey =
              supportMonth.supportMonthSignature != null ? monthKey : null;

          final localSupportMonth = createLocalSupportMonthWithRelations(
              supportMonth, signatureKey, receivePackages);
          localSupportMonthWithRelations.add(localSupportMonth);

          // add signature
          if (supportMonth.supportMonthSignature != null) {
            File signatureFile = await getSignatureFile(
                supportMonth.supportMonthSignature as Uint8List);
            signatures.add(signatureFile);
          }
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
    } finally {
      state = LocalPatientsSyncInitialState();
    }
  }

  Future<void> uploadPatientsWithSignatures(String patientsJson,
      List<File> signatureFiles, List<int> syncedPatientIds) async {
    final patientService = LocalPatientsSyncService(_dio);
    // Convert files to MultipartFile
    final List<MultipartFile> signatures =
        await Future.wait(signatureFiles.map((file) async {
      return MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last, // Extract filename
      );
    }));
    final response = await patientService.uploadPatientsWithSignatures(
        patients: patientsJson, signatures: signatures);

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
