import 'package:sps/local_database/entity/patient_entity.dart';

sealed class LocalPatientsSyncState {}

class LocalPatientsSyncLoadingState extends LocalPatientsSyncState {}

class LocalPatientsSyncSuccessState extends LocalPatientsSyncState {
  LocalPatientsSyncSuccessState();
}

class LocalPatientsSyncFailedState extends LocalPatientsSyncState {
  final String errorMessage;
  LocalPatientsSyncFailedState(this.errorMessage);
}
