import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sps/common/constants/route_list.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/data_row.dart';
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/local_database/entity/receive_package_entity.dart';
import 'package:sps/local_database/entity/support_month_entity.dart';
import 'package:sps/screens/patient_detail/widget/month_detail.dart';

class PatientDetailsWidget extends StatelessWidget {
  final PatientEntity patient;
  final List<SupportMonthEntity>? supportMonths;
  final List<ReceivePackageEntity> alreadyReceivedPackagesByPatientId;

  const PatientDetailsWidget({
    super.key,
    required this.patient,
    required this.supportMonths,
    required this.alreadyReceivedPackagesByPatientId,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      context.push('${RouteName.packageCreate}/${patient.id}');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ColorTheme.primary,
                    ),
                    child: const Text(
                      'Add New Package',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
            dataRow('Name', patient.name),
            dataRow('Address', patient.patientAddress),
            dataRow('Phone', patient.patientPhoneNo),
            dataRow('SPS Start Date', patient.spsStartDate ?? ''),
            dataRow('RR code', patient.rrCode ?? ''),
            dataRow('DRTB code', patient.drtbCode ?? ''),
            dataRow('SP code', patient.spCode ?? ''),
            dataRow('Treatment Start Date', patient.treatmentStartDate ?? ''),
             const SizedBox(height: 20),
            // Add a title or label for the support months list
            if (supportMonths != null)
              const Text(
                'Support Months',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            const SizedBox(height: 10),
            ListView.builder(
              shrinkWrap: true,
              physics:
                  NeverScrollableScrollPhysics(), // Prevent independent scrolling
              itemCount: supportMonths?.length ?? 0,
              itemBuilder: (context, index) {
                SupportMonthEntity supportMonth = supportMonths![index];
                return MonthDetail(
                  supportMonth: supportMonth,
                  patient: patient,
                  index: index,
                  alreadyReceivedPackagesByPatientId:
                      alreadyReceivedPackagesByPatientId,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
