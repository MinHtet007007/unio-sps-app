import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:flutter/material.dart';
import 'package:sps/screens/patients_list/widget/list_item.dart';

class CustomListView extends StatelessWidget {
  final List<Patient>? patients;

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
          Patient patient = patients![index];
          return CustomItem(
            id: patient.id as int,
            name: patient.name,
            unionTempCode: patient.unionTemporaryCode as String,
          );
        });
  }
}
