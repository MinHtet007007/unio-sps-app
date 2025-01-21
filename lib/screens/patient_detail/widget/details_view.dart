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
  final bool isReadOnly;

  const PatientDetailsWidget({
    super.key,
    required this.patient,
    required this.supportMonths,
    required this.alreadyReceivedPackagesByPatientId,
    required this.isReadOnly,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Patient Details',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Card(
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
                    patient.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          if ((patient.spCode == null ||
                                  patient.spCode == "") &&
                              !patient.isSynced &&
                              isReadOnly)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 15.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ElevatedButton(
                                    onPressed: () async {
                                      context.push(
                                          '${RouteName.patientEdit}/${patient.id}');
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: ColorTheme.primary,
                                    ),
                                    child: const Text(
                                      'Edit Patient',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                ],
                              ),
                            ),
                          dataRow('Name', patient.name),
                          dataRow('Address', patient.patientAddress),
                          dataRow('Phone', patient.patientPhoneNo),
                          dataRow('Gender', patient.sex),
                          dataRow('SPS Start Date', patient.spsStartDate ?? ''),
                          dataRow('RR code', patient.rrCode ?? ''),
                          dataRow('DRTB code', patient.drtbCode ?? ''),
                          dataRow('SP code', patient.spCode ?? ''),
                          dataRow('Treatment Start Date',
                              patient.treatmentStartDate ?? ''),
                          dataRow('Died Before Treatment Enrollment',
                              patient.diedBeforeTreatmentEnrollment ?? ''),
                          dataRow('treatmentRegimen',
                              patient.treatmentRegimen ?? ''),
                          if (patient.treatmentRegimenOther != '')
                            dataRow('treatmentRegimenOther',
                                patient.treatmentRegimenOther ?? ''),
                          dataRow('contactInfo', patient.contactInfo),
                          dataRow('contactPhoneNo', patient.contactPhoneNo),
                          dataRow('primaryLanguage', patient.primaryLanguage),
                          dataRow('secondaryLanguage',
                              patient.secondaryLanguage ?? ''),
                          dataRow('height', '${patient.height}'),
                          dataRow('weight', '${patient.weight}'),
                          dataRow('bmi', '${patient.bmi}'),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
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
                  alreadyReceivedPackagesByPatientId:
                      alreadyReceivedPackagesByPatientId,
                  isReadOnly: isReadOnly,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
