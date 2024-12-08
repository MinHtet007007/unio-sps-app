import 'package:sps/common/constants/api_constant.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:sps/responses/remote_patient_response.dart';

part 'patient_sync_service.g.dart';

@RestApi(baseUrl: ApiConst.baseUrl)
abstract class PatientSyncService {
  factory PatientSyncService(Dio dio) => _PatientSyncService(dio);

  @GET(ApiConst.patientEndPoint)
  Future<RemotePatientResponse> fetchRemotePatients();
}
