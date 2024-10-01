import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateInputWithValidation extends StatefulWidget {
  final TextEditingController dateController;
  final String labelText;
  final String date;

  const CustomDateInputWithValidation({
    Key? key,
    required this.dateController,
    required this.labelText,
    required this.date,
  }) : super(key: key);

  @override
  _CustomDateInputWithValidationState createState() =>
      _CustomDateInputWithValidationState();
}

class _CustomDateInputWithValidationState
    extends State<CustomDateInputWithValidation> {
  late DateTime now;
  late DateTime lastMonth;
  late DateTime firstDateOfLastMonth;

  @override
  void initState() {
    super.initState();
    now = DateTime.now();
    lastMonth = DateTime(now.year, now.month - 1, 1);
    firstDateOfLastMonth = DateTime(lastMonth.year, lastMonth.month, 1);
  }

  void pickDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: widget.date != null
          ? DateTime.parse(widget.date!)
          : firstDateOfLastMonth,
      lastDate: widget.date != null ? DateTime.now() : DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        widget.dateController.text =
            DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextFormField(
        controller: widget.dateController,
        readOnly: true,
        decoration: InputDecoration(
          labelText: widget.labelText,
          labelStyle: const TextStyle(fontSize: 14, color: Colors.blue),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          prefixIcon: IconButton(
            onPressed: pickDate,
            icon: const Icon(Icons.calendar_month_rounded),
          ),
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        validator: (val) {
          if (val!.isEmpty) {
            return "${widget.labelText} ရွေးပေးပါ";
          }
          return null;
        },
      ),
    );
  }
}
