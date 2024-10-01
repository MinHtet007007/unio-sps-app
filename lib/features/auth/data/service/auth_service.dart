import 'package:sps/common/constants/api_constant.dart';
import 'package:sps/common/model/api_response.dart';
import 'package:sps/common/provider/dio/dio_provider.dart';
import 'package:sps/features/auth/data/model/auth_user.dart';
import 'package:sps/features/auth/data/model/login_request.dart';
import 'package:flutter/material.dart';
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
