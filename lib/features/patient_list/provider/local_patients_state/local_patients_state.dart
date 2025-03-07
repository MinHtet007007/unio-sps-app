import 'package:sps/local_database/entity/patient_support_month.dart';

sealed class LocalPatientsState {}

class LocalPatientsLoadingState extends LocalPatientsState {}

class LocalPatientsSuccessState extends LocalPatientsState {
  final List<PatientSupportMonth> localPatients;
  LocalPatientsSuccessState(this.localPatients);
}

class LocalPatientsFailedState extends LocalPatientsState {
  final String errorMessage;
  LocalPatientsFailedState(this.errorMessage);
}
