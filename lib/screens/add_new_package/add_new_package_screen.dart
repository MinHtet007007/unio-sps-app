import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sps/common/constants/route_list.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:sps/common/widgets/loading_widget.dart';
import 'package:sps/common/widgets/snack_bar_utils.dart';
import 'package:sps/features/local_support_month_create/provider/local_new_support_month_provider.dart';
import 'package:sps/features/local_support_month_create/provider/local_new_support_month_state/local_new_support_month_state.dart';
import 'package:sps/features/patient_details/provider/local_patient_provider.dart';
import 'package:sps/features/patient_details/provider/local_patient_state/local_patient_state.dart';
import 'package:sps/local_database/entity/support_month_entity.dart';
import 'package:sps/models/received_package_request.dart';
import 'package:sps/screens/add_new_package/widget/add_new_package_form.dart';

class AddNewPackageScreen extends ConsumerStatefulWidget {
  final int patientId;
  const AddNewPackageScreen({super.key, required this.patientId});

  @override
  ConsumerState<AddNewPackageScreen> createState() =>
      _AddNewPackageScreenState();
}

class _AddNewPackageScreenState extends ConsumerState<AddNewPackageScreen> {
  void _fetchPatient() async {
    await Future.delayed(Duration.zero);
    final patientNotifier = ref.read(localPatientProvider.notifier);
    patientNotifier.fetchPatient(widget.patientId);
  }

  Future<void> onSubmit(SupportMonthEntity formData,
      List<ReceivedPackageRequest> receivedPackages) async {
    final localSupportMonthCreateNotifier =
        ref.read(localNewSupportMonthProvider.notifier);
    await localSupportMonthCreateNotifier.addSupportMonth(
        formData, receivedPackages);
  }

  @override
  void initState() {
    super.initState();
    _fetchPatient();
  }

  @override
  Widget build(BuildContext context) {
    final localState = ref.watch(localPatientProvider);
    final localNewSupportMonthState = ref.watch(localNewSupportMonthProvider);

    ref.listen<LocalNewSupportMonthState>(
      localNewSupportMonthProvider,
      (previous, current) {
        if (current is LocalNewSupportMonthSuccessState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            SnackbarUtils.showSuccessToast(
                context, 'Support Month Create Success');
            // ref
            //     .read(localNewSupportMonthProvider.notifier)
            //     .resetState(); // Reset state
            context.pop();
            context.pushReplacement(
                "${RouteName.patientDetail}/${widget.patientId}");
          });
        } else if (current is LocalNewSupportMonthFailedState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            SnackbarUtils.showError(context, 'Support Month Cannot be Created');
            // ref
            //     .read(localNewSupportMonthProvider.notifier)
            //     .resetState(); // Reset state
          });
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: CustomLabelWidget(
          text: "Create Package",
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: ColorTheme.primary,
      ),
      body: _buildWidgetBasedOnState(localState),
    );
  }

  Widget _buildWidgetBasedOnState(LocalPatientState state) {
    switch (state) {
      case LocalPatientFailedState():
        return const Text("Failed");
      case LocalPatientLoadingState():
        return const LoadingWidget();
      case LocalPatientSuccessState():
        return AddNewPackageForm(
          patientDetails: state.localPatient,
          patientPackages: state.localPatientPackages,
          patientSupportMonths: state.localSupportMonths,
          onSubmit: onSubmit,
        );
    }
  }
}
