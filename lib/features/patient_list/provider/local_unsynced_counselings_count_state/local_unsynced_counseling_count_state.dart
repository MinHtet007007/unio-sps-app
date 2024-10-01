
sealed class LocalUnsyncedCounselingCountState {}

class LocalUnsyncedCounselingCountLoadingState extends LocalUnsyncedCounselingCountState {}

class LocalUnsyncedCounselingCountSuccessState extends LocalUnsyncedCounselingCountState {
  final int count;
  LocalUnsyncedCounselingCountSuccessState(this.count);
}


class LocalUnsyncedCounselingCountFailedState extends LocalUnsyncedCounselingCountState {
  final String errorMessage;
  LocalUnsyncedCounselingCountFailedState(this.errorMessage);
}
