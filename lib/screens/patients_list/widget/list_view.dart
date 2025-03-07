import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sps/common/widgets/no_data_state.dart';
import 'package:sps/local_database/entity/patient_support_month.dart';
import 'package:sps/screens/patients_list/widget/list_item.dart';

class CustomListView extends StatefulWidget {
  final List<PatientSupportMonth>? patients;

  const CustomListView({
    this.patients,
    Key? key,
  }) : super(key: key);

  @override
  _CustomListViewState createState() => _CustomListViewState();
}

class _CustomListViewState extends State<CustomListView> {
  final TextEditingController _nameSearchController = TextEditingController();
  final TextEditingController _drtbCodeSearchController = TextEditingController();
  final TextEditingController _startDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  String _nameSearchQuery = '';
  String _drtbCodeSearchQuery = '';
  DateTime? _startDate;
  DateTime? _endDate;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _nameSearchController.addListener(_onSearchChanged);
    _drtbCodeSearchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _nameSearchController.removeListener(_onSearchChanged);
    _drtbCodeSearchController.removeListener(_onSearchChanged);
    _nameSearchController.dispose();
    _drtbCodeSearchController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      setState(() {
        _nameSearchQuery = _nameSearchController.text;
        _drtbCodeSearchQuery = _drtbCodeSearchController.text;
      });
    });
  }

  Future<void> _selectDate(BuildContext context, TextEditingController controller, DateTime? initialDate) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
        if (controller == _startDateController) {
          _startDate = picked;
        } else if (controller == _endDateController) {
          _endDate = picked;
        }
      });
    }
  }

  List<PatientSupportMonth> _filterAndSortPatients() {
    if (widget.patients == null) return [];

    final filteredPatients = widget.patients!.where((psm) {
      final matchesName = psm.patient.name.toLowerCase().contains(_nameSearchQuery.toLowerCase());
      final matchesDrtbCode = psm.patient.drtbCode?.toLowerCase().contains(_drtbCodeSearchQuery.toLowerCase()) ?? true;

      if (psm.supportMonths.isEmpty) {
        return matchesName && matchesDrtbCode;
      }

      final supportMonthDate = DateFormat('yyyy-MM-dd').parse(psm.supportMonths.first.date);
      final matchesStartDate = _startDate == null || supportMonthDate.isAfter(_startDate!);
      final matchesEndDate = _endDate == null || supportMonthDate.isBefore(_endDate!);

      return matchesName && matchesDrtbCode && matchesStartDate && matchesEndDate;
    }).toList();

    filteredPatients.sort((a, b) {
      if (a.patient.spCode == null) return -1;
      if (b.patient.spCode == null) return 1;
      return b.patient.spCode!.compareTo(a.patient.spCode!);
    });

    return filteredPatients;
  }

  @override
  Widget build(BuildContext context) {
    final sortedPatients = _filterAndSortPatients();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: _nameSearchController,
                decoration: const InputDecoration(
                  labelText: 'Search by name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: _drtbCodeSearchController,
                decoration: const InputDecoration(
                  labelText: 'Search by DRTB code',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _startDateController,
                decoration: InputDecoration(
                  labelText: 'Start Date (yyyy-MM-dd)',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, _startDateController, _startDate),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _endDateController,
                decoration: InputDecoration(
                  labelText: 'End Date (yyyy-MM-dd)',
                  border: OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => _selectDate(context, _endDateController, _endDate),
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: sortedPatients.isEmpty
              ? const NoDataStateWidget()
              : ListView.builder(
                  padding: const EdgeInsets.all(8),
                  itemCount: sortedPatients.length,
                  itemBuilder: (BuildContext context, int index) {
                    PatientSupportMonth psm = sortedPatients[index];
                    return CustomItem(
                      id: psm.patient.id as int,
                      name: psm.patient.name,
                      code: psm.patient.spCode,
                      isSynced: psm.patient.isSynced,
                    );
                  },
                ),
        ),
      ],
    );
  }
}
