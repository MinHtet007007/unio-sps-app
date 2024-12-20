import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sps/common/constants/route_list.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/data_row.dart';
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/local_database/entity/support_month_entity.dart';
import 'package:sps/screens/patient_detail/widget/month_detail.dart';

class PatientDetailsWidget extends StatelessWidget {
  final PatientEntity patient;
  final List<SupportMonthEntity>? supportMonths;

  const PatientDetailsWidget({
    super.key,
    required this.patient,
    required this.supportMonths,
  });

  @override
  Widget build(BuildContext context) {
    print(patient.patientPhoneNo);
    return Column(
      children: [
        Expanded(
          child: SingleChildScrollView(
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
                            context.push(
                                '${RouteName.packageCreate}/${patient.id}');
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
                  dataRow('အမည်', patient.name),
                  dataRow('လိပ်စာ', patient.patientAddress),
                  dataRow('ဖုန်းနံပါတ်', patient.patientPhoneNo),
                  dataRow('RR code', patient.rrCode ?? ''),
                  dataRow('DRTB code', patient.drtbCode ?? ''),
                  dataRow('SP code', patient.spCode ?? ''),
                  dataRow(
                      'ဆေးစသောက်သည့်နေ့စွဲ', patient.treatmentStartDate ?? ''),
                ],
              ),
            ),
          ),
        ),
        // ListView takes remaining space and allows scrolling
        Expanded(
          child: ListView.builder(
            itemCount: supportMonths?.length ?? 0,
            itemBuilder: (context, index) {
              return MonthDetail(supportMonth: supportMonths![index], patient: patient,);
            },
          ),
        ),
      ],
    );
  }
}
