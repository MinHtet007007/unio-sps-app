import 'package:flutter/material.dart';
import 'package:sps/common/constants/form_options.dart';
import 'package:sps/common/widgets/form/custom_date_input_with_validation.dart';
import 'package:sps/common/widgets/form/custom_drop_down.dart';
import 'package:sps/common/widgets/form/custom_multi_select_drop_down.dart';
import 'package:sps/common/widgets/form/custom_submit_button.dart';
import 'package:sps/common/widgets/form/custom_text_input.dart';
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/local_database/entity/patient_package_entity.dart';
import 'package:sps/local_database/entity/support_month_entity.dart';

class AddNewPackageForm extends StatefulWidget {
  final PatientEntity patientDetails;
  final List<SupportMonthEntity> patientSupportMonths;
  final List<PatientPackageEntity> patientPackages;

  const AddNewPackageForm({
    super.key,
    required this.patientDetails,
    required this.patientPackages,
    required this.patientSupportMonths,
  });

  @override
  State<AddNewPackageForm> createState() => _AddNewPackageFormState();
}

class _AddNewPackageFormState extends State<AddNewPackageForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _monthYearController = TextEditingController();
  final TextEditingController _reimbursementMonthYearController =
      TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  final TextEditingController _reimbursementWeightController =
      TextEditingController();
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _reimbursementGivenAmountController =
      TextEditingController();
  DateTime? maxDate;
  double BMI = 0.0;
  double reimbursementBMI = 0.0;
  List<DropdownMenuItem<String>> supportMonthsOptions = supportMonths;
  String? reimbursementStatus;
  String? selectedMonth;
  String? selectedReimbursementMonth;
  String? selectedReimbursementPackageId;
  int selectedReimbursementPackageEligibleAmount = 0;
  int tempGivenAmountStorage = 0;
  late List<PatientPackageEntity> _editablePatientPackages;
  List<Map<String, dynamic>> selectedReimbursements = [];

  List<String> _selectedOptions = [];

  void _calculateBMI({bool isReimbursement = false}) {
    // Extract values once
    final weightText = isReimbursement
        ? _reimbursementWeightController.text
        : _weightController.text;
    final height = (widget.patientDetails.height) * 0.01;

    // Validate and parse weight only if needed
    if (weightText.isNotEmpty) {
      final weight = double.tryParse(weightText) ?? 0.0;
      if (weight > 0 && height > 0) {
        final bmi = weight / (height * height);
        setState(() {
          isReimbursement ? reimbursementBMI = bmi : BMI = bmi;
        });
      } else {
        setState(() {
          isReimbursement
              ? reimbursementBMI = 0.0
              : BMI = 0.0; // Reset BMI if invalid
        });
      }
    } else {
      setState(() {
        isReimbursement
            ? reimbursementBMI = 0.0
            : BMI = 0.0; // Reset BMI if empty
      });
    }
  }

  String calculateBMIInText(double value) {
    if (value <= 0) {
      return '';
    } else if (value > 0 && value <= 18.5) {
      return '(Underweight)';
    } else if (value >= 18.5 && value <= 24.5) {
      return '(Healthy)';
    } else if (value > 24.5 && value <= 29.5) {
      return '(Overweight)';
    } else if (value > 29.5 && value <= 39.5) {
      return '(Obese)';
    } else {
      return '(Extremely Obese)';
    }
  }

  void _handleAddReimbursement() {
    setState(() {
      selectedReimbursements = [
        ...selectedReimbursements,
        {
          "reimbursement_month": selectedReimbursementMonth == -1
              ? "Pre-enroll Month"
              : "Month-$selectedReimbursementMonth",
          "given_amount":
              int.tryParse(_reimbursementGivenAmountController.text) ?? 0,
          "reimbursement_packages": 'Package $selectedReimbursementPackageId',
          "reimbursement_month_year": _reimbursementMonthYearController.text,
          "package_id": selectedReimbursementPackageId, // Example ID
        }
      ];
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _editablePatientPackages = List.from(widget.patientPackages);
    _weightController.addListener(_calculateBMI);
    _reimbursementWeightController.addListener(() {
      _calculateBMI(isReimbursement: true);
    });

    // Add listener to update the eligible amount
    _reimbursementGivenAmountController.addListener(() {
      setState(() {
        final inputText = _reimbursementGivenAmountController.text;
        final inputValue = int.tryParse(inputText) ?? 0;

        // Adjust eligible amount dynamically
        selectedReimbursementPackageEligibleAmount +=
            (tempGivenAmountStorage - inputValue);

        // Update last input value
        tempGivenAmountStorage = inputValue;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // TextButton(
          //     onPressed: () =>
          //         debugPrint(_reimbursementWeightController.text),
          //     child: const Text("Print")),
          Padding(
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
                        onDateChanged: (selectedDate) {
                          setState(() {
                            maxDate = selectedDate;
                          });
                        },
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
                        items: widget.patientSupportMonths.isNotEmpty
                            ? supportMonthsOptions.where((el) {
                                final lastSupportMonth =
                                    widget.patientSupportMonths.last;
                                if (el.value == null) {
                                  return false;
                                }
                                return lastSupportMonth.month <
                                    int.parse(el.value!);
                              }).toList()
                            : supportMonthsOptions,
                        selectedData:
                            selectedMonth, // Currently selected value (optional)
                        hintText:
                            "Support Received Month", // Hint text displayed when nothing is selected (optional)
                        onChanged: (value) {
                          // Callback function when selection changes (optional)
                          // print("Selected: $value");
                          setState(() {
                            selectedMonth = value;
                          });
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
                        labelText: 'Support Received Month',
                        date: '2000-01-01',
                        maxDate: maxDate,
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
                      Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.patientDetails.height}',
                                  style: const TextStyle(
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
                              'Weight(kg)',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      CustomTextInput(
                        inputController: _weightController,
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
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'BMI ${calculateBMIInText(BMI)}',
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      Card(
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  BMI.toStringAsFixed(2),
                                  style: const TextStyle(
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
                          options: _editablePatientPackages
                              .map((p) => p.packageName)
                              .toList(),
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
                        selectedData:
                            "no", // Currently selected value (optional)
                        hintText:
                            "Select...", // Hint text displayed when nothing is selected (optional)
                        onChanged: (value) {
                          // Callback function when selection changes (optional)
                          setState(() {
                            reimbursementStatus = value;
                          });
                        },
                        isRequired:
                            false, // Whether the selection is mandatory (optional, defaults to true)
                      )
                    ],
                  ),
                  if (reimbursementStatus == 'yes')
                    Column(
                      children: [
                        Column(
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Height(cm)',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${widget.patientDetails.height}',
                                        style: const TextStyle(
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
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Weight(kg)',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            CustomTextInput(
                              inputController: _reimbursementWeightController,
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
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'BMI ${calculateBMIInText(reimbursementBMI)}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13),
                                  ),
                                ],
                              ),
                            ),
                            Card(
                              elevation: 5,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        reimbursementBMI.toStringAsFixed(2),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    'Reimbursement for pervious months',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Month',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                CustomDropDown(
                                  title: "Support Received Month", // Label text
                                  items: supportMonthsOptions.where((month) {
                                    return selectedMonth != null &&
                                        int.parse(month.value!) <
                                            int.parse(selectedMonth!);
                                  }).toList(),
                                  selectedData:
                                      selectedReimbursementMonth, // Currently selected value (optional)
                                  hintText:
                                      "Select...", // Hint text displayed when nothing is selected (optional)
                                  onChanged: (value) {
                                    // Callback function when selection changes (optional)
                                    // print("Selected: $value");
                                    setState(() {
                                      selectedReimbursementMonth = value;
                                    });
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
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Month Year',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                CustomDateInputWithValidation(
                                  dateController:
                                      _reimbursementMonthYearController,
                                  labelText: 'Support Received Month',
                                  date: '2000-01-01',
                                  isMonthYear: true,
                                  maxDate: maxDate,
                                ),
                              ],
                            ),
                            Column(
                              children: [
                                const SizedBox(
                                  height: 20,
                                ),
                                const Padding(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Packages',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13),
                                      ),
                                    ],
                                  ),
                                ),
                                CustomDropDown(
                                  title: "Packages", // Label text
                                  items: _editablePatientPackages.map((d) {
                                    return DropdownMenuItem<String>(
                                      value: d.id.toString(),
                                      child: Text(d.packageName),
                                    );
                                  }).toList(),
                                  selectedData:
                                      selectedReimbursementPackageId, // Currently selected value (optional)
                                  hintText:
                                      "Select...", // Hint text displayed when nothing is selected (optional)
                                  onChanged: (value) {
                                    // Callback function when selection changes (optional)
                                    // print("Selected: $value");
                                    setState(() {
                                      PatientPackageEntity?
                                          reimbursementSelectedPackage =
                                          _editablePatientPackages.firstWhere(
                                              (package) =>
                                                  package.id ==
                                                  int.parse(value));
                                      selectedReimbursementPackageId = value;
                                      selectedReimbursementPackageEligibleAmount =
                                          reimbursementSelectedPackage
                                              .eligibleAmount;
                                    });
                                  },
                                  isRequired:
                                      false, // Whether the selection is mandatory (optional, defaults to true)
                                )
                              ],
                            ),
                            if (selectedReimbursementPackageId != null)
                              Column(
                                children: [
                                  Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      const Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Eligible Amount',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Card(
                                        elevation: 5,
                                        child: Padding(
                                          padding: const EdgeInsets.all(16.0),
                                          child: Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  selectedReimbursementPackageEligibleAmount
                                                      .toString(),
                                                  style: const TextStyle(
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
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10, vertical: 5),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Given Amount',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 13),
                                            ),
                                          ],
                                        ),
                                      ),
                                      CustomTextInput(
                                        inputController:
                                            _reimbursementGivenAmountController,
                                        labelText: "Enter Given Amount",
                                        type: "number",
                                      )
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  CustomSubmitButton(
                                      buttonText: "Add",
                                      onSubmit: () {
                                        _handleAddReimbursement();
                                      }),
                                ],
                              ),
                            const SizedBox(
                              height: 20,
                            ),
                            if (selectedReimbursements.isNotEmpty)
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
                                          child: Text('Given Amount'),
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
                                  ...selectedReimbursements
                                      .asMap()
                                      .entries
                                      .map((entry) {
                                    int index = entry.key;
                                    var item = entry.value;
                                    return TableRow(
                                      children: [
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text('${index + 1}'),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                '${item['reimbursement_month']}'),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                '${item['reimbursement_packages']}'),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child:
                                                Text('${item['given_amount']}'),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(
                                                '${item['reimbursement_month_year']}'),
                                          ),
                                        ),
                                        TableCell(
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: IconButton(
                                                icon: const Icon(Icons.delete),
                                                onPressed: () {},
                                              )),
                                        ),
                                      ],
                                    );
                                  }),
                                ],
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
                              child: Text('Packages'),
                            ),
                          ),
                          TableCell(
                            verticalAlignment:
                                TableCellVerticalAlignment.middle,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Given Amount'),
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
                              child: Text('Package 7'),
                            ),
                          ),
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('7888787'),
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
                              child: Text('Package 7'),
                            ),
                          ),
                          const TableCell(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('7888787'),
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
                              'Grand Total',
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
                              'Remark',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      CustomTextInput(
                        inputController: _heightController,
                        labelText: "Enter remark",
                        type: "textarea",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      CustomSubmitButton(
                          buttonText: "Save",
                          onSubmit: () {
                            // debugPrint(_dateController.text);
                          }),
                      const SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
