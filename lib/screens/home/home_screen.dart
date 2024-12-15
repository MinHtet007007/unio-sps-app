import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sps/common/constants/route_list.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/card_button.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sps/common/widgets/snack_bar_utils.dart';
import 'package:sps/common/widgets/sync_button.dart';
import 'package:sps/features/local_patients_sync/provider/local_patients_sync_provider.dart';
import 'package:sps/features/patient_home_sync/provider/home_sync_provider.dart';
import 'package:sps/features/patient_home_sync/provider/home_sync_state.dart';
import 'package:sps/features/patient_list/provider/local_patients_provider.dart';

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

    // final homeSyncNotifier = ref.read(homePatientSyncProvider.notifier);
    // await homeSyncNotifier.insertRemotePatients();
    ref.read(localPatientsSyncProvider.notifier).syncLocalPatients();
  }

  @override
  Widget build(BuildContext context) {
    final homeSyncNotifier = ref.watch(homePatientSyncProvider);
    ref.listen(homePatientSyncProvider, (state, _) {
      if (state is HomePatientsSyncFailedState) {
        SnackbarUtils.showError(context, 'Error');
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
                    SyncButton(
                        isLoading:
                            homeSyncNotifier is HomePatientsSyncLoadingState,
                        onPressed: _fetchRemotePatients),
                    CardButton(
                      color: ColorTheme.primary,
                      press: () {
                        context.push(RouteName.patient);
                      },
                      title: "လူနာစာရင်း",
                      image: "all_patient.png",
                    ),
                    CardButton(
                      color: ColorTheme.primary,
                      press: () {
                        context.push(RouteName.report);
                      },
                      title: "အနှစ်ချုပ်",
                      image: "summary.png",
                    ),
                    CardButton(
                      color: ColorTheme.primary,
                      press: () {
                        context.push(RouteName.note);
                      },
                      title: "မှတ်စု",
                      image: "handout.png",
                    )
                  ],
                ),
              ));
  }
}
