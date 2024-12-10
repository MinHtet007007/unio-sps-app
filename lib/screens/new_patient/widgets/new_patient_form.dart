import 'package:flutter/material.dart';
import 'package:sps/common/constants/form_options.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:sps/common/widgets/custom_text.dart';
import 'package:sps/common/widgets/form/custom_date_input.dart';
import 'package:sps/common/widgets/form/custom_drop_down.dart';
import 'package:sps/common/widgets/form/custom_submit_button.dart';
import 'package:sps/common/widgets/form/custom_text_input.dart';
import 'package:sps/common/widgets/form/custom_text_input_with_validation.dart';
import 'package:sps/local_database/entity/patient_entity.dart';

class NewPatientForm extends StatefulWidget {
  final PatientEntity? data;
  final void Function()? submit;

  const NewPatientForm({super.key,required this.submit, this.data});
  @override
  State<NewPatientForm> createState() => _NewPatientFormState();
}

class _NewPatientFormState extends State<NewPatientForm> {
  String? selectedYear;
  String? selectedSex;
  String? selectedTownship;
  String? selectedDiedBeforeTreatmentEnrollment;
  String? selectedRegimentType;

  // Controllers
  final Map<String, TextEditingController> controllers = {
    'name': TextEditingController(),
    'age': TextEditingController(),
    'phone': TextEditingController(),
    'address': TextEditingController(),
    'rrCode': TextEditingController(),
    'drtbCode': TextEditingController(),
    'spCode': TextEditingController(),
    'treatmentStartDate': TextEditingController(),
    'treatmentRegimenOther': TextEditingController(),
    'contactInfo': TextEditingController(),
    'contactPhone': TextEditingController(),
    'primaryLanguage': TextEditingController(),
    'secondaryLanguage': TextEditingController(),
    'height': TextEditingController(),
    'weight': TextEditingController(),
    'bmi': TextEditingController(),
  };

  final GlobalKey<FormState> _formKey = GlobalKey();

  bool isValidate = true;

  void isInvalidate() {
    setState(() {
      isValidate = false;
    });
  }

