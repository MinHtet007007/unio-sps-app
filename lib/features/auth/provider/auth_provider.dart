import 'package:sps/common/helpers/cache.dart';
import 'package:sps/common/provider/dio/dio_provider.dart';
import 'package:sps/features/auth/model/auth_user.dart';
import 'package:sps/features/auth/model/login_request.dart';
import 'package:sps/features/auth/service/auth_service.dart';
import 'package:sps/features/auth/provider/auth_state/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

class AuthProvider extends Notifier<AuthUserState> {
  AuthUserState authUserState = AuthLoginForm();
  @override
  build() {
    return authUserState;
  }

  late final Dio _dio = ref.read(dioProvider);

  void login(String code, String password) async {
    try {
      state = AuthUserLoadingState();

      AuthService authService = AuthService(_dio);
      final response = await authService.login(
        LoginRequest(email: code, password: password),
      );

      final authUser = response.data;

      if (authUser.accessToken != null) {
        await Cache.saveToken(authUser.accessToken as String);
      }
      await Cache.saveUserName(authUser.name);
      if (authUser.township!.isNotEmpty) {
        await Cache.saveUserTownship(authUser.township ?? '');
      }
      if (authUser.project!.isNotEmpty) {
        await Cache.saveUserProject(authUser.project ?? '');
      }

      state = AuthUserSuccessState(authUser);
    } on DioException catch (dioError) {
      final errorMessage = dioError.response?.data['data']['message'] ??
          'Error occurred while logging in';
      state = AuthUserFailedState(errorMessage);
    } catch (error) {
      state = AuthUserFailedState(error.toString());
    }
  }

  void logout() async {
    state = AuthLoginForm();
    await Cache.deleteAll();
  }

  void getMe() async {
    try {
      state = AuthMeLoadingState();
      // Check network connectivity
      // bool online = await ConnectionChecker.isConnected();
      // if (online == false) {
      final storedToken = await Cache.getToken();
      if (storedToken == null) {
        state = AuthMeFailedState();
        return;
      }
      final name = await Cache.getUserName();
      final township = await Cache.getUserTownship();
      if (name == null || township == null) {
        state = AuthMeFailedState();
      }
      state = AuthUserSuccessState(
          AuthUser(name: name as String, township: township as String));
      return;
      // }
      // AuthService authService = AuthService(_dio);
      // final response = await authService.me();

      // final authUser = AuthUser(
      //   name: response.data.name,
      //   id: response.data.id,
      //   code: response.data.code,
      //   township: response.data.township,
      // );
      // state = AuthUserSuccessState(authUser);
    } catch (error) {
      state = AuthMeFailedState();
    }
  }
}

final authProvider =
    NotifierProvider<AuthProvider, AuthUserState>(() => AuthProvider());
