
sealed class LocalPatientsSyncState {}

class LocalPatientsSyncInitialState extends LocalPatientsSyncState {}

class LocalPatientsSyncLoadingState extends LocalPatientsSyncState {}

class LocalPatientsSyncSuccessState extends LocalPatientsSyncState {
  LocalPatientsSyncSuccessState();
}

class LocalPatientsSyncFailedState extends LocalPatientsSyncState {
  final String errorMessage;
  LocalPatientsSyncFailedState(this.errorMessage);
}