  @override
  void didChangeDependencies() {
    // if (widget.data != null) {
    //   PatientEntity data = widget.data!;
    //   nameController.text = data.name;
    //   if (data.other_ethnic_group != null) {
    //     otherEthnicGroupController.text = data.other_ethnic_group!;
    //   }
    //   addressController.text =
    //       data.address != null ? data.address as String : '';
    //   selectedTBDateRegistrationPlace = data.tb_code_registration;
    //   selectedYear = data.year;
    //   dateController.text = data.date_of_registration;
    //   treatmentStartDateController.text = data.treatment_start_date!;
    //   tbCodeController.text = data.union_temporary_TB_code;
    //   selectedSex = data.sex;
    //   selectedEthnicGroup = data.ethnic_group;
    //   ageController.text = '${data.age}';

    //   selectedTypeOfTBDependingOnBACStatus =
    //       data.type_of_TB_depending_on_bac_status;
    //   selectedRegimentType = data.regimen_type;
    //   phoneController.text = data.phone;
    // }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: CustomLabelWidget(
            text: 'လူနာအချက်အလက်',
            style: const TextStyle(color: ColorTheme.white, fontSize: 15),
          ),
          backgroundColor: ColorTheme.primary,
          elevation: 0,
          iconTheme: const IconThemeData(color: ColorTheme.white),
        ),
        body: SingleChildScrollView(
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 13.0, vertical: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CustomDropDown(
                          title: 'ခုနှစ်',
                          items: years,
                          selectedData: selectedYear,
                          hintText: 'ခုနှစ်',
                          onChanged: ((value) {
                            setState(() {
                              selectedYear = value;
                            });
                          }),
                        ),
                        const SizedBox(height: 10),
                        // CustomDropDown(
                        //   title: 'မြို့နယ်',
                        //   items: townships,
                        //   selectedData: selectedTownship,
                        //   hintText: 'မြို့နယ်',
                        //   onChanged: ((value) {
                        //     setState(() {
                        //       selectedTownship = value;
                        //     });
                        //   }),
                        // ),
                        const SizedBox(height: 10),
                        CustomTextInput(
                            inputController:
                                controllers['rrCode'] as TextEditingController,
                            labelText: 'RR code'),
                        const SizedBox(height: 10),
                        CustomTextInput(
                            inputController: controllers['drtbCode']
                                as TextEditingController,
                            labelText: 'DRTB code'),
                        const SizedBox(height: 10),
                        CustomTextInput(
                            inputController:
                                controllers['spCode'] as TextEditingController,
                            labelText: 'SP code'),
                        const SizedBox(height: 10),
                        CustomTextInput(
                            inputController:
                                controllers['name'] as TextEditingController,
                            labelText: 'နာမည်',
                            type: 'text'),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextInputWithValidation(
                            inputController:
                                controllers['age'] as TextEditingController,
                            labelText: 'အသက်',
                            type: 'number',
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return CustomText.getText(
                                    context, 'အသက် ဖြည့်ပေးပါ');
                              } else if (int.parse(value) < 1 ||
                                  int.parse(value) > 120) {
                                return CustomText.getText(
                                    context, 'အချက်အလက်မှားယွင်းနေသည်');
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomDropDown(
                          title: 'ကျား/မ',
                          items: genders,
                          selectedData: selectedSex,
                          hintText: 'ကျား/မ',
                          onChanged: ((value) {
                            setState(() {
                              selectedSex = value;
                            });
                          }),
                        ),
                        const SizedBox(height: 10),
                        CustomDropDown(
                          title: 'died_before_treatment_enrollment',
                          items: yesOrNoOptions,
                          selectedData: selectedDiedBeforeTreatmentEnrollment,
                          hintText: 'died_before_treatment_enrollment',
                          onChanged: ((value) {
                            setState(() {
                              selectedDiedBeforeTreatmentEnrollment = value;
                            });
                          }),
                        ),
                        const SizedBox(height: 10),
                        CustomDateInput(
                          dateController: controllers['treatmentStartDate']
                              as TextEditingController,
                          labelText: 'treatment start date',
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomDropDown(
                          title: 'ကုထုံးအမျိုးအစား',
                          items: treatmentRegimenOptions,
                          selectedData: selectedRegimentType,
                          hintText: 'ကုထုံးအမျိုးအစား',
                          onChanged: ((value) {
                            setState(() {
                              selectedRegimentType = value;
                            });
                          }),
                        ),
                        const SizedBox(height: 10),
                        if (selectedRegimentType == 'Others')
                          CustomTextInput(
                              inputController:
                                  controllers['treatmentRegimenOther']
                                      as TextEditingController,
                              labelText: 'Other',
                              type: 'text'),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextInput(
                            inputController:
                                controllers['address'] as TextEditingController,
                            labelText: 'လိပ်စာ',
                            type: 'text'),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextInputWithValidation(
                            inputController:
                                controllers['phone'] as TextEditingController,
                            labelText: 'ဖုန်းနံပါတ်',
                            type: 'number',
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return CustomText.getText(
                                    context, 'ဖုန်းနံပါတ် ဖြည့်ပေးပါ');
                              } else if (value.length < 8 ||
                                  value.length > 11) {
                                return CustomText.getText(
                                    context, 'အချက်အလက်မှားယွင်းနေသည်');
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextInput(
                            inputController: controllers['contactInfo']
                                as TextEditingController,
                            labelText: 'Contact Info',
                            type: 'text'),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextInputWithValidation(
                            inputController: controllers['contactPhone']
                                as TextEditingController,
                            labelText: 'Contact phone no',
                            type: 'number',
                            validate: (value) {
                              if (value == null || value.isEmpty) {
                                return CustomText.getText(
                                    context, 'ဖုန်းနံပါတ် ဖြည့်ပေးပါ');
                              } else if (value.length < 8 ||
                                  value.length > 11) {
                                return CustomText.getText(
                                    context, 'အချက်အလက်မှားယွင်းနေသည်');
                              }
                              return null;
                            }),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextInput(
                            inputController: controllers['primaryLanguage']
                                as TextEditingController,
                            labelText: 'Primary language',
                            type: 'text'),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextInput(
                            inputController: controllers['secondaryLanguage']
                                as TextEditingController,
                            labelText: 'Secondary language',
                            type: 'text'),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextInput(
                            inputController:
                                controllers['height'] as TextEditingController,
                            labelText: 'Height',
                            type: 'number'),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextInput(
                            inputController:
                                controllers['weight'] as TextEditingController,
                            labelText: 'Weight',
                            type: 'text'),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextInput(
                            inputController:
                                controllers['bmi'] as TextEditingController,
                            labelText: 'BMI',
                            type: 'text'),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomSubmitButton(
                          buttonText: widget.data != null
                              ? 'ပြင်မည်'
                              : 'Save',
                          onSubmit: widget.submit,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ]),
                ))));
  }
}
