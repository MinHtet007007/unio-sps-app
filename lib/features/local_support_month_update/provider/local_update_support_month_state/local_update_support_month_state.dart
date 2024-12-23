sealed class LocalUpdateSupportMonthState {}

class LocalUpdateSupportMonthLoadingState extends LocalUpdateSupportMonthState {}

class LocalUpdateSupportMonthSuccessState extends LocalUpdateSupportMonthState {}

class LocalUpdateSupportMonthFailedState extends LocalUpdateSupportMonthState {
  final String errorMessage;
  LocalUpdateSupportMonthFailedState(this.errorMessage);
}

class LocalUpdateSupportMonthFormState extends LocalUpdateSupportMonthState {}
