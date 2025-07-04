
sealed class HomePatientsSyncState {}

class HomePatientsSyncLoadingState extends HomePatientsSyncState {}

class HomePatientsSyncInitialState extends HomePatientsSyncState {}

class HomePatientsSyncSuccessState extends HomePatientsSyncState {
  HomePatientsSyncSuccessState();
}

class HomePatientsSyncSuccessHasMoreState extends HomePatientsSyncState {
  HomePatientsSyncSuccessHasMoreState();
}

class HomePatientsSyncFailedState extends HomePatientsSyncState {
  final String errorMessage;
  HomePatientsSyncFailedState(this.errorMessage);
}
