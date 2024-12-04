import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:flutter/material.dart';

class ReportDataRowWidget extends StatelessWidget {
  final String title;
  final int count;

  const ReportDataRowWidget(
      {super.key, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        child: Column(
          children: <Widget>[
            CustomLabelWidget(
                text: title,
                style: const TextStyle(fontSize: 16, color: Colors.black)),
            CustomLabelWidget(
                text: count.toString(), style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
