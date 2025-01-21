sealed class LocalEditPatientState {}

class LocalEditPatientLoadingState extends LocalEditPatientState {}

class LocalEditPatientSuccessState extends LocalEditPatientState {}

class LocalEditPatientFailedState extends LocalEditPatientState {
  final String errorMessage;
  LocalEditPatientFailedState(this.errorMessage);
}

class LocalEditPatientInitialState extends LocalEditPatientState {}
