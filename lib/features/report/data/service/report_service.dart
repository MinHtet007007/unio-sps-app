import 'package:sps/common/constants/api_constant.dart';
import 'package:sps/common/provider/dio/dio_provider.dart';
import 'package:sps/features/report/data/model/remote_report_result.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'report_service.g.dart';

@RestApi(baseUrl: ApiConst.baseUrl)
abstract class ReportService {
  factory ReportService(Dio dio) => _ReportService(dio);

  @GET(ApiConst.report)
  Future<RemoteReportResult> getReport({
    @Query('month') String? month,
    @Query('year') String? year,
    @Query('name') String? name,
  });
}
