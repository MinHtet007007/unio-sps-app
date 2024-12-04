import 'package:sps/features/auth/model/auth_user.dart';

sealed class AuthUserState {}

class AuthUserLoadingState extends AuthUserState {}

class AuthUserSuccessState extends AuthUserState {
  final AuthUser authUser;
  AuthUserSuccessState(this.authUser);
}

class AuthUserFailedState extends AuthUserState {
  final String errorMessage;
  AuthUserFailedState(this.errorMessage);
}

class AuthLoginForm extends AuthUserState {}

class AuthMeLoadingState extends AuthUserState {}

class AuthMeFailedState extends AuthUserState {}
