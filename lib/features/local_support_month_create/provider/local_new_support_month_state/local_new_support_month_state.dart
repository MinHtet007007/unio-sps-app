sealed class LocalNewSupportMonthState {}

class LocalNewSupportMonthLoadingState extends LocalNewSupportMonthState {}

class LocalNewSupportMonthSuccessState extends LocalNewSupportMonthState {}

class LocalNewSupportMonthFailedState extends LocalNewSupportMonthState {
  final String errorMessage;
  LocalNewSupportMonthFailedState(this.errorMessage);
}

class LocalNewSupportMonthFormState extends LocalNewSupportMonthState {}
