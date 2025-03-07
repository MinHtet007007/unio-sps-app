import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/local_database/entity/support_month_entity.dart';

class PatientSupportMonth {
  final PatientEntity patient;
  final List<SupportMonthEntity> supportMonths;

  PatientSupportMonth({
    required this.patient,
    required this.supportMonths,
  });

   Map<String, dynamic> toJson() {
    // Implement the toJson method based on the fields of PatientSupportMonth

    return {
      'patient': patient.toJson(),

      'supportMonths': supportMonths.map((sm) => sm.toJson()).toList(),

      // Add other fields as necessary
    };
  }
}
