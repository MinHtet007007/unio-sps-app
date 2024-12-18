import 'package:flutter/material.dart';
import 'package:sps/common/constants/form_options.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/bmi.dart';
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
  Future<void> Function(Map<String, dynamic> formData) onSubmit;

  List<DropdownMenuItem<String>> townshipOptions;

  NewPatientForm(
      {super.key,
      required this.onSubmit,
      this.data,
      required this.townshipOptions});
  @override
  State<NewPatientForm> createState() => _NewPatientFormState();
}

class _NewPatientFormState extends State<NewPatientForm> {
  String? selectedYear;
  String? selectedSex;
  String? selectedTownship;
  String? selectedDiedBeforeTreatmentEnrollment;
  String? selectedTreatmentRegimen;
   double? bmi;

  // Controllers
  final Map<String, TextEditingController> controllers = {
    'name': TextEditingController(),
    'age': TextEditingController(),
    'phone': TextEditingController(),
    'address': TextEditingController(),
    'rrCode': TextEditingController(),
    'drtbCode': TextEditingController(),
    'spsStartDate': TextEditingController(),
    'treatmentStartDate': TextEditingController(),
    'treatmentRegimenOther': TextEditingController(),
    'contactInfo': TextEditingController(),
    'contactPhone': TextEditingController(),
    'primaryLanguage': TextEditingController(),
    'secondaryLanguage': TextEditingController(),
    'height': TextEditingController(),
    'weight': TextEditingController(),
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
    //   selectedTreatmentRegimen = data.regimen_type;
    //   phoneController.text = data.phone;
    // }
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    controllers['rrCode']!.addListener(_updateState);
    controllers['drtbCode']!.addListener(_updateState);
  }

  void _updateState() {
    setState(() {}); // Trigger a rebuild when either controller changes
  }

  void onSave() {
    if (_formKey.currentState!.validate()) {
      // Collect the dropdown-selected values
      final Map<String, dynamic> selectedValues = {
        'year': selectedYear,
        'sex': selectedSex,
        'townshipId': selectedTownship,
        'diedBeforeTreatmentEnrollment': selectedDiedBeforeTreatmentEnrollment,
        'treatmentRegimen': selectedTreatmentRegimen,
        'bmi': bmi
      };

      // Collect the input field values
      final Map<String, String> inputValues =
          controllers.map((key, controller) {
        return MapEntry(key, controller.text.trim());
      });

      // Combine the data
      final Map<String, dynamic> formData = {
        ...selectedValues,
        ...inputValues,
      };

      // Example: Save or print the collected data
      print('Form Data: $formData');
      widget.onSubmit(formData);
    }
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
                        CustomDropDown(
                          title: 'မြို့နယ်',
                          items: widget.townshipOptions,
                          selectedData: selectedTownship,
                          hintText: 'မြို့နယ်',
                          onChanged: ((value) {
                            setState(() {
                              selectedTownship = value;
                            });
                          }),
                        ),
                        CustomDateInput(
                          dateController: controllers['spsStartDate']
                              as TextEditingController,
                          labelText: 'SPS start date',
                        ),
                        const SizedBox(height: 10),
                        CustomTextInput(
                          inputController:
                              controllers['rrCode'] as TextEditingController,
                          labelText: 'RR code',
                          isRequired: controllers['drtbCode']!.text.isEmpty,
                        ),
                        const SizedBox(height: 10),
                        CustomTextInput(
                            inputController: controllers['drtbCode']
                                as TextEditingController,
                            labelText: 'DRTB code',
                            isRequired: controllers['rrCode']!.text.isEmpty),
                        const SizedBox(height: 10),
                        // CustomTextInput(
                        //     inputController:
                        //         controllers['spCode'] as TextEditingController,
                        //     labelText: 'SP code'),
                        const SizedBox(height: 10),
                        CustomTextInput(
                            inputController:
                                controllers['name'] as TextEditingController,
                            labelText: 'နာမည်',
                            type: 'text',
                            isRequired: true),
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
                          selectedData: selectedTreatmentRegimen,
                          hintText: 'ကုထုံးအမျိုးအစား',
                          onChanged: ((value) {
                            setState(() {
                              selectedTreatmentRegimen = value;
                            });
                          }),
                        ),
                        const SizedBox(height: 10),
                        if (selectedTreatmentRegimen == treatmentRegimenOther)
                          CustomTextInput(
                              inputController:
                                  controllers['treatmentRegimenOther']
                                      as TextEditingController,
                              labelText: 'Treatment Regimen Other',
                              type: 'text'),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextInput(
                            inputController:
                                controllers['address'] as TextEditingController,
                            labelText: 'လိပ်စာ',
                            type: 'text',
                            isRequired: true),
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
                            type: 'text',
                            isRequired: true),
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
                            type: 'text',
                            isRequired: true),
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
                            type: 'number',
                            isRequired: true),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomTextInput(
                            inputController:
                                controllers['weight'] as TextEditingController,
                            labelText: 'Weight',
                            type: 'number',
                            isRequired: true),
                        const SizedBox(
                          height: 10,
                        ),

                        BMI(
                          heightController: controllers['height']!,
                          weightController: controllers['weight']!,
                          bmi: bmi,
                          onBMIChange: (value) => {
                            setState(() {
                              bmi = value;
                            })
                          },
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        CustomSubmitButton(
                          buttonText: widget.data != null ? 'ပြင်မည်' : 'Save',
                          onSubmit: onSave,
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ]),
                ))));
  }
}
