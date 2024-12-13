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
            foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
            backgroundColor: WidgetStateProperty.all<Color>(Colors.red),
            shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    side: BorderSide(color: Colors.red)))),
        onPressed: onSubmit,
        child: CustomLabelWidget(
            text: buttonText, style: const TextStyle(fontSize: 14)),
      ),
    );
  }
}
