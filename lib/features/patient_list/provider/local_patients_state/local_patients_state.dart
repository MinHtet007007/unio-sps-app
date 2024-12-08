import 'package:sps/local_database/entity/patient_entity.dart';

sealed class LocalPatientsState {}

class LocalPatientsLoadingState extends LocalPatientsState {}

class LocalPatientsSuccessState extends LocalPatientsState {
  final List<PatientEntity> localPatients;
  LocalPatientsSuccessState(this.localPatients);
}

class LocalPatientsFailedState extends LocalPatientsState {
  final String errorMessage;
  LocalPatientsFailedState(this.errorMessage);
}
