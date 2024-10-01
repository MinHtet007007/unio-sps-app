import 'package:sps/local_database/entity/counseling_entity.dart';

sealed class LocalUpdateCounselingState {}

class LocalUpdateCounselingLoadingState extends LocalUpdateCounselingState {}

class LocalUpdateCounselingSuccessState extends LocalUpdateCounselingState {
  final int patientId;
  LocalUpdateCounselingSuccessState(this.patientId);
}

class LocalUpdateCounselingFailedState extends LocalUpdateCounselingState {
  final String errorMessage;
  LocalUpdateCounselingFailedState(this.errorMessage);
}

class LocalCounselingFetchSuccessState extends LocalUpdateCounselingState {
  final Counseling counseling;
  LocalCounselingFetchSuccessState(this.counseling);
}
