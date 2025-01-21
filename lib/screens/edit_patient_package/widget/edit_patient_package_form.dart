import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:sps/common/constants/form_options.dart';
import 'package:sps/common/helpers/is_every_element_include.dart';
import 'package:sps/common/widgets/form/custom_date_input_with_validation.dart';
import 'package:sps/common/widgets/form/custom_drop_down.dart';
import 'package:sps/common/widgets/form/custom_multi_select_drop_down.dart';
import 'package:sps/common/widgets/form/custom_submit_button.dart';
import 'package:sps/common/widgets/form/custom_text_input.dart';
import 'package:sps/common/widgets/snack_bar_utils.dart';
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/local_database/entity/patient_package_entity.dart';
import 'package:sps/local_database/entity/receive_package_entity.dart';
import 'package:sps/local_database/entity/support_month_entity.dart';
import 'package:sps/models/received_package_request.dart';
import 'package:sps/screens/add_new_package/widget/reimbursement_table.dart';
import 'package:sps/screens/add_new_package/widget/support_package_table.dart';
import 'package:sps/utils/package_utils.dart';

class EditPatientPackageForm extends StatefulWidget {
  final PatientEntity patientDetails;
  final SupportMonthEntity existingSupportMonth;
  final List<PatientPackageEntity> patientPackages;
  final List<ReceivePackageEntity> alreadyReceivedPackagesBySupportMonthId;
  Future<void> Function(SupportMonthEntity formData,
      List<ReceivedPackageRequest> receivedPackages) onSubmit;
  final List<ReceivePackageEntity> alreadyReceivedPackagesByPatientId;
  final List<SupportMonthEntity> patientSupportMonths;

  EditPatientPackageForm({
    super.key,
    required this.patientDetails,
    required this.existingSupportMonth,
    required this.patientPackages,
    required this.alreadyReceivedPackagesBySupportMonthId,
    required this.onSubmit,
    required this.alreadyReceivedPackagesByPatientId,
    required this.patientSupportMonths,
  });

  @override
  State<EditPatientPackageForm> createState() => _EditPatientPackageFormState();
}

