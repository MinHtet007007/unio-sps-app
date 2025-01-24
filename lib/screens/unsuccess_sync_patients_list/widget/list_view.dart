import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:flutter/material.dart';
import 'package:sps/screens/patients_list/widget/list_item.dart';

class CustomListView extends StatelessWidget {
  final List<PatientEntity>? patients;

  const CustomListView({
    this.patients,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Sort the patients by spCode in descending order, moving null spCode patients to the beginning
    final sortedPatients = patients
        ?.where((patient) => patient.spCode != null)
        .toList()
      ?..sort((a, b) => b.spCode!.compareTo(a.spCode!));
    final nullSpCodePatients =
        patients?.where((patient) => patient.spCode == null).toList();
    sortedPatients?.insertAll(0, nullSpCodePatients ?? []);

    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: sortedPatients?.length,
        itemBuilder: (BuildContext context, int index) {
          PatientEntity patient = sortedPatients![index];
          return CustomItem(
              id: patient.id as int,
              name: patient.name,
              code: patient.spCode,
              isSynced: patient.isSynced);
        });
  }
}
