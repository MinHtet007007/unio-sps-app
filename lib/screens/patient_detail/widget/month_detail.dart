import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sps/common/constants/route_list.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/data_row.dart';
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/local_database/entity/receive_package_entity.dart';
import 'package:sps/local_database/entity/support_month_entity.dart';
import 'package:sps/screens/patient_detail/widget/month_detail_reimbursement_table.dart';

class MonthDetail extends StatelessWidget {
  final SupportMonthEntity supportMonth;
  final PatientEntity patient;
  final List<ReceivePackageEntity> alreadyReceivedPackagesByPatientId;

  MonthDetail({
    super.key,
    required this.supportMonth,
    required this.patient,
    required this.alreadyReceivedPackagesByPatientId,
  });

  @override
  Widget build(BuildContext context) {
    // Filter patient reimbursements for the current support month
    final patientReimbursements = alreadyReceivedPackagesByPatientId
        .where((d) =>
            d.localPatientSupportMonthId == supportMonth.id &&
            d.reimbursementMonth != null)
        .toList();

    return Card(
      // margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xFFB2EBF2), // Light Cyan
              Color(0xFF81D4FA), // Light Blue
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: ExpansionTile(
          collapsedShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: Colors.transparent),
          ),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.zero,
            side: BorderSide(color: Colors.transparent),
          ),
          title: Text(
            'Month ${supportMonth.month}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  if (!supportMonth.isSynced)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ElevatedButton(
                            onPressed: () async {
                              context.push(
                                  '${RouteName.packageEdit}/${patient.id}/${supportMonth.id}');
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: ColorTheme.primary,
                            ),
                            child: const Text(
                              'Edit Package',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          const SizedBox(width: 10),
                        ],
                      ),
                    ),
                  if (supportMonth.supportMonthSignature != null)
                    Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text('Patient Signature'),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(6.0),
                              child: Image.memory(
                                supportMonth.supportMonthSignature!,
                                width: 150.0,
                                // height: 150.0,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  dataRow('Month Year', supportMonth.monthYear),
                  dataRow('Support Received Date', supportMonth.date),
                  dataRow('Height', supportMonth.height.toString()),
                  dataRow('Weight(kg)', supportMonth.weight.toString()),
                  dataRow('BMI', supportMonth.bmi.toString()),
                  dataRow(
                      'Nominated Packages',
                      supportMonth.planPackages
                          .split(',')
                          .map((number) => 'Package ${number.trim()}')
                          .join(', ')),
                  dataRow(
                      'Received Packages this month',
                      alreadyReceivedPackagesByPatientId
                          .where((d) =>
                              d.localPatientSupportMonthId == supportMonth.id &&
                              d.reimbursementMonth == null)
                          .map((d) => d.patientPackageName)
                          .join(', ')),
                  dataRow(
                      'Grand Total',
                      alreadyReceivedPackagesByPatientId
                          .where((d) =>
                              d.localPatientSupportMonthId == supportMonth.id)
                          .fold(0, (total, item) => total + (item.amount))
                          .toString()),
                  dataRow('Remark',
                      supportMonth.remark == null ? "" : supportMonth.remark!),
                  if (patientReimbursements.isNotEmpty)
                    MonthDetailReimbursementTable(
                      patientReimbursements: patientReimbursements,
                    )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
