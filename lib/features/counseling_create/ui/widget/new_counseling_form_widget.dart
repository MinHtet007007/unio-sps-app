import 'package:sps/common/constants/form_options.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/helpers/get_couseling_phase.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:sps/common/widgets/form/custom_date_input.dart';
import 'package:sps/common/widgets/form/custom_drop_down.dart';
import 'package:sps/common/widgets/form/custom_submit_button.dart';
import 'package:flutter/material.dart';

const double height = 20.0;

class NewCounselingFromWidget extends StatefulWidget {
  final void Function(String, String) onSubmit;
  final String phase;
  final String dotsStartDate;

  const NewCounselingFromWidget(
      {super.key,
      required this.onSubmit,
      required this.phase,
      required this.dotsStartDate});
  @override
  State<NewCounselingFromWidget> createState() =>
      _NewCounselingFromWidgetState();
}

class _NewCounselingFromWidgetState extends State<NewCounselingFromWidget> {
  final TextEditingController dateController = TextEditingController();
  String? selectedType;

  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final phase =
        widget.phase == CONTINUOUS_PHASE ? 'ဆက်လက် ဆေးကုကာလ' : 'ကနဦး ဆေးကုကာလ';
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
                      widget.onSubmit(selectedType!, dateController.text);
                    }
                  }),
              const SizedBox(
                height: height,
              ),
            ])));
  }
}
