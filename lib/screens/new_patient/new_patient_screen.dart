import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sps/screens/new_patient/widgets/new_patient_form.dart';

class NewPatientScreen extends ConsumerStatefulWidget {
  const NewPatientScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewPatientScreenState();
}

class _NewPatientScreenState extends ConsumerState<NewPatientScreen> {

  @override
  Widget build(BuildContext context) {
    return NewPatientForm(submit: () {});
  }
}