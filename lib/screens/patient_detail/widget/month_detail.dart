import 'package:flutter/material.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/data_row.dart';

class MonthDetail extends StatelessWidget {
  const MonthDetail({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.lightBlue,
      child: ExpansionTile(
        iconColor: Colors.white,
        collapsedIconColor: Colors.white,
        collapsedShape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: Colors.transparent),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
          side: BorderSide(color: Colors.transparent),
        ),
        title: const Text(
          'Month 0 (Pyin Oo Lwin)',
          style: TextStyle(
              // color: Colors.white, // Customize title text color
              ),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          // var phase = getCounselingPhase(patient.dotsStartDate as String,
                          //     patient.treatmentRegimen as String);
                          // final phaseData = PhaseData(phase: phase);
                          // await context.push('${RouteName.patientCounselings}/${patient.id}',
                          //     extra: phaseData);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorTheme.black,
                        ),
                        child: const Text(
                          'Edit Package',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          // var phase = getCounselingPhase(patient.dotsStartDate as String,
                          //     patient.treatmentRegimen as String);
                          // final phaseData = PhaseData(phase: phase);
                          // await context.push('${RouteName.patientCounselings}/${patient.id}',
                          //     extra: phaseData);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ColorTheme.danger,
                        ),
                        child: const Text(
                          'Delete',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
                dataRow('Month Year', '2024-11'),
                dataRow('Support Received Date', '2024-11-13'),
                dataRow('Height', '160'),
                dataRow('Weight(kg)', '48'),
                dataRow('BMI', '18.7'),
                dataRow('Nominated Packages', 'Package 6,Package 7,Package 9'),
                dataRow('Received Packages this month', 'Package 6, Package 9'),
                dataRow('Grand Total', '124000'),
                dataRow('Remark', '2024-11-13'),
                Table(
                  border: TableBorder.all(),
                  children: const [
                    TableRow(
                      children: [
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('No'),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Support Received Month'),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Packages'),
                          ),
                        ),
                        TableCell(
                          verticalAlignment: TableCellVerticalAlignment.middle,
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Month Year'),
                          ),
                        ),
                      ],
                    ),
                    TableRow(
                      children: [
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('1'),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Month-0'),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Package 7'),
                          ),
                        ),
                        TableCell(
                          child: Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('2024-10'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
