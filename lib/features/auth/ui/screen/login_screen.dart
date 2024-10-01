import 'package:sps/common/widgets/loading_widget.dart';
import 'package:sps/features/auth/provider/auth_provider.dart';
import 'package:sps/features/auth/provider/auth_state/auth_state.dart';
import 'package:sps/features/auth/ui/widget/login_form_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final authUserState = ref.watch(authProvider);

    return SafeArea(
      child: Scaffold(
        body: _loginResultWidget(authUserState),
      ),
    );
  }

  void _onSubmit(String code, String password) async {
    await Future.delayed(Duration.zero);
    ref.read(authProvider.notifier).login(code, password);
  }

  Widget _loginResultWidget(AuthUserState authState) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (authState is AuthUserFailedState) {
        // Show a snackbar with the error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(authState.errorMessage)),
        );
      }
    });

    return switch (authState) {
      AuthUserLoadingState() => const LoadingWidget(),
      AuthUserSuccessState() =>
        LoginForm(onSubmit: _onSubmit), // This will be replaced by navigation
      AuthUserFailedState() =>
        LoginForm(onSubmit: _onSubmit), // This will be handled by snackbar
      _ => LoginForm(onSubmit: _onSubmit), // Default case
    };
  }
}
