

sealed class LocalNewCounselingState {}

class LocalNewCounselingLoadingState extends LocalNewCounselingState {}


class LocalNewCounselingSuccessState extends LocalNewCounselingState {
  
}

class LocalNewCounselingFailedState extends LocalNewCounselingState {
  final String errorMessage;
  LocalNewCounselingFailedState(this.errorMessage);
}
class LocalNewCounselingFormState extends LocalNewCounselingState {}

