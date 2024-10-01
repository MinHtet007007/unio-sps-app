import 'package:sps/local_database/entity/patient_entity.dart';

sealed class LocalPatientState {}

class LocalPatientLoadingState extends LocalPatientState {}

class LocalPatientSuccessState extends LocalPatientState {
  final Patient localPatient;
  LocalPatientSuccessState(this.localPatient);
}

class LocalPatientFailedState extends LocalPatientState {
  final String errorMessage;
  LocalPatientFailedState(this.errorMessage);
}
