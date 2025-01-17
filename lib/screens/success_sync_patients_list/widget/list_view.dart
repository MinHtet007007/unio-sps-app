import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:flutter/material.dart';
import 'package:sps/screens/success_sync_patients_list/widget/list_item.dart';

class CustomListView extends StatelessWidget {
  final List<PatientEntity>? patients;

  const CustomListView({
    this.patients,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: patients?.length,
        itemBuilder: (BuildContext context, int index) {
          PatientEntity patient = patients![index];
          return CustomItem(
              id: patient.id as int,
              name: patient.name,
              code: patient.spCode ?? '',
              isSynced: patient.isSynced);
        });
  }
}
