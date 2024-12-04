import 'package:sps/common/constants/api_constant.dart';
import 'package:sps/common/model/api_response.dart';
import 'package:sps/features/auth/model/auth_user.dart';
import 'package:sps/features/auth/model/login_request.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'auth_service.g.dart';

@RestApi(baseUrl: ApiConst.baseUrl)
abstract class AuthService {
  factory AuthService(Dio dio) => _AuthService(dio);
  @POST(ApiConst.loginEndPoint)
  Future<ApiResponse<AuthUser>> login(@Body() LoginRequest request);

  @GET(ApiConst.meEndPoint)
  Future<ApiResponse<AuthUser>> me();
}
