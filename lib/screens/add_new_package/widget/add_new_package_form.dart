import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:sps/common/constants/form_options.dart';
import 'package:sps/common/widgets/form/custom_date_input_with_validation.dart';
import 'package:sps/common/widgets/form/custom_drop_down.dart';
import 'package:sps/common/widgets/form/custom_multi_select_drop_down.dart';
import 'package:sps/common/widgets/form/custom_submit_button.dart';
import 'package:sps/common/widgets/form/custom_text_input.dart';
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/local_database/entity/patient_package_entity.dart';
import 'package:sps/local_database/entity/receive_package_entity.dart';
import 'package:sps/local_database/entity/support_month_entity.dart';
import 'package:sps/screens/add_new_package/widget/reimbursement_table.dart';

class AddNewPackageForm extends StatefulWidget {
  final PatientEntity patientDetails;
  final List<SupportMonthEntity> patientSupportMonths;
  final List<PatientPackageEntity> patientPackages;
  Future<void> Function(SupportMonthEntity formData,
      List<ReceivePackageEntity> receivedPackages) onSubmit;

  AddNewPackageForm({
    super.key,
    required this.patientDetails,
    required this.patientPackages,
    required this.patientSupportMonths,
    required this.onSubmit,
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
  final TextEditingController _remarkController = TextEditingController();
  final TextEditingController _reimbursementGivenAmountController =
      TextEditingController();
  final TextEditingController _receivedPackageThisMonthGivenAmountController =
      TextEditingController();
  SignatureController signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.white,
    exportPenColor: Colors.white,
    exportBackgroundColor: Colors.black,
  );
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
  String? selectedReceivedPackageStatus;
  String? selectedReceivedPackageId;
  int selectedPackageEligibleAmount = 0;
  List<Map<String, dynamic>> selectedSupportReceivedMonthPackages = [];
  List<String> _selectedPlanPackages = [];
  int grandTotal = 0;
  Uint8List? sign;

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
    // Calculate the given amount
    int givenAmount =
        int.tryParse(_reimbursementGivenAmountController.text) ?? 0;

    // Find the package by its ID
    PatientPackageEntity? packageToUpdate = _editablePatientPackages.firstWhere(
        (package) => package.id == int.parse(selectedReimbursementPackageId!));

    // Update the eligible amount in the package
    packageToUpdate = PatientPackageEntity(
      id: packageToUpdate.id,
      remoteId: packageToUpdate.remoteId,
      localPatientId: packageToUpdate.localPatientId,
      remotePatientId: packageToUpdate.remotePatientId,
      packageName: packageToUpdate.packageName,
      eligibleAmount: packageToUpdate.eligibleAmount, // Deduct given amount
      updatedEligibleAmount: packageToUpdate.updatedEligibleAmount,
      remainingAmount: packageToUpdate.remainingAmount - givenAmount,
    );

    // Update the package in the list
    int index = _editablePatientPackages
        .indexWhere((pkg) => pkg.id == packageToUpdate?.id);
    if (index != -1) {
      _editablePatientPackages[index] = packageToUpdate;
    }

    setState(() {
      selectedReimbursements = [
        ...selectedReimbursements,
        {
          "reimbursement_month": selectedReimbursementMonth,
          "given_amount": givenAmount,
          "reimbursement_packages": packageToUpdate?.packageName,
          "reimbursement_month_year": _reimbursementMonthYearController.text,
          "package_id": selectedReimbursementPackageId, // Example ID
        }
      ];
      int selectedReimbursementsTotalGivenAmount = selectedReimbursements.fold(
        0,
        (sum, item) => sum + (item['given_amount'] as int),
      );
      int selectedSupportReceivedMonthPackagesTotalGivenAmount =
          selectedSupportReceivedMonthPackages.fold(
        0,
        (sum, item) => sum + (item['given_amount'] as int),
      );
      grandTotal = selectedReimbursementsTotalGivenAmount +
          selectedSupportReceivedMonthPackagesTotalGivenAmount;
    });

    selectedReimbursementMonth = null;
    _reimbursementMonthYearController.clear();
    selectedReimbursementPackageId = null;
    _reimbursementGivenAmountController.clear();
    tempGivenAmountStorage = 0;
  }

