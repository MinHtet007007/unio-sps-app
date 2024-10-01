import 'package:sps/common/api_interceptors/apiToken_interceptor.dart';
import 'package:sps/common/api_interceptors/auth_check_interceptor.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

Provider<Dio> dioProvider = Provider((ref) {
  Dio dio = Dio();
  dio.interceptors.addAll([
    PrettyDioLogger(
      requestHeader: true,
      requestBody: true,
      responseBody: true,
      responseHeader: false,
      compact: false,
    ),
    ApitokenInterceptor(),
    AuthCheckInterceptor(ref),
  ]);
  return dio;
});
