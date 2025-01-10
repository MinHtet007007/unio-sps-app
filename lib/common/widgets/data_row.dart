import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:flutter/material.dart';

Padding dataRow(String label, String data) {
  const double height = 20.0;

  return Padding(
    padding: const EdgeInsets.only(bottom: height),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Flexible(
          child: CustomLabelWidget(
            text: label,
            style: const TextStyle(
              fontSize: 14.0,
            ),
            align: TextAlign.left,
          ),
        ),
        const SizedBox(
          width: 10,
        ),
        Flexible(
          child: CustomLabelWidget(
            text: data,
            style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
            align: TextAlign.right,
          ),
        ),
      ],
    ),
  );
}
