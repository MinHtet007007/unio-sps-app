import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CustomDateInputWithValidation extends StatefulWidget {
  final TextEditingController dateController;
  final String labelText;
  final String date;
  final bool isMonthYear;
  final DateTime? maxDate;
  final void Function(DateTime)? onDateChanged;
  final bool isRequired;

  const CustomDateInputWithValidation({
    Key? key,
    required this.dateController,
    required this.labelText,
    required this.date,
    this.isMonthYear = false,
    this.isRequired = true,
    this.maxDate,
    this.onDateChanged,
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
    DateTime currentDate = DateTime.now();
    DateTime lastDate =
        widget.maxDate != null && widget.maxDate!.isBefore(currentDate)
            ? widget.maxDate!
            : currentDate;
    DateTime initialDate =
        DateTime.now().isAfter(lastDate) ? lastDate : DateTime.now();
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: widget.date.isNotEmpty
          ? DateTime.parse(widget.date)
          : firstDateOfLastMonth,
      lastDate: lastDate,
    );
    if (pickedDate != null) {
      setState(() {
        widget.dateController.text = widget.isMonthYear
            ? DateFormat('yyyy-MM').format(pickedDate)
            : DateFormat('yyyy-MM-dd').format(pickedDate);

        if (widget.onDateChanged != null) {
          widget.onDateChanged!(pickedDate);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: TextFormField(
        onTap: pickDate,
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
          prefixIcon: const Icon(Icons.calendar_month_rounded),
        ),
        keyboardType: TextInputType.text,
        textInputAction: TextInputAction.next,
        validator: (val) {
          if (val!.isEmpty && widget.isRequired) {
            return "${widget.labelText} is required";
          }
          return null;
        },
      ),
    );
  }
}
