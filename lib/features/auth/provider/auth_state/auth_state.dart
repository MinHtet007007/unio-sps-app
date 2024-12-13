import 'package:sps/features/auth/model/auth_user.dart';
import 'package:sps/features/user/model/user.dart';

sealed class AuthUserState {}

class AuthUserLoadingState extends AuthUserState {}

class AuthUserSuccessState extends AuthUserState {
  final User authUser;
  AuthUserSuccessState(this.authUser);
}

class AuthUserFailedState extends AuthUserState {
  final String errorMessage;
  AuthUserFailedState(this.errorMessage);
}

class AuthLoginForm extends AuthUserState {}

class AuthMeLoadingState extends AuthUserState {}

class AuthMeFailedState extends AuthUserState {}
