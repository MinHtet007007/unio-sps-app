import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:flutter/material.dart';

class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomLabelWidget(
          text: "မှတ်စု",
          style: AppBarTextStyle,
        ),
        backgroundColor: ColorTheme.primary,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 50, bottom: 50),
          child: Column(
            children: [
              Image.asset(
                'assets/images/mgn_clinic_app_note1.png',
                fit: BoxFit.scaleDown,
              ),
              const SizedBox(height: 20),
              Image.asset(
                'assets/images/mgn_clinic_app_note2.png',
                fit: BoxFit.scaleDown,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
