import 'package:sps/common/constants/api_constant.dart';
import 'package:sps/common/provider/dio/dio_provider.dart';
import 'package:sps/common/model/remote_patient.dart';
import 'package:flutter/material.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'patient_service.g.dart';

@RestApi(baseUrl: ApiConst.baseUrl)
abstract class PatientService {
  factory PatientService(Dio dio) => _PatientService(dio);

  @GET(ApiConst.patientEndPoint)
  Future<RemotePatientResult> fetchRemotePatients();
}
