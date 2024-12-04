

sealed class LocalNewPatientState {}

class LocalNewPatientLoadingState extends LocalNewPatientState {}


class LocalNewPatientSuccessState extends LocalNewPatientState {
  
}

class LocalNewPatientFailedState extends LocalNewPatientState {
  final String errorMessage;
  LocalNewPatientFailedState(this.errorMessage);
}
class LocalNewPatientFormState extends LocalNewPatientState {}

