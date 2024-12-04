import 'package:sps/features/auth/provider/auth_provider.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthCheckInterceptor extends Interceptor {
  final Ref ref;

  AuthCheckInterceptor(this.ref);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // Check for 401 status code and log the user out
    if (response.statusCode == 401) {
      // Log out the user by updating the provider state
      ref.read(authProvider.notifier).logout();
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // Check for 401 status code in case of errors
    if (err.response?.statusCode == 401) {
      // Log out the user by updating the provider state
      ref.read(authProvider.notifier).logout();
    }
    super.onError(err, handler);
  }
}
