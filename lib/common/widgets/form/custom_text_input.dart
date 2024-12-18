import 'package:flutter/material.dart';

class CustomTextInput extends StatefulWidget {
  final TextEditingController inputController;
  final String labelText;
  final String? type;
  final bool isRequired;
  final bool readOnly;
  final int? maxValue;
  final Function(String)? onChanged;

  const CustomTextInput({
    required this.inputController,
    required this.labelText,
    this.isRequired = false,
    this.type,
    Key? key,
    this.readOnly = false,
    this.maxValue,
    this.onChanged,
  }) : super(key: key);

  @override
  _CustomTextInputState createState() => _CustomTextInputState();
}

class _CustomTextInputState extends State<CustomTextInput> {
  String? _errorMessage;

  void _validateInput(String value) {
    if (widget.type == 'number' && widget.maxValue != null) {
      int enteredValue = int.tryParse(value) ?? 0;
      if (enteredValue > widget.maxValue!) {
        setState(() {
          _errorMessage =
              "Value exceeds the maximum allowed (${widget.maxValue}).";
        });
        widget.inputController.clear(); // Clear the invalid input
      } else {
        setState(() {
          _errorMessage = null; // Clear the error if valid
        });
      }
    }
    if (widget.onChanged != null) {
      widget.onChanged!(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
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
            keyboardType: widget.type == 'number'
                ? TextInputType.number
                : TextInputType.text,
            onChanged: _validateInput,
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
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }
}
