import 'dart:io';

import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sps/common/constants/api_constant.dart';
import 'package:sps/responses/remote_patient_response.dart';

part 'local_patients_sync_service.g.dart'; // Required for Retrofit code generation

@RestApi(baseUrl: ApiConst.baseUrl)
abstract class LocalPatientsSyncService {
  factory LocalPatientsSyncService(Dio dio) => _LocalPatientsSyncService(dio);

  @POST(ApiConst.localPatientsSyncEndPoint)
  @MultiPart()
  Future<RemotePatientResponse> uploadPatientsWithSignatures({
    @Part() required String patients,
    @Part(name: "signatures[]") List<MultipartFile>? signatures,
  });

  @POST("/upload-amazon-test")
  @MultiPart()
  Future<HttpResponse> uploadImage(
    @Part(name: "file") File file,
  );
}
