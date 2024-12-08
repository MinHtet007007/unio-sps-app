import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sps/common/provider/dio/dio_provider.dart';
import 'package:sps/features/patient_home_sync/service/patient_sync_service.dart';
import 'package:dio/dio.dart';

final patientSyncServiceProvider = Provider<PatientSyncService>((ref) {
  return PatientSyncService(ref.read(dioProvider));
});
