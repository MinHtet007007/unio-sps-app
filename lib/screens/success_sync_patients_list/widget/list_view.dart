import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:sps/local_database/entity/patient_support_month.dart';
import 'package:sps/screens/patients_list/widget/list_item.dart';

class CustomListView extends StatelessWidget {
  final List<PatientSupportMonth>? patients;

  const CustomListView({
    this.patients,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort the patients by spCode in descending order, moving null spCode patients to the beginning
    final sortedPatients = patients
        ?.where((patient) => patient.patient.spCode != null)
        .toList()
      ?..sort((a, b) => b.patient.spCode!.compareTo(a.patient.spCode!));
    final nullSpCodePatients =
        patients?.where((patient) => patient.patient.spCode == null).toList();
    sortedPatients?.insertAll(0, nullSpCodePatients ?? []);

    

    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: sortedPatients?.length,
        itemBuilder: (BuildContext context, int index) {
          PatientSupportMonth patient = sortedPatients![index];
          return CustomItem(
              id: patient.patient.id as int,
              name: patient.patient.name,
              code: patient.patient.spCode,
              isSynced: patient.patient.isSynced);
        });
  }
}
