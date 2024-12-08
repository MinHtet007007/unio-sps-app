import 'package:sps/common/constants/route_list.dart';
import 'package:sps/features/auth/provider/auth_provider.dart';
import 'package:sps/features/auth/provider/auth_state/auth_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(const ProviderScope(
    child: MyApp(),
  ));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _router = GoRouter(routes: RouteList.routeList);

    // Call getMe to check if the user is already authenticated
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(authProvider.notifier).getMe();
    });
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<AuthUserState>(authProvider, (previous, next) {
      if (next is AuthUserSuccessState) {
        _router.go(RouteName.home);
      } else if (next is AuthMeLoadingState) {
        _router.go(RouteName.splash);
      } else {
        _router.go(RouteName.login);
      }
    });

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: _router,
    );
  }
}
