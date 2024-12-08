import 'package:sps/common/constants/api_constant.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';
import 'package:sps/responses/support_month_sync_response.dart';
import 'dart:convert';

part 'support_month_sync_service.g.dart';

@RestApi(baseUrl: ApiConst.baseUrl)
abstract class SupportMonthSyncService {
factory SupportMonthSyncService(Dio dio) {
    return _SupportMonthSyncService(dio); // Use the generated implementation
  }

  @POST(ApiConst.supportMonthSyncEndPoint)
  @MultiPart()
  Future<SupportMonthSyncResponse> syncLocalSupportMonths(
    {
      @Part() required int number,
      @Part() required Map<String, dynamic> bulkData
    }
  );
}