  void _handleAddSupportReceivedMonthPackages() {
    // Calculate the given amount
    int givenAmount =
        int.tryParse(_receivedPackageThisMonthGivenAmountController.text) ?? 0;

    // Find the package by its ID
    PatientPackageEntity? packageToUpdate = _editablePatientPackages.firstWhere(
        (package) => package.id == int.parse(selectedReceivedPackageId!));

    // Update the eligible amount in the package
    packageToUpdate = PatientPackageEntity(
      id: packageToUpdate.id,
      remoteId: packageToUpdate.remoteId,
      localPatientId: packageToUpdate.localPatientId,
      remotePatientId: packageToUpdate.remotePatientId,
      packageName: packageToUpdate.packageName,
      eligibleAmount: packageToUpdate.eligibleAmount, // Deduct given amount
      updatedEligibleAmount: packageToUpdate.updatedEligibleAmount,
      remainingAmount: packageToUpdate.remainingAmount - givenAmount,
    );

    // Update the package in the list
    int index = _editablePatientPackages
        .indexWhere((pkg) => pkg.id == packageToUpdate?.id);
    if (index != -1) {
      _editablePatientPackages[index] = packageToUpdate;
    }

    setState(() {
      selectedSupportReceivedMonthPackages = [
        ...selectedSupportReceivedMonthPackages,
        {
          "given_amount": givenAmount,
          "package": packageToUpdate?.packageName,
          "package_id": selectedReceivedPackageId, // Example ID
        }
      ];
      int selectedReimbursementsTotalGivenAmount = selectedReimbursements.fold(
        0,
        (sum, item) => sum + (item['given_amount'] as int),
      );
      int selectedSupportReceivedMonthPackagesTotalGivenAmount =
          selectedSupportReceivedMonthPackages.fold(
        0,
        (sum, item) => sum + (item['given_amount'] as int),
      );
      grandTotal = selectedReimbursementsTotalGivenAmount +
          selectedSupportReceivedMonthPackagesTotalGivenAmount;
    });

    selectedReceivedPackageId = null;
    _receivedPackageThisMonthGivenAmountController.clear();
    tempGivenAmountStorage = 0;
  }

