import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:flutter/material.dart';

class CustomSubmitButton extends StatelessWidget {
  final String buttonText;
  final void Function()? onSubmit;

  const CustomSubmitButton({
    Key? key,
    required this.buttonText,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
            backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(color: Colors.red)))),
        onPressed: onSubmit,
        child: CustomLabelWidget(
            text: buttonText, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}
