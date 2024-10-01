import 'package:sps/common/constants/route_list.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/model/phase_data.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:sps/common/widgets/loading_widget.dart';
import 'package:sps/features/counseling_update/provider/local_update_counseling_provider.dart';
import 'package:sps/features/counseling_update/provider/local_update_counseling_state/local_update_counseling_state.dart';
import 'package:sps/features/counseling_update/ui/widget/update_counseling_form_widget.dart';
import 'package:sps/features/patient_details/provider/local_patient_provider.dart';
import 'package:sps/features/patient_details/provider/local_patient_state/local_patient_state.dart';
import 'package:sps/local_database/entity/counseling_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

const isNotSynced = false;

class UpdateCounselingScreen extends ConsumerStatefulWidget {
  final int id;
  final int patientId;
  const UpdateCounselingScreen(
      {Key? key, required this.id, required this.patientId})
      : super(key: key);

  @override
  ConsumerState<UpdateCounselingScreen> createState() =>
      _UpdateCounselingScreenState();
}

class _UpdateCounselingScreenState
    extends ConsumerState<UpdateCounselingScreen> {
  @override
  void initState() {
    super.initState();
    _fetchCounseling();
    _fetchPatient();
  }

  void _fetchCounseling() async {
    await Future.delayed(Duration.zero);

    ref.read(localUpdateCounselingProvider.notifier).fetchCounseling(widget.id);
  }

  void _fetchPatient() async {
    await Future.delayed(Duration.zero);

    ref.read(localPatientProvider.notifier).fetchPatient(widget.patientId);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(localUpdateCounselingProvider);
    final patientState = ref.watch(localPatientProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: CustomLabelWidget(
            text: "Counseling Form",
            style: AppBarTextStyle,
          ),
          backgroundColor: ColorTheme.primary,
        ),
        body: _updateCounselingWidget(state, patientState),
      ),
    );
  }

  void _onSubmit(Counseling counseling) async {
    if (counseling == null) {
      throw ArgumentError('Counseling cannot be null');
    }

    try {
      await Future.delayed(Duration.zero);
      ref
          .read(localUpdateCounselingProvider.notifier)
          .updateCounseling(counseling);
      final phaseData = PhaseData(phase: counseling.phase);

      if (context.mounted) {
        context.pop();
        context.pushReplacement(
            '${RouteName.patientCounselings}/${widget.patientId}',
            extra: phaseData);
      }
    } on Exception catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  Widget _updateCounselingWidget(
      LocalUpdateCounselingState state, LocalPatientState patientState) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state is LocalUpdateCounselingFailedState) {
        // Show a snackbar with the error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage)),
        );
        return;
      }
    });

    if (state is LocalCounselingFetchSuccessState &&
        patientState is LocalPatientSuccessState) {
      return UpdateCounselingFromWidget(
        counseling: state.counseling,
        onSubmit: _onSubmit,
        dotsStartDate: patientState.localPatient.dotsStartDate as String,
      );
    }

    if (state is LocalUpdateCounselingLoadingState) {
      return const LoadingWidget();
    }

    return const Text('Something went wrong');
  }
}
