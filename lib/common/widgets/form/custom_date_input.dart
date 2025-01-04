import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateInput extends StatelessWidget {
  final TextEditingController dateController;
  final String labelText;
  final String? validateDate;

  const CustomDateInput(
      {Key? key,
      required this.dateController,
      required this.labelText,
      this.validateDate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1, 1);
    final firstDateOfLastMonth = DateTime(lastMonth.year, lastMonth.month, 1);
    void pickDate() async {
      DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: validateDate != null
              ? DateTime.parse(validateDate!)
              : firstDateOfLastMonth,
          lastDate: validateDate != null ? DateTime.now() : DateTime(2101));

      if (pickedDate != null) {
        dateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextFormField(
        controller: dateController,
        readOnly: true,
        decoration: InputDecoration(
            labelText: labelText,
            labelStyle: const TextStyle(fontSize: 14, color: Colors.blue),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            prefixIcon: IconButton(
                onPressed: pickDate,
                icon: const Icon(
                  Icons.calendar_month_rounded,
                ))),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        validator: (val) {
          if (val!.isEmpty) {
            return "$labelText is required";
          }
          return null;
        },
      ),
    );
  }
}