  void onSave() async {
    if (_formKey.currentState!.validate()) {
      SupportMonthEntity formData = SupportMonthEntity(
          localPatientId: widget.patientDetails.id!,
          remotePatientId: widget.patientDetails.remoteId,
          patientName: widget.patientDetails.name,
          townshipId: widget.patientDetails.townshipId,
          date: _dateController.text,
          month: int.parse(selectedMonth!),
          monthYear: _monthYearController.text,
          height: widget.patientDetails.height,
          weight: int.parse(_weightController.text),
          bmi: BMI.toInt(),
          planPackages: _selectedPlanPackages
              .map((package) => package.replaceAll(RegExp(r'[^0-9]'), ''))
              .where((number) => number.isNotEmpty)
              .join(','),
          receivePackageStatus: selectedReceivedPackageStatus!,
          reimbursementStatus: reimbursementStatus!,
          isSynced: false,
          remark: _remarkController.text,
          supportMonthSignature: sign);

      List<ReceivePackageEntity> receivedPackages = [];

      // Conditionally add data to receivedPackages
      if (selectedReceivedPackageStatus == "yes") {
        receivedPackages = [
          // Add support received month packages
          ...selectedSupportReceivedMonthPackages.map((d) =>
              ReceivePackageEntity(
                  localPatientPackageId: int.parse(d["package_id"]),
                  amount: d["given_amount"],
                  localPatientSupportMonthId: 0, // TODO
                  patientPackageName: d["package"],
                  reimbursementMonth: null,
                  reimbursementMonthYear: null)),
          // Add reimbursements
          ...selectedReimbursements.map((d) => ReceivePackageEntity(
              localPatientPackageId: int.parse(d["package_id"]),
              amount: d["given_amount"],
              localPatientSupportMonthId: 0, // TODO
              patientPackageName: d["reimbursement_packages"],
              reimbursementMonth: int.parse(d["reimbursement_month"]),
              reimbursementMonthYear: d["reimbursement_month_year"])),
        ];
      } else {
        receivedPackages = [
          ...selectedReimbursements.map((d) => ReceivePackageEntity(
              localPatientPackageId: int.parse(d["package_id"]),
              amount: d["given_amount"],
              localPatientSupportMonthId: 0, // TODO
              patientPackageName: d["reimbursement_packages"],
              reimbursementMonth: int.parse(d["reimbursement_month"]),
              reimbursementMonthYear: d["reimbursement_month_year"])),
        ];
      }
      widget.onSubmit(formData, receivedPackages);
      // debugPrint(receivedPackages.toString());
      // debugPrint("pass form");
    }
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
    _receivedPackageThisMonthGivenAmountController.addListener(() {
      setState(() {
        final inputText = _receivedPackageThisMonthGivenAmountController.text;
        final inputValue = int.tryParse(inputText) ?? 0;

        // Adjust eligible amount dynamically
        selectedPackageEligibleAmount += (tempGivenAmountStorage - inputValue);

        // Update last input value
        tempGivenAmountStorage = inputValue;
      });
    });

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
          //     onPressed: () {
          //       String result = _selectedPlanPackages
          //           .map((package) => package.replaceAll(
          //               RegExp(r'[^0-9]'), '')) // Extract numbers
          //           .where((number) =>
          //               number.isNotEmpty) // Filter out empty results
          //           .join(',');
          //       debugPrint(_selectedPlanPackages
          //           .map((package) => package.replaceAll(
          //               RegExp(r'[^0-9]'), '')) // Extract numbers
          //           .where((number) =>
          //               number.isNotEmpty) // Filter out empty results
          //           .join(','));
          //     },
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
                            true, // Whether the selection is mandatory (optional, defaults to true)
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
                        isRequired: true,
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
                          selectedOptions: _selectedPlanPackages,
                          title: "Packages",
                          onSelectionChanged: (selectedList) {
                            setState(() {
                              _selectedPlanPackages = selectedList;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please select at least one option.";
                            }
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  if (selectedMonth != null)
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
                              reimbursementStatus, // Currently selected value (optional)
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
                                  title: "Month", // Label text
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
                                  isRequired: false,
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
                                      "Select Package...", // Hint text displayed when nothing is selected (optional)
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
                                              .remainingAmount;
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
                                        maxValue: _editablePatientPackages
                                            .firstWhere((d) =>
                                                d.id ==
                                                int.parse(
                                                    selectedReimbursementPackageId!))
                                            .remainingAmount,
                                      )
                                    ],
                                  ),
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
                            const SizedBox(
                              height: 20,
                            ),
                            if (selectedReimbursements.isNotEmpty)
                              // ReimbursementTable(
                              //     selectedReimbursements:
                              //         selectedReimbursements,
                              //     editablePatientPackages:
                              //         _editablePatientPackages,
                              //     onDeleteReimbursement:
                              //         (int index, int reimbursementTotal) {
                              //       selectedReimbursements.removeAt(index);
                              //       grandTotal = reimbursementTotal;
                              //     })
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
                                          child: Text(item[
                                                      'reimbursement_month'] ==
                                                  -1
                                              ? "Pre-enroll Month"
                                              : "Month-${item['reimbursement_month']}"),
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
                                              icon: const Icon(
                                                Icons.delete,
                                                color: Colors.red,
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  int packageId = int.parse(
                                                      item['package_id']);
                                                  int givenAmount =
                                                      item['given_amount'];

                                                  // Find the package and update remainingAmount
                                                  final package =
                                                      _editablePatientPackages
                                                          .firstWhere(
                                                    (p) => p.id == packageId,
                                                  );

                                                  package.remainingAmount +=
                                                      givenAmount;
                                                  grandTotal = grandTotal -
                                                      givenAmount;
                                                  selectedReimbursements
                                                      .removeAt(index);
                                                });
                                              },
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
                            selectedReceivedPackageStatus, // Currently selected value (optional)
                        hintText:
                            "Select...", // Hint text displayed when nothing is selected (optional)
                        onChanged: (value) {
                          // Callback function when selection changes (optional)
                          setState(() {
                            selectedReceivedPackageStatus = value;
                          });
                        },
                        isRequired:
                            true, // Whether the selection is mandatory (optional, defaults to true)
                      )
                    ],
                  ),
                  if (selectedReceivedPackageStatus == "yes")
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
                                  selectedReceivedPackageId, // Currently selected value (optional)
                              hintText:
                                  "Select Package...", // Hint text displayed when nothing is selected (optional)
                              onChanged: (value) {
                                // Callback function when selection changes (optional)
                                // print("Selected: $value");
                                setState(() {
                                  PatientPackageEntity? selectedPackage =
                                      _editablePatientPackages.firstWhere(
                                          (package) =>
                                              package.id == int.parse(value));
                                  selectedReceivedPackageId = value;
                                  selectedPackageEligibleAmount =
                                      selectedPackage.remainingAmount;
                                });
                              },
                              isRequired:
                                  false, // Whether the selection is mandatory (optional, defaults to true)
                            )
                          ],
                        ),
                        if (selectedReceivedPackageId != null)
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
                                              selectedPackageEligibleAmount
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
                                        _receivedPackageThisMonthGivenAmountController,
                                    labelText: "Enter Given Amount",
                                    type: "number",
                                    maxValue: _editablePatientPackages
                                        .firstWhere((d) =>
                                            d.id ==
                                            int.parse(
                                                selectedReceivedPackageId!))
                                        .remainingAmount,
                                  )
                                ],
                              ),
                            ],
                          ),
                        const SizedBox(
                          height: 20,
                        ),
                        CustomSubmitButton(
                            buttonText: "Add",
                            onSubmit: () {
                              _handleAddSupportReceivedMonthPackages();
                            }),
                        const SizedBox(
                          height: 20,
                        ),
                        if (selectedSupportReceivedMonthPackages.isNotEmpty)
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
                              ...selectedSupportReceivedMonthPackages
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
                                        child: Text('${item['package']}'),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text('${item['given_amount']}'),
                                      ),
                                    ),
                                    TableCell(
                                      child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.delete,
                                              color: Colors.red,
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                int packageId = int.parse(
                                                    item['package_id']);
                                                int givenAmount =
                                                    item['given_amount'];

                                                // Find the package and update remainingAmount
                                                final package =
                                                    _editablePatientPackages
                                                        .firstWhere(
                                                  (p) => p.id == packageId,
                                                );

                                                package.remainingAmount +=
                                                    givenAmount;
                                                grandTotal =
                                                    grandTotal - givenAmount;
                                                selectedSupportReceivedMonthPackages
                                                    .removeAt(index);
                                              });
                                            },
                                          )),
                                    ),
                                  ],
                                );
                              }),
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
                              "Grand Total",
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
                                  grandTotal.toString(),
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
                              'Remark',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                          ],
                        ),
                      ),
                      CustomTextInput(
                        inputController: _remarkController,
                        labelText: "Enter remark",
                        type: "textarea",
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Signature(
                        controller: signatureController,
                        width: double.infinity,
                        height: 200.0,
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Center(
                            child: SizedBox(
                              width: 130.0,
                              height: 45.0,
                              child: CustomSubmitButton(
                                buttonText: 'ရှင်းမည်',
                                onSubmit: () {
                                  signatureController.clear();
                                  setState(() {
                                    sign = null;
                                  });
                                },
                              ),
                            ),
                          ),
                          Center(
                            child: SizedBox(
                              width: 130.0,
                              height: 45.0,
                              child: CustomSubmitButton(
                                  buttonText: 'သိမ်းမည်',
                                  onSubmit: () async {
                                    sign =
                                        await signatureController.toPngBytes();
                                    setState(() {});
                                  }),
                            ),
                          ),
                        ],
                      ),

                      if (sign != null)
                        Column(
                          children: [
                            const SizedBox(height: 10.0),
                            Image.memory(
                              sign!,
                              width: double.infinity,
                              height: 200.0,
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue, // Background color
                            foregroundColor: Colors.white, // Text color
                            padding: const EdgeInsets.symmetric(
                                horizontal: 32, vertical: 16),
                            textStyle: const TextStyle(fontSize: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          onPressed: onSave,
                          child: const Text(
                            "Save",
                          )),
                      // CustomSubmitButton(
                      //     buttonText: "Save",
                      //     onSubmit: () {
                      //       // debugPrint(_dateController.text);
                      //     }),
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
