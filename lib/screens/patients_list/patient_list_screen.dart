import 'package:flutter/material.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:sps/common/widgets/sync_button.dart';
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/screens/patients_list/widget/list_view.dart';

class PatientListScreen extends StatelessWidget {
  const PatientListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: CustomLabelWidget(
            text: "လူနာစာရင်း",
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          backgroundColor: ColorTheme.primary,
          actions: [
            SyncButton(isLoading: false, onPressed: () {}),
          ]),
      body: CustomListView(
        patients: [
          Patient(
              "John Doe",
              "123456789",
              "123 Elm Street, Springfield",
              "UN123",
              "Regimen A",
              "Pulmonary",
              1,
              101,
              "2024-01-01",
              "2024-06-30",
              "Completed",
              "2024-07-01",
              "New",
              "2024-01-01",
              "Type A",
              "No remarks",
              id: 1),
        ],
      ),
    );
  }
}
