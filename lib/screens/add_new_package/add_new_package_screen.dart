import 'package:flutter/material.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:sps/common/widgets/form/custom_date_input_with_validation.dart';
import 'package:sps/common/widgets/form/custom_drop_down.dart';
import 'package:sps/common/widgets/form/custom_multi_select_drop_down.dart';
import 'package:sps/common/widgets/form/custom_submit_button.dart';
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
    'Package 1',
    'Package 2',
    'Package 3',
    'Package 4',
    'Package 5',
    'Package 6',
    'Package 7',
    'Package 8',
    'Package 9',
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
                      title: "Support Received Month", // Label text
                      items: const [
                        // List of DropdownMenuItem objects
                        DropdownMenuItem(
                          value: "month_0",
                          child: Text("Month 0"),
                        ),
                        DropdownMenuItem(
                          value: "month_1",
                          child: Text("Month 1"),
                        ),
                      ],
                      selectedData:
                          "month_0", // Currently selected value (optional)
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
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            'Nominated Packages',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomMultiSelectDropdown(
                        options: _options,
                        selectedOptions: _selectedOptions,
                        title: "Packages",
                        onSelectionChanged: (selectedList) {
                          setState(() {
                            _selectedOptions = selectedList;
                          });
                        },
                      ),
                    ],
                  ),
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
                            'Reimbursement Status ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 13),
                          ),
                        ],
                      ),
                    ),
                    CustomDropDown(
                      title: "Reimbursement Status ", // Label text
                      items: const [
                        // List of DropdownMenuItem objects
                        DropdownMenuItem(
                          value: "yes",
                          child: Text("Yes"),
                        ),
                        DropdownMenuItem(
                          value: "no",
                          child: Text("No"),
                        ),
                      ],
                      selectedData: "no", // Currently selected value (optional)
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
                    ),
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
                            'Reimbursement for pervious months',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                        ],
                      ),
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
                          title: "Support Received Month", // Label text
                          items: const [
                            // List of DropdownMenuItem objects
                            DropdownMenuItem(
                              value: "month_0",
                              child: Text("Month 0"),
                            ),
                            DropdownMenuItem(
                              value: "month_1",
                              child: Text("Month 1"),
                            ),
                          ],
                          selectedData:
                              "month_0", // Currently selected value (optional)
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
                                'Packages',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        CustomDropDown(
                          title: "Support Received Month", // Label text
                          items: const [
                            // List of DropdownMenuItem objects
                            DropdownMenuItem(
                              value: "package1",
                              child: Text("Package 1"),
                            ),
                            DropdownMenuItem(
                              value: "package2",
                              child: Text("Package 2"),
                            ),
                          ],
                          selectedData:
                              "package1", // Currently selected value (optional)
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
                    const Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Eligible Amount',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "32920",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                                'Given Amount',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        CustomTextInput(
                          inputController: _heightController,
                          labelText: "Enter Given Amount",
                          type: "number",
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    CustomSubmitButton(buttonText: "Add", onSubmit: () {}),
                    const SizedBox(
                      height: 20,
                    ),
                    Table(
                      border: TableBorder.all(),
                      children: [
                        const TableRow(
                          children: [
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('No'),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Month'),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Packages'),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Month Year'),
                              ),
                            ),
                            TableCell(
                              verticalAlignment:
                                  TableCellVerticalAlignment.middle,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Delete'),
                              ),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('1'),
                              ),
                            ),
                            const TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Month-0'),
                              ),
                            ),
                            const TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Package 7'),
                              ),
                            ),
                            const TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('2024-10'),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {},
                                  )),
                            ),
                          ],
                        ),
                        TableRow(
                          children: [
                            const TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('1'),
                              ),
                            ),
                            const TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Month-0'),
                              ),
                            ),
                            const TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Package 7'),
                              ),
                            ),
                            const TableCell(
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('2024-10'),
                              ),
                            ),
                            TableCell(
                              child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: IconButton(
                                    icon: const Icon(Icons.delete),
                                    onPressed: () {},
                                  )),
                            ),
                          ],
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
                                'Received Packages this month',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        CustomDropDown(
                          title: "Received Packages this month", // Label text
                          items: const [
                            // List of DropdownMenuItem objects
                            DropdownMenuItem(
                              value: "yes",
                              child: Text("Yes"),
                            ),
                            DropdownMenuItem(
                              value: "no",
                              child: Text("No"),
                            ),
                          ],
                          selectedData:
                              "no", // Currently selected value (optional)
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
                                'Packages',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        CustomDropDown(
                          title: "Support Received Month", // Label text
                          items: const [
                            // List of DropdownMenuItem objects
                            DropdownMenuItem(
                              value: "package1",
                              child: Text("Package 1"),
                            ),
                            DropdownMenuItem(
                              value: "package2",
                              child: Text("Package 2"),
                            ),
                          ],
                          selectedData:
                              "package1", // Currently selected value (optional)
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
                    const Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Eligible Amount',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        Card(
                          elevation: 5,
                          child: Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "8593930",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
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
                                'Given Amount',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        CustomTextInput(
                          inputController: _heightController,
                          labelText: "Enter Given Amount",
                          type: "number",
                        )
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
