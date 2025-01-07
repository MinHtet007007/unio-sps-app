import 'package:sps/common/constants/route_list.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/features/auth/provider/auth_provider.dart';
import 'package:sps/features/user/provider/user_provider.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SettingScreen extends ConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(userProvider);
    final authStateProvider = ref.read(authProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Setting',
          style: AppBarTextStyle,
        ),
        backgroundColor: ColorTheme.primary,
        elevation: 0,
        iconTheme: const IconThemeData(color: ColorTheme.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: ColorTheme.primary,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  SizedBox(
                    child: Image.asset(
                      'assets/images/person.png',
                      height: 100,
                      width: 100,
                    ),
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        CustomLabelWidget(
                          text: userState?.name ?? 'User',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 10),
                        CustomLabelWidget(
                          text: userState?.townships != null &&
                                  userState!.townships!.isNotEmpty
                              ? userState.townships!
                                  .map((township) => township.name)
                                  .join(', ')
                              : 'No townships available',
                          style: const TextStyle(
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            GestureDetector(
              onTap: () {
                context.go(RouteName.fontChange);
              },
              child: Card(
                child: ListTile(
                  leading: const Icon(
                    Icons.font_download_outlined,
                    color: ColorTheme.black,
                  ),
                  title:  CustomLabelWidget(text: 'Font Change'),
                ),
              ),
            ),
            Card(
              child: ListTile(
                leading: const Icon(Icons.logout, color: ColorTheme.danger),
                title:  CustomLabelWidget(text: 'Logout'),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text('Confirm Logout'),
                        content: const Text(
                          'Are you sure you want to log out?\nAll data will be cleared.',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop(); // Close dialog
                            },
                            child: const Text(
                              'Cancel',
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              // Perform logout
                              authStateProvider.logout();
                              Navigator.of(context).pop(); // Close dialog
                              // Navigate to login screen
                              context.go(RouteName.login);
                            },
                            child: const Text(
                              'Logout',
                            ),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
