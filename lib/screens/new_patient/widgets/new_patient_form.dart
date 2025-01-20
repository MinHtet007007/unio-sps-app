import 'package:flutter/material.dart';
import 'package:sps/common/constants/form_options.dart';
import 'package:sps/common/widgets/bmi.dart';
import 'package:sps/common/widgets/custom_text.dart';
import 'package:sps/common/widgets/form/custom_date_input.dart';
import 'package:sps/common/widgets/form/custom_drop_down.dart';
import 'package:sps/common/widgets/form/custom_submit_button.dart';
import 'package:sps/common/widgets/form/custom_text_input.dart';
import 'package:sps/common/widgets/form/custom_text_input_with_validation.dart';

class NewPatientForm extends StatefulWidget {
  Future<void> Function(Map<String, dynamic> formData) onSubmit;

  List<DropdownMenuItem<String>> townshipOptions;

  NewPatientForm(
      {super.key, required this.onSubmit, required this.townshipOptions});
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
        'treatmentRegimen': selectedDiedBeforeTreatmentEnrollment == 'No'
            ? selectedTreatmentRegimen
            : '',
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
        'weight': double.parse(
            double.parse(controllers['weight']!.text).toStringAsFixed(2)),
        'height': double.parse(
            double.parse(controllers['height']!.text).toStringAsFixed(2)),
      };

      // Example: Save or print the collected data
      print('Form Data: $formData');
      widget.onSubmit(formData);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13.0, vertical: 20),
            child: Form(
              key: _formKey,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomDropDown(
                      title: 'Year',
                      items: years,
                      selectedData: selectedYear,
                      hintText: 'Year',
                      onChanged: ((value) {
                        setState(() {
                          selectedYear = value;
                        });
                      }),
                    ),
                    const SizedBox(height: 10),
                    CustomDropDown(
                      title: 'Township',
                      items: widget.townshipOptions,
                      selectedData: selectedTownship,
                      hintText: 'Township',
                      onChanged: ((value) {
                        setState(() {
                          selectedTownship = value;
                        });
                      }),
                    ),
                    CustomDateInput(
                      dateController:
                          controllers['spsStartDate'] as TextEditingController,
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
                        inputController:
                            controllers['drtbCode'] as TextEditingController,
                        labelText: 'DRTB code',
                        isRequired: controllers['rrCode']!.text.isEmpty),
                    const SizedBox(height: 10),
                    CustomTextInput(
                        inputController:
                            controllers['name'] as TextEditingController,
                        labelText: 'Name',
                        type: 'text',
                        isRequired: true),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextInputWithValidation(
                        inputController:
                            controllers['age'] as TextEditingController,
                        labelText: 'Age',
                        type: 'number',
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return CustomText.getText(
                                context, 'Age is required');
                          } else if (int.parse(value) < 1 ||
                              int.parse(value) > 120) {
                            return CustomText.getText(
                                context, 'Age must be between 1 and 120');
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomDropDown(
                      title: 'Gender',
                      items: genders,
                      selectedData: selectedSex,
                      hintText: 'Gender',
                      onChanged: ((value) {
                        setState(() {
                          selectedSex = value;
                        });
                      }),
                    ),
                    const SizedBox(height: 10),
                    CustomDropDown(
                      title: 'Died before treatment enrollment',
                      items: yesOrNoOptions,
                      selectedData: selectedDiedBeforeTreatmentEnrollment,
                      hintText: 'died before treatment enrollment',
                      onChanged: ((value) {
                        setState(() {
                          selectedDiedBeforeTreatmentEnrollment = value;
                        });
                      }),
                    ),
                    if (selectedDiedBeforeTreatmentEnrollment == 'No')
                      Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          CustomDropDown(
                            title: 'Treatment Regimen',
                            items: treatmentRegimenOptions,
                            selectedData: selectedTreatmentRegimen,
                            hintText: 'Treatment Regimen',
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
                        ],
                      ),
                    const SizedBox(height: 10),
                    CustomDateInput(
                      dateController: controllers['treatmentStartDate']
                          as TextEditingController,
                      labelText: 'Treatment start date',
                    ),
                    const SizedBox(height: 10),
                    CustomTextInput(
                        inputController:
                            controllers['address'] as TextEditingController,
                        labelText: 'Address',
                        type: 'text',
                        isRequired: true),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextInputWithValidation(
                        inputController:
                            controllers['phone'] as TextEditingController,
                        labelText: 'Phone',
                        type: 'number',
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return CustomText.getText(
                                context, 'Phone is required');
                          } else if (value.length < 8 || value.length > 11) {
                            return CustomText.getText(
                                context, 'Phone number is invalid');
                          }
                          return null;
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextInput(
                        inputController:
                            controllers['contactInfo'] as TextEditingController,
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
                                context, 'Phone number is required');
                          } else if (value.length < 8 || value.length > 11) {
                            return CustomText.getText(
                                context, 'Phone number is invalid');
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
                    CustomTextInputWithValidation(
                        inputController:
                            controllers['height'] as TextEditingController,
                        labelText: 'Height',
                        type: 'number',
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return CustomText.getText(
                                context, 'Height is required');
                          } else {
                            double? height = double.tryParse(value);
                            if (height == null) {
                              return CustomText.getText(
                                  context, 'Invalid height');
                            } else if (height > 251) {
                              return CustomText.getText(context,
                                  'Height must be less than or equal to 251');
                            }
                            return null;
                          }
                        }),
                    const SizedBox(
                      height: 10,
                    ),
                    CustomTextInputWithValidation(
                        inputController:
                            controllers['weight'] as TextEditingController,
                        labelText: 'Weight',
                        type: 'number',
                        validate: (value) {
                          if (value == null || value.isEmpty) {
                            return CustomText.getText(
                                context, 'Weight is required');
                          } else  {
                            double? weight = double.tryParse(value);
                            if (weight == null) {
                              return CustomText.getText(
                                  context, 'Invalid weight');
                            } else if (weight > 635) {
                              return CustomText.getText(context,
                                  'Weight must be less than or equal to 635');
                            }
                            return null;
                          }
                        }),
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
                      buttonText: 'Save',
                      onSubmit: onSave,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ]),
            )));
  }
}
