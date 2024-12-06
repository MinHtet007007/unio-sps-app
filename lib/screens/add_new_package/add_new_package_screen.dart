import 'package:flutter/material.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:sps/common/widgets/form/custom_date_input_with_validation.dart';
import 'package:sps/common/widgets/form/custom_drop_down.dart';
import 'package:sps/common/widgets/form/custom_multi_select_drop_down.dart';
import 'package:sps/common/widgets/form/custom_text_input.dart';

class AddNewPackageScreen extends StatefulWidget {
  final int patientId;
  const AddNewPackageScreen({super.key, required this.patientId});

  @override
  State<AddNewPackageScreen> createState() => _AddNewPackageScreenState();
}

class _AddNewPackageScreenState extends State<AddNewPackageScreen> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _monthYearController = TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  final List<String> _options = [
    "Apple",
    "Banana",
    "Orange",
    "Grapes",
    "Mango"
  ];
  List<String> _selectedOptions = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomLabelWidget(
          text: "Create Package",
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: ColorTheme.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Column(
                  children: [
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Support Received Date',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    CustomDateInputWithValidation(
                      dateController: _dateController,
                      labelText: 'Support Received Date',
                      date: '2000-01-01',
                    ),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Support Received Month',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    CustomDropDown(
                      title: "Select an option", // Label text
                      items: const [
                        // List of DropdownMenuItem objects
                        DropdownMenuItem(
                          value: "value1",
                          child: Text("Option 1"),
                        ),
                        DropdownMenuItem(
                          value: "value2",
                          child: Text("Option 2"),
                        ),
                      ],
                      selectedData:
                          "value1", // Currently selected value (optional)
                      hintText:
                          "Select...", // Hint text displayed when nothing is selected (optional)
                      onChanged: (value) {
                        // Callback function when selection changes (optional)
                        print("Selected: $value");
                      },
                      isRequired:
                          false, // Whether the selection is mandatory (optional, defaults to true)
                    )
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Month Year',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    CustomDateInputWithValidation(
                      dateController: _monthYearController,
                      labelText: 'Support Received Date',
                      date: '2000-01-01',
                      isMonthYear: true,
                    ),
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Height(cm)',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    CustomTextInput(
                      inputController: _heightController,
                      labelText: "Enter Height(cm)",
                      type: "number",
                      readOnly: true,
                    )
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Weight(kg)',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    CustomTextInput(
                      inputController: _heightController,
                      labelText: "Enter Weight(kg)",
                      type: "number",
                    )
                  ],
                ),
                Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    const Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'BMI',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    CustomTextInput(
                      inputController: _heightController,
                      labelText: "Enter BMI",
                      type: "number",
                      readOnly: true,
                    )
                  ],
                ),
                CustomMultiSelectDropdown(
                  options: _options,
                  selectedOptions: _selectedOptions,
                  title: "Fruits",
                  onSelectionChanged: (selectedList) {
                    setState(() {
                      _selectedOptions = selectedList;
                    });
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
