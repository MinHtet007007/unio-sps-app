import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sps/common/constants/api_constant.dart';
import 'package:sps/common/helpers/cache.dart';
import 'package:sps/common/provider/dio/dio_provider.dart';

import 'package:sps/common/provider/local_database/local_database_provider.dart';
import 'package:sps/features/local_patients_sync/model/local_patient_with_relations.dart';
import 'package:sps/features/local_patients_sync/model/local_support_month_with_relations.dart';
import 'dart:async';

import 'package:sps/features/local_patients_sync/state/local_patients_sync_state.dart';
import 'package:sps/local_database/entity/patient_entity.dart';
import 'dart:convert';

import 'package:sps/utils/file.dart';

class LocalPatientsSyncProvider extends StateNotifier<LocalPatientsSyncState> {
  LocalDatabase localDatabase;
  final Dio _dio;

  LocalPatientsSyncProvider(this.localDatabase, this._dio)
      : super(LocalPatientsSyncLoadingState());

  Future<void> syncLocalPatients() async {
    try {
      final formData = FormData();

      final database = await localDatabase.database;
      List<PatientEntity> patients =
          await database.patientDao.findAllLocalPatients();
      List<LocalPatientWithRelations> result = [];
      var patientIndex = 0;
      var supportMonthIndex = 0;
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
      }

      final signature1 =
          await createDummyFile('signature1.txt', 'Dummy signature content 1');

      final signatures = [signature1];

      // Serialize the list to JSON
      final patientsJson = result.map((patient) => patient.toJson()).toList();
      // Convert to JSON string
      final jsonString = jsonEncode(patientsJson);

      // Add patients data
      formData.fields.add(MapEntry(
        'patients',
        jsonString,
      ));

      await uploadPatientsWithSignatures(jsonString, signatures);
    } catch (e, stackTrace) {
      print('Error $e');
      print('stackTrace $stackTrace');
    }
  }

  Future<void> uploadPatientsWithSignatures(
      String formData, List<File> signatures) async {
    try {
      final token = await Cache.getToken();
      // Send the request
      final response = await _dio.post(
        '${ApiConst.baseUrl}${ApiConst.localPatientsSyncEndPoint}',
        data: formData,
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Add auth headers if needed
            "Accept": "application/json"
          },
        ),
      );

      print('Response: ${response.data}');
    } catch (e) {
      print('Error uploading patients: $e');
    }
  }
}

final localPatientsSyncProvider =
    StateNotifierProvider<LocalPatientsSyncProvider, LocalPatientsSyncState>(
        (ref) => LocalPatientsSyncProvider(
            ref.read(localDatabaseProvider), ref.read(dioProvider)));
