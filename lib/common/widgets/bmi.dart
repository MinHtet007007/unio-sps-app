import 'package:flutter/material.dart';

class BMI extends StatefulWidget {
  final TextEditingController heightController;
  final TextEditingController weightController;
  final double? bmi;
  final void Function(double) onBMIChange;

  BMI(
      {required this.heightController,
      required this.weightController,
      required this.bmi,
      required this.onBMIChange});

  @override
  _BMIState createState() => _BMIState();
}

class _BMIState extends State<BMI> {
  void _calculateBMI() {
    final heightText = widget.heightController.text;
    final weightText = widget.weightController.text;

    if (heightText.isNotEmpty && weightText.isNotEmpty) {
      final height = double.tryParse(heightText) ?? 0;
      final weight = double.tryParse(weightText) ?? 0;

      if (height > 0 && weight > 0) {
        final bmi = weight / (height * height);
        widget.onBMIChange(bmi);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    widget.heightController.addListener(_calculateBMI);
    widget.weightController.addListener(_calculateBMI);
  }

  @override
  void dispose() {
    widget.heightController.removeListener(_calculateBMI);
    widget.weightController.removeListener(_calculateBMI);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.bmi != null)
          Text(
            'Your BMI: ${widget.bmi!.toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
      ],
    );
  }
}
