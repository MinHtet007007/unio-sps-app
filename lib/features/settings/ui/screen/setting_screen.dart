import 'package:sps/common/constants/route_list.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/features/user/provider/user_provider.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:sps/features/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.read(userProvider);
    final authStateProvider = ref.read(authProvider.notifier);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Setting',
          style: TextStyle(
            color: ColorTheme.white,
          ),
        ),
        backgroundColor: ColorTheme.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorTheme.white),
      ),
      body: Column(
        children: [
          Container(
              decoration: const BoxDecoration(
                  color: ColorTheme.primary,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(40),
                  )),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    child: Image.asset('assets/images/person.png',
                        height: 100, width: 100),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      CustomLabelWidget(
                        text: userState!.name,
                        style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      ),
                      const SizedBox(height: 15),
                      CustomLabelWidget(
                        text: userState!.code,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      const SizedBox(height: 15),
                      CustomLabelWidget(
                        text: userState!.township,
                        style:
                            const TextStyle(fontSize: 18, color: Colors.white),
                      ),
                    ],
                  )
                ],
              )),
          const SizedBox(height: 3.0),
          GestureDetector(
              onTap: () {
                context.go(RouteName.fontChange);
              },
              child: Card(
                child: ListTile(
                  leading: const Icon(Icons.font_download_outlined,
                      color: ColorTheme.secondary),
                  title: CustomLabelWidget(text: 'ဖောင့် ပြောင်းမည်'),
                ),
              )),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout, color: ColorTheme.secondary),
              title: CustomLabelWidget(text: 'ထွက်မည်'),
              onTap: () {
                authStateProvider.logout();
                // if (!mounted) return;
                // Navigator.pushReplacementNamed(context, TBTobaccoRoutes.login);
              },
            ),
          ),
        ],
      ),
    );
  }
}
