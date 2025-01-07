import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sps/common/constants/route_list.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:sps/common/widgets/loading_widget.dart';
import 'package:sps/common/widgets/snack_bar_utils.dart';
import 'package:sps/features/local_support_month_update/provider/local_update_support_month_provider.dart';
import 'package:sps/features/local_support_month_update/provider/local_update_support_month_state/local_update_support_month_state.dart';
import 'package:sps/features/patient_details/provider/local_patient_provider.dart';
import 'package:sps/features/patient_details/provider/local_patient_state/local_patient_state.dart';
import 'package:sps/local_database/entity/support_month_entity.dart';
import 'package:sps/models/received_package_request.dart';
import 'package:sps/screens/edit_patient_package/widget/edit_patient_package_form.dart';

class EditPatientPackageScreen extends ConsumerStatefulWidget {
  final int patientId;
  final int packageId;
  const EditPatientPackageScreen(
      {super.key, required this.patientId, required this.packageId});

  @override
  ConsumerState<EditPatientPackageScreen> createState() =>
      _EditPatientPackageScreenState();
}

class _EditPatientPackageScreenState
    extends ConsumerState<EditPatientPackageScreen> {
  void _fetchPatient() async {
    await Future.delayed(Duration.zero);

    final patientNotifier = ref.read(localPatientProvider.notifier);
    patientNotifier.fetchPatient(widget.patientId,
        supportMonthId: widget.packageId);
  }

  Future<void> onSubmit(SupportMonthEntity formData,
      List<ReceivedPackageRequest> receivedPackages) async {
    final localSupportMonthUpdateNotifier =
        ref.read(localUpdateSupportMonthProvider.notifier);
    await localSupportMonthUpdateNotifier.updateSupportMonth(
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

    ref.listen<LocalUpdateSupportMonthState>(
      localUpdateSupportMonthProvider,
      (previous, current) {
        if (current is LocalUpdateSupportMonthSuccessState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            SnackbarUtils.showSuccessToast(
                context, 'Support Month Update Success');
            context.pop();
            context.pushReplacement(
                "${RouteName.patientDetail}/${widget.patientId}");
          });
        } else if (current is LocalUpdateSupportMonthFailedState) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            SnackbarUtils.showError(context, current.errorMessage);
          });
        }
      },
    );

    return Scaffold(
      appBar: AppBar(
        title: CustomLabelWidget(
          text: "Update Package",
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
        if (state.localSupportMonth != null &&
            state.localReceivedPackagesBySupportMonthId != null) {
          return EditPatientPackageForm(
            patientDetails: state.localPatient,
            patientPackages: state.localPatientPackages,
            onSubmit: onSubmit,
            existingSupportMonth: state.localSupportMonth!,
            alreadyReceivedPackagesBySupportMonthId:
                state.localReceivedPackagesBySupportMonthId!,
            alreadyReceivedPackagesByPatientId: state
                .localReceivedPackagesByPatientId!
                .where((d) => d.localPatientSupportMonthId != widget.packageId)
                .toList(),
            patientSupportMonths: state.localSupportMonths,
          );
        } else {
          return const Text("Something went wrong");
        }
    }
  }
}
