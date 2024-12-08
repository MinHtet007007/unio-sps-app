import 'package:sps/local_database/entity/patient_entity.dart';

sealed class HomePatientsSyncState {}

class HomePatientsSyncLoadingState extends HomePatientsSyncState {}

class HomePatientsSyncSuccessState extends HomePatientsSyncState {
  HomePatientsSyncSuccessState();
}

class HomePatientsSyncFailedState extends HomePatientsSyncState {
  final String errorMessage;
  HomePatientsSyncFailedState(this.errorMessage);
}
