import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sps/common/constants/route_list.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/card_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sps/common/widgets/snack_bar_utils.dart';
import 'package:sps/common/widgets/sync_button.dart';
import 'package:sps/features/patient_home_sync/provider/home_sync_provider.dart';
import 'package:sps/features/patient_home_sync/provider/home_sync_state.dart';

class Home extends ConsumerStatefulWidget {
  const Home({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomeState();
}

class _HomeState extends ConsumerState<Home> {
  @override
  void initState() {
    super.initState();
  }

  void _fetchRemotePatients() async {
    await Future.delayed(Duration.zero);

    final homeSyncNotifier = ref.read(homePatientSyncProvider.notifier);
    await homeSyncNotifier.insertRemotePatients();
  }

  void _confirmToSyncMore() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.redAccent,
            title: const Text(
              'Please confirm',
              style: TextStyle(color: Colors.white),
            ),
            content: const Text(
              'လူနာ data update များကျန်ပါသေးသည် ထပ်ဆွဲပါမည်လား',
              style: TextStyle(color: Colors.white),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Close dialog
                },
                child: const Text(
                  'No',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                onPressed: () =>
                    {Navigator.of(context).pop(), _fetchRemotePatients()},
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    final homeSyncNotifier = ref.watch(homePatientSyncProvider);
    ref.listen(homePatientSyncProvider, (state, _) {
      if (state is HomePatientsSyncFailedState) {
        SnackbarUtils.showError(context, state.errorMessage);
      }
      if (state is HomePatientsSyncSuccessState) {
        SnackbarUtils.showSuccessToast(context, 'Success');
      }
      if (state is HomePatientsSyncSuccessHasMoreState) {
        _confirmToSyncMore();
      }
    });

    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              SizedBox(
                width: 120.0,
                child: Image.asset(
                  'assets/images/the_union.png',
                  fit: BoxFit.cover,
                ),
              ),
              Flexible(
                // width: 120.0,

                child: Image.asset(
                  'assets/images/USAID.jpg',
                  fit: BoxFit.cover,
                ),
              ),
            ],
          ),
          backgroundColor: ColorTheme.primary,
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.settings,
                color: Colors.white,
                size: 25.0,
              ),
              onPressed: () {
                context.push(RouteName.setting);
              },
            ),
          ],
        ),
        body: homeSyncNotifier is HomePatientsSyncLoadingState
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: ListView(
                  children: [
                    if (homeSyncNotifier is! HomePatientsSyncLoadingState)
                      SyncButton(
                          title: "Sync (Get dashboard data)",
                          isLoading:
                              homeSyncNotifier is HomePatientsSyncLoadingState,
                          onPressed: _fetchRemotePatients),
                    CardButton(
                      color: ColorTheme.success,
                      press: () {
                        context.push(RouteName.patientCreate);
                      },
                      title: "To add new Patient",
                      image: "plus.png",
                    ),
                    CardButton(
                      color: ColorTheme.primary,
                      press: () {
                        context.push(RouteName.patient);
                      },
                      title: "Patient List",
                      image: "all_patient.png",
                    ),
                    CardButton(
                      color: ColorTheme.gray,
                      press: () {
                        context.push(RouteName.successPatientList);
                      },
                      title: "Successful Syncs",
                      image: "checked.png",
                    ),
                    CardButton(
                      color: ColorTheme.danger,
                      press: () {
                        context.push(RouteName.unSuccessPatientList);
                      },
                      title: "Unsuccessful Syncs",
                      image: "cancel.png",
                    ),
                    CardButton(
                      color: ColorTheme.success,
                      press: () {
                        context.push(RouteName.note);
                      },
                      title: "SOP and Manual",
                      image: "handout.png",
                    ),
                  ],
                ),
              ));
  }
}
