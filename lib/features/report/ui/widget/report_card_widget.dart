import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:flutter/material.dart';

class ReportCardWidget extends StatelessWidget {
  final String title;

  final List<Widget> children;

  const ReportCardWidget(
      {super.key, required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      //height: 230,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: ColorTheme.primary.withOpacity(0.4),
            spreadRadius: 3,
            blurRadius: 3,
            offset: const Offset(0, 2), // changes position of shadow
          ),
        ],
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Icon(
            Icons.person_pin_circle,
            color: ColorTheme.primary,
            size: 50,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: CustomLabelWidget(
              text: title,
              align: TextAlign.center,
              style: const TextStyle(
                color: ColorTheme.primary,
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children,
          )
        ],
      ),
    );
  }
}
