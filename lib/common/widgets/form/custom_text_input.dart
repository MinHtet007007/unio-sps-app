import 'package:flutter/material.dart';

class CustomTextInput extends StatefulWidget {
  final TextEditingController inputController;
  final String labelText;
  final String? type;
  final bool isRequired;

  const CustomTextInput({
    required this.inputController,
    required this.labelText,
    this.isRequired = false,
    this.type,
    Key? key,
  }) : super(key: key);

  @override
  _CustomTextInputState createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextFormField(
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
        validator: (value) {
          if (!widget.isRequired) {
            return null;
          }
          if (value == null || value.isEmpty) {
            return '${widget.labelText} ဖြည့်ပေးပါ';
          }
          return null;
        },
      ),
    );
  }
}
