import 'package:flutter/material.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/screens/patient_detail/widget/details_view.dart';

class PatientDetailScreen extends StatelessWidget {
  final int patientId;
  const PatientDetailScreen({super.key, required this.patientId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomLabelWidget(
          text: "Patient Details",
          style: const TextStyle(fontSize: 16, color: Colors.white),
        ),
        backgroundColor: ColorTheme.primary,
      ),
      body: PatientDetailsWidget(
        patient: Patient(
            "John Doe",
            "123456789",
            "123 Elm Street",
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
      ),
    );
  }
}
