import 'package:sps/common/constants/form_options.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/helpers/get_couseling_phase.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:sps/common/widgets/form/custom_date_input.dart';
import 'package:sps/common/widgets/form/custom_drop_down.dart';
import 'package:sps/common/widgets/form/custom_submit_button.dart';
import 'package:sps/local_database/entity/counseling_entity.dart';
import 'package:flutter/material.dart';

const double height = 20.0;

class UpdateCounselingFromWidget extends StatefulWidget {
  final void Function(Counseling counseling) onSubmit;
  final Counseling counseling;
  final String dotsStartDate;

  const UpdateCounselingFromWidget(
      {super.key,
      required this.onSubmit,
      required this.counseling,
      required this.dotsStartDate});
  @override
  State<UpdateCounselingFromWidget> createState() =>
      _UpdateCounselingFromWidgetState();
}

class _UpdateCounselingFromWidgetState
    extends State<UpdateCounselingFromWidget> {
  final TextEditingController dateController = TextEditingController();
  String? selectedType;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    dateController.text = widget.counseling.date;
    selectedType = widget.counseling.type;
  }

  @override
  Widget build(BuildContext context) {
    final phase = widget.counseling.phase == CONTINUOUS_PHASE
        ? 'ဆက်လက် ဆေးကုကာလ'
        : 'ကနဦး ဆေးကုကာလ';

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        child: Form(
            key: _formKey,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              CustomLabelWidget(
                text: phase,
                style: const TextStyle(fontSize: 18, color: ColorTheme.black),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomDateInput(
                labelText: 'နေ့စွဲ',
                dateController: dateController,
                validateDate: widget.dotsStartDate,
              ),
              const Divider(
                height: height,
                color: ColorTheme.black,
              ),
              CustomDropDown(
                  title: 'အမျိုးအစား (ဖုန်းဖြင့်/လူကိုယ်တိုင်)',
                  items: counselingTypeOptions,
                  selectedData: selectedType,
                  hintText: 'အမျိုးအစား',
                  onChanged: ((value) {
                    setState(() {
                      selectedType = value;
                    });
                  })),
              CustomSubmitButton(
                  buttonText: 'ထည့်မည်',
                  onSubmit: () async {
                    if (_formKey.currentState!.validate()) {
                      widget.onSubmit(Counseling(
                          widget.counseling.patientId,
                          widget.counseling.phase,
                          selectedType!,
                          dateController.text,
                          widget.counseling.isSynced,
                          id: widget.counseling.id));
                    }
                  }),
              const SizedBox(
                height: height,
              ),
            ])));
  }
}
