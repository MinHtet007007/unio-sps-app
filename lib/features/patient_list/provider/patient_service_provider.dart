import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sps/common/provider/dio/dio_provider.dart';
import 'package:sps/features/patient_list/service/patient_service.dart';

final patientServiceProvider = Provider<PatientService>((ref) {
  return PatientService(ref.read(dioProvider));
});
