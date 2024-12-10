import 'package:sps/common/helpers/cache.dart';
import 'package:sps/common/provider/dio/dio_provider.dart';
import 'package:sps/common/provider/local_database/local_database_provider.dart';
import 'package:sps/features/auth/model/auth_user.dart';
import 'package:sps/features/auth/model/login_request.dart';
import 'package:sps/features/auth/service/auth_service.dart';
import 'package:sps/features/auth/provider/auth_state/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:dio/dio.dart';

class AuthProvider extends StateNotifier<AuthUserState> {
  LocalDatabase localDatabase;
  final Dio _dio;

  AuthProvider(this.localDatabase, this._dio) : super(AuthLoginForm());

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
    state = AuthMeLoadingState();
    await Cache.deleteAll();
    final database = await localDatabase.database;
    await database.resetDatabase();
    await localDatabase.closeDatabase();
    state = AuthLoginForm();
  }

  void getMe() async {
    try {
      state = AuthMeLoadingState();
      final storedToken = await Cache.getToken();
      if (storedToken == null) {
        state = AuthMeFailedState();
        return;
      }
      final name = await Cache.getUserName();
      final township = await Cache.getUserTownship();
      if (name == null) {
        state = AuthMeFailedState();
      }
      state = AuthUserSuccessState(
          AuthUser(name: name as String, township: township ?? ''));
      return;
    } catch (error) {
      state = AuthMeFailedState();
    }
  }
}

final authProvider = StateNotifierProvider<AuthProvider, AuthUserState>((ref) =>
    AuthProvider(ref.read(localDatabaseProvider), ref.read(dioProvider)));
