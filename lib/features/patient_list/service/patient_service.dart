import 'package:sps/common/constants/api_constant.dart';
import 'package:sps/features/patient_list/model/remote_patient_result.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'patient_service.g.dart';

@RestApi(baseUrl: ApiConst.baseUrl)
abstract class PatientService {
  factory PatientService(Dio dio) => _PatientService(dio);

  @GET(ApiConst.patientEndPoint)
  Future<RemotePatientResult> fetchRemotePatients(
    @Query('last_synced_time') DateTime? lastSyncedTime,
  );
}
