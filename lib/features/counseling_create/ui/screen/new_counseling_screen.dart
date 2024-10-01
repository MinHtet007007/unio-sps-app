import 'package:sps/common/constants/form_options.dart';
import 'package:sps/common/constants/route_list.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/model/phase_data.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:sps/common/widgets/loading_widget.dart';
import 'package:sps/features/counseling_create/provider/local_new_counseling_provider.dart';
import 'package:sps/features/counseling_create/provider/local_new_counseling_state/local_new_counseling_state.dart';
import 'package:sps/features/counseling_create/ui/widget/new_counseling_form_widget.dart';
import 'package:sps/local_database/entity/counseling_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class NewCounselingScreen extends ConsumerStatefulWidget {
  final int patientId;
  final String phase;
  final String dotsStartDate;
  const NewCounselingScreen(
      {Key? key,
      required this.patientId,
      required this.phase,
      required this.dotsStartDate})
      : super(key: key);

  @override
  ConsumerState<NewCounselingScreen> createState() =>
      _NewCounselingScreenState();
}

class _NewCounselingScreenState extends ConsumerState<NewCounselingScreen> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(localNewCounselingProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: CustomLabelWidget(
            text: "Counseling Form",
            style: AppBarTextStyle,
          ),
          backgroundColor: ColorTheme.primary,
        ),
        body: _newCounselingWidget(state),
      ),
    );
  }

  void _onSubmit(String type, String date) async {
    await Future.delayed(Duration.zero);
    ref.read(localNewCounselingProvider.notifier).addCounseling(
        Counseling(widget.patientId, widget.phase, type, date, IN_NOT_SYNCED));
    final phaseData = PhaseData(phase: widget.phase);

    context.pop();
    context.pushReplacement(
        '${RouteName.patientCounselings}/${widget.patientId}',
        extra: phaseData);
  }

  Widget _newCounselingWidget(LocalNewCounselingState state) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (state is LocalNewCounselingFailedState) {
        // Show a snackbar with the error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(state.errorMessage)),
        );
        return;
      }
      // if (state is LocalNewCounselingSuccessState) {
      //   context.go('${RouteName.patientCounselings}/${widget.patientId}');
      // }
    });

    return switch (state) {
      LocalNewCounselingFormState() => NewCounselingFromWidget(
          onSubmit: _onSubmit,
          phase: widget.phase,
          dotsStartDate: widget.dotsStartDate),
      LocalNewCounselingLoadingState() => const LoadingWidget(),
      LocalNewCounselingSuccessState() => NewCounselingFromWidget(
          onSubmit: _onSubmit,
          phase: widget.phase,
          dotsStartDate:
              widget.dotsStartDate), // This will be replaced by navigation
      LocalNewCounselingFailedState() => NewCounselingFromWidget(
          onSubmit: _onSubmit,
          phase: widget.phase,
          dotsStartDate:
              widget.dotsStartDate), // This will be handled by snackbar
    };
  }
}
