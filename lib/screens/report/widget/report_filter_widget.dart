import 'package:sps/common/constants/form_options.dart';
import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/form/custom_drop_down.dart';
import 'package:sps/common/widgets/form/custom_text_input.dart';
import 'package:sps/features/report/provider/remote_report_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReportFilterWidget extends ConsumerStatefulWidget {
  const ReportFilterWidget({
    super.key,
  });

  @override
  ConsumerState<ReportFilterWidget> createState() => _ReportFilterWidgetState();
}

class _ReportFilterWidgetState extends ConsumerState<ReportFilterWidget> {
  String? selectedYear;
  String? selectedMonth;
  final TextEditingController textEditingController = TextEditingController();

  void _filterReport() async {
    await Future.delayed(Duration.zero);

    final reportNotifier = ref.read(remoteReportProvider.notifier);
    reportNotifier.fetchReport(
        month: selectedMonth,
        year: selectedYear,
        name: textEditingController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: CustomDropDown(
                    title: 'လ',
                    items: months,
                    selectedData: selectedMonth,
                    hintText: 'လ',
                    onChanged: ((value) {
                      setState(() {
                        selectedMonth = value;
                      });
                    })),
              ),
              Expanded(
                flex: 3,
                child: CustomDropDown(
                    title: 'နှစ်',
                    items: years,
                    selectedData: selectedYear,
                    hintText: 'ခုနှစ်',
                    onChanged: ((value) {
                      setState(() {
                        selectedYear = value;
                      });
                    })),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: CustomTextInput(
                  inputController: textEditingController,
                  labelText: 'လူနာ အမည်',
                ),
              ),
              GestureDetector(
                onTap: _filterReport,
                child: Container(
                    margin: const EdgeInsets.only(top: 10),
                    decoration: BoxDecoration(
                        color: ColorTheme.warning,
                        borderRadius: BorderRadius.circular(10)),
                    child: const IconButton(
                      icon: Icon(
                        Icons.search,
                        color: Colors.black,
                      ),
                      onPressed: null,
                    )),
              ),
            ],
          )
        ],
      );
    });
  }
}
