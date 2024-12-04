import 'package:sps/features/report/model/remote_report_result.dart';
import 'package:sps/screens/report/widget/report_card_widget.dart';
import 'package:sps/screens/report/widget/report_data_row_widget.dart';
import 'package:sps/screens/report/widget/report_filter_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportWidget extends ConsumerWidget {
  final Report data;
  const ReportWidget({super.key, required this.data});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SingleChildScrollView(
        child: Container(
      padding: const EdgeInsets.all(20),
      child: Column(children: <Widget>[
        const ReportFilterWidget(),
        const SizedBox(height: 30),
        ReportCardWidget(
          title: 'မိမိဆေးတိုက်နေသောလူနာစာရင်း',
          children: <Widget>[
            ReportDataRowWidget(title: 'ကျား', count: data.patientMaleCount),
            ReportDataRowWidget(title: 'မ', count: data.patientFemaleCount),
            ReportDataRowWidget(title: 'ပေါင်း', count: data.patientTotalCount),
          ],
        ),
        const SizedBox(height: 30),
        ReportCardWidget(
          title: 'ကနဦးဆေးကုကာလတွင် Counselling ပေးခဲ့သော အကြိမ်အရေအတွက်',
          children: <Widget>[
            ReportDataRowWidget(
                title: 'ဖုန်းဖြင့်', count: data.ipCounselingPhCount),
            ReportDataRowWidget(
                title: 'လူကိုယ်တိုင်', count: data.ipCounselingInPersonCount),
          ],
        ),
        const SizedBox(height: 30),
        ReportCardWidget(
          title: 'ဆက်လက်ဆေးကုကာလတွင် Counselling ပေးခဲ့သော အကြိမ်အရေအတွက်',
          children: <Widget>[
            ReportDataRowWidget(
                title: 'ဖုန်းဖြင့်', count: data.cpCounselingPhCount),
            ReportDataRowWidget(
                title: 'လူကိုယ်တိုင်', count: data.cpCounselingInPersonCount),
          ],
        ),
      ]),
    ));
  }
}
