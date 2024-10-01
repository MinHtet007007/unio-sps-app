import 'package:sps/common/constants/route_list.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/helpers/get_couseling_phase.dart';
import 'package:sps/common/model/phase_data.dart';
import 'package:sps/common/widgets/data_row.dart';
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class PatientDetailsWidget extends StatelessWidget {
  final Patient patient;
  const PatientDetailsWidget({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(children: [
        dataRow('အမည်', patient.name),
        dataRow('လိပ်စာ', patient.address),
        dataRow('ဖုန်းနံပါတ်', patient.phone),
        dataRow('Union တီဘီကုဒ်', patient.unionTemporaryCode ?? ''),
        dataRow('Tx regimen', patient.treatmentRegimen ?? ''),
        dataRow('တီဘီအမျိုးအစား', patient.tbType ?? ''),
        dataRow('ဆေးစသောက်သည့်နေ့စွဲ', patient.actualTreatmentStartDate ?? ''),
        dataRow('‌ဆေးတိုက်သည့်နေ့စွဲ', patient.dotsStartDate ?? ''),
        dataRow('မှတ်ချက်', patient.remark ?? ''),
        ElevatedButton(
          onPressed: () async {
            var phase = getCounselingPhase(patient.dotsStartDate as String,
                patient.treatmentRegimen as String);
            final phaseData = PhaseData(phase: phase);
            await context.push('${RouteName.patientCounselings}/${patient.id}',
                extra: phaseData);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: ColorTheme.primary,
          ),
          child: const Text(
            'Counseling',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ]),
    );
  }
}
