import 'package:sps/common/constants/api_constant.dart';
import 'package:sps/common/model/remote_counseling.dart';
import 'package:sps/common/model/remote_patient.dart';
import 'package:sps/features/auth/data/model/counseling_sync_request.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'counseling_service.g.dart';

@RestApi(baseUrl: ApiConst.baseUrl)
abstract class CounselingService {
  factory CounselingService(Dio dio) => _CounselingService(dio);

  @POST(ApiConst.syncCounselings)
  Future<RemoteCounselingResult> syncCounselings(
      @Body() CounselingSyncRequest request);
}