class _EditPatientPackageFormState extends State<EditPatientPackageForm> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _dateController;
  late final TextEditingController _monthYearController;
  late final TextEditingController _remarkController;
  late final TextEditingController _weightController;
  final TextEditingController _reimbursementWeightController =
      TextEditingController();
  final TextEditingController _reimbursementMonthYearController =
      TextEditingController();
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

  double BMI = 0.0;
  String? selectedMonth;
  String? selectedReceivedPackageStatus;
  List<String> _selectedPlanPackages = [];
  Uint8List? sign;
  DateTime? maxDate;
  List<DropdownMenuItem<String>> supportMonthsOptions = supportMonths;
  late List<PatientPackageEntity> _editablePatientPackages;
  String? reimbursementStatus;
  double reimbursementBMI = 0.0;
  String? selectedReimbursementMonth;
  String? selectedReimbursementPackageId;
  int selectedReimbursementPackageEligibleAmount = 0;
  List<Map<String, dynamic>> selectedReimbursements = [];
  List<Map<String, dynamic>> selectedSupportReceivedMonthPackages = [];
  int grandTotal = 0;
  int tempGivenAmountStorage = 0;
  String? selectedReceivedPackageId;
  int selectedPackageEligibleAmount = 0;
  bool isLoading = false;

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
        final calculateBmi = weight / (height * height);
        final bmi = double.parse(calculateBmi.toStringAsFixed(1));
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

  Future<void> onSave() async {
    if (_formKey.currentState!.validate()) {
      try {
        setState(() {
          isLoading = true;
        });

        // Prepare the reimbursement map for quick lookups
        final reimbursementMap = {
          for (var reimbursement in selectedReimbursements)
            '${reimbursement["reimbursement_month"]}_${reimbursement["reimbursement_packages"]}':
                reimbursement
        };

        // Extract plan and receive package names
        final planPackages = _selectedPlanPackages;
        final List<String> receivePackages = [
          ...selectedSupportReceivedMonthPackages.map((pkg) => pkg["package"]),
          ...selectedReimbursements.map((pkg) => pkg["reimbursement_packages"]),
        ];

        // Validation: Check if plan and received packages match
        if (!isEveryElementIncluded(planPackages, receivePackages)) {
          SnackbarUtils.showError(
              context, "Please check Plan and Receive Packages.");
          return;
        }

        // Validation: Ensure reimbursements are added if status is "Yes"
        if (reimbursementStatus == "yes" && selectedReimbursements.isEmpty) {
          SnackbarUtils.showError(
              context, "Please insert a reimbursement package.");
          return;
        }

        // Validation: Check for BMI constraints with Package 8
        final hasHighBMI = widget.patientSupportMonths.length > 1 &&
            widget.patientSupportMonths
                .sublist(widget.patientSupportMonths.length >= 2
                    ? widget.patientSupportMonths.length - 2
                    : 0)
                .every((month) => month.bmi >= 18.5);

        final isIncompatibleWithBPalM =
            widget.patientDetails.treatmentRegimen == "5. BPalM";
        final isIncompatibleWithBPal =
            widget.patientDetails.treatmentRegimen == "4. BPal";

        if (selectedSupportReceivedMonthPackages
                .any((pkg) => pkg["package"] == "Package 8") &&
            widget.patientSupportMonths.length > 1 &&
            hasHighBMI &&
            !isIncompatibleWithBPalM &&
            !isIncompatibleWithBPal) {
          SnackbarUtils.showError(
            context,
            "Package 8 is not compatible with BMI above 18.5 for two consecutive months.",
          );
          return;
        }

        // Validation: Check for duplicate reimbursements
        final hasDuplicateReimbursement =
            widget.alreadyReceivedPackagesByPatientId.any(
          (pkg) => reimbursementMap.containsKey(
              '${pkg.reimbursementMonth}_${pkg.patientPackageName}'),
        );

        if (hasDuplicateReimbursement) {
          SnackbarUtils.showError(
            context,
            "Selected reimbursement package and month already exist. Please check again.",
          );
          return;
        }

        // Prepare data for submission
        final formattedPlanPackages = _selectedPlanPackages
            .map((package) => package.replaceAll(RegExp(r'[^0-9]'), ''))
            .where((number) => number.isNotEmpty)
            .join(',');

        List<ReceivedPackageRequest> receivePackagesData =
            selectedReceivedPackageStatus == "yes"
                ? [
                    // Add support received month packages
                    ...selectedSupportReceivedMonthPackages.map((d) =>
                        ReceivedPackageRequest(
                            localPatientPackageId: int.parse(d["package_id"]),
                            amount: d["given_amount"],
                            patientPackageName: d["package"],
                            reimbursementMonth: null,
                            reimbursementMonthYear: null)),
                    // Add reimbursements
                    ...selectedReimbursements.map((d) => ReceivedPackageRequest(
                        localPatientPackageId: int.parse(d["package_id"]),
                        amount: d["given_amount"],
                        patientPackageName: d["reimbursement_packages"],
                        reimbursementMonth: int.parse(d["reimbursement_month"]),
                        reimbursementMonthYear: d["reimbursement_month_year"])),
                  ]
                : [
                    ...selectedReimbursements.map((d) => ReceivedPackageRequest(
                        localPatientPackageId: int.parse(d["package_id"]),
                        amount: d["given_amount"],
                        patientPackageName: d["reimbursement_packages"],
                        reimbursementMonth: int.parse(d["reimbursement_month"]),
                        reimbursementMonthYear: d["reimbursement_month_year"])),
                  ];

        // Construct the form data
        final formData = SupportMonthEntity(
          id: widget.existingSupportMonth.id,
          remoteId: widget.existingSupportMonth.remoteId,
          localPatientId: widget.patientDetails.id!,
          remotePatientId: widget.patientDetails.remoteId,
          patientName: widget.patientDetails.name,
          townshipId: widget.patientDetails.townshipId,
          date: _dateController.text,
          month: selectedMonth != null ? int.parse(selectedMonth!) : 0,
          monthYear: _monthYearController.text,
          height: widget.patientDetails.height,
          weight: double.parse(
              double.parse(_weightController.text).toStringAsFixed(2)),
          bmi: BMI,
          planPackages: formattedPlanPackages,
          receivePackageStatus: selectedReceivedPackageStatus!,
          reimbursementStatus: reimbursementStatus!,
          isSynced: false,
          remark: _remarkController.text,
          supportMonthSignature: sign,
        );

        // Submit data
        await widget.onSubmit(formData, receivePackagesData);

        // showNotification("Support month saved successfully.");
      } catch (error) {
        print("Error saving support month: $error");
        SnackbarUtils.showError(
            context, "An error occurred. Please try again.");
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _editablePatientPackages = List.from(widget.patientPackages);

    _dateController =
        TextEditingController(text: widget.existingSupportMonth.date);
    _monthYearController =
        TextEditingController(text: widget.existingSupportMonth.monthYear);
    _remarkController =
        TextEditingController(text: widget.existingSupportMonth.remark);
    _weightController = TextEditingController(
        text: widget.existingSupportMonth.weight.toString());

    _weightController.addListener(_calculateBMI);
    _reimbursementWeightController.addListener(() {
      _calculateBMI(isReimbursement: true);
    });

    selectedMonth = widget.existingSupportMonth.month.toString();
    selectedReceivedPackageStatus =
        widget.existingSupportMonth.receivePackageStatus.toLowerCase();
    reimbursementStatus =
        widget.existingSupportMonth.reimbursementStatus.toLowerCase();
    _selectedPlanPackages = widget.existingSupportMonth.planPackages
        .split(',')
        .map((number) => "Package $number")
        .toList();
    BMI = widget.existingSupportMonth.bmi.toDouble();
    sign = widget.existingSupportMonth.supportMonthSignature;
    selectedReimbursements = widget.alreadyReceivedPackagesBySupportMonthId
        .where((d) => d.reimbursementMonth != null)
        .map((reimbursementPackage) {
      return {
        'reimbursement_month':
            reimbursementPackage.reimbursementMonth.toString(),
        'given_amount': reimbursementPackage.amount,
        'reimbursement_packages': reimbursementPackage.patientPackageName,
        'reimbursement_month_year': reimbursementPackage.reimbursementMonthYear,
        'package_id': widget.patientPackages
            .firstWhere(
                (d) => d.packageName == reimbursementPackage.patientPackageName)
            .id
            .toString(),
      };
    }).toList();
    selectedSupportReceivedMonthPackages = widget
        .alreadyReceivedPackagesBySupportMonthId
        .where((d) =>
            d.reimbursementMonth ==
            null) // Filter the list based on the null reimbursementMonth
        .map((d) => {
              'package_id': widget.patientPackages
                  .firstWhere(
                      (data) => data.packageName == d.patientPackageName)
                  .id
                  .toString(),
              'given_amount': d.amount,
              'package': d.patientPackageName,
            })
        .toList();

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
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  // TextButton(
                  //     onPressed: () {
                  //       debugPrint(widget.alreadyReceivedPackagesBySupportMonthId.toString());
                  //     },
                  //     child: const Text("Print")),
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
                        items: supportMonthsOptions,
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
                              ReimbursementTable(
                                  selectedReimbursements:
                                      selectedReimbursements,
                                  editablePatientPackages:
                                      _editablePatientPackages,
                                  onDeleteReimbursement:
                                      (int index, int givenAmount) {
                                    setState(() {
                                      selectedReimbursements.removeAt(index);
                                      grandTotal -= givenAmount;
                                    });
                                  })
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
                          SupportPackageTable(
                            selectedSupportReceivedMonthPackages:
                                selectedSupportReceivedMonthPackages,
                            grandTotal: grandTotal,
                            editablePatientPackages: _editablePatientPackages,
                            onDelete: (int index, int givenAmount) {
                              setState(() {
                                selectedSupportReceivedMonthPackages
                                    .removeAt(index);
                                grandTotal -= givenAmount;
                              });
                            },
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
                      AbsorbPointer(
                        absorbing: sign != null,
                        child: Signature(
                          controller: signatureController,
                          width: double.infinity,
                          height: 200.0,
                        ),
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
                                    // Wait for the signature to be captured as a PNG byte array
                                    final Uint8List? pngBytes =
                                        await signatureController.toPngBytes();

                                    if (pngBytes != null) {
                                      // Successfully obtained the signature, store it
                                      setState(() {
                                        sign = pngBytes;
                                      });
                                      // Optionally clear the controller after storing the signature
                                      signatureController.clear();
                                    } else {
                                      // Handle the case where signature was not obtained (maybe show an error)
                                      print('Failed to capture the signature');
                                    }
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
