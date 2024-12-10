import 'package:flutter/material.dart';

class CustomTextInputWithValidation extends StatefulWidget {
  final TextEditingController inputController;
  final String labelText;
  final String? type;
  final bool isRequired;
  final bool readOnly;
  String? Function(String?)? validate;

  CustomTextInputWithValidation({
    required this.inputController,
    required this.labelText,
    required this.validate,
    this.isRequired = false,
    this.type,
    Key? key,
    this.readOnly = false,
  }) : super(key: key);

  @override
  _CustomTextInputWithValidationState createState() =>
      _CustomTextInputWithValidationState();
}

class _CustomTextInputWithValidationState
    extends State<CustomTextInputWithValidation> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextFormField(
        readOnly: widget.readOnly,
        maxLines: widget.type == 'textarea' ? 5 : 1,
        controller: widget.inputController,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          alignLabelWithHint: true,
          labelText: widget.labelText,
          labelStyle: const TextStyle(fontSize: 14, color: Colors.blue),
        ),
        keyboardType:
            widget.type == 'number' ? TextInputType.number : TextInputType.text,
        textInputAction: TextInputAction.next,
        validator: widget.validate,
      ),
    );
  }
}
