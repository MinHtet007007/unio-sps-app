import 'package:sps/common/constants/api_constant.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:sps/responses/remote_limited_patient_response.dart';

part 'patient_sync_service.g.dart';

@RestApi(baseUrl: ApiConst.baseUrl)
abstract class PatientSyncService {
  factory PatientSyncService(Dio dio) => _PatientSyncService(dio);

  @GET(ApiConst.patientEndPoint)
  Future<RemoteLimitedPatientResponse> fetchRemotePatients({
    @Query("already_synced_ids") String? alreadySyncedIds,
    @Query("last_sync_date") String? last_sync_date,
  });
}
