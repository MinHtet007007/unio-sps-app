// user_provider.dart
import 'package:sps/features/auth/model/auth_user.dart';
import 'package:sps/features/auth/provider/auth_provider.dart';
import 'package:sps/features/auth/provider/auth_state/auth_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final userProvider = Provider<AuthUser?>((ref) {
  final authState = ref.watch(authProvider);
  if (authState is AuthUserSuccessState) {
    return authState.authUser;
  }
  return null;
});
