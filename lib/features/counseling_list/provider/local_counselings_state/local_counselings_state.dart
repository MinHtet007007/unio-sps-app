import 'package:sps/local_database/entity/counseling_entity.dart';
import 'package:sps/local_database/entity/patient_entity.dart';

sealed class LocalCounselingsState {}

class LocalCounselingsLoadingState extends LocalCounselingsState {}

class LocalCounselingsSuccessState extends LocalCounselingsState {
  final List<Counseling> localCounselings;
  LocalCounselingsSuccessState(this.localCounselings);
}

class LocalCounselingsFailedState extends LocalCounselingsState {
  final String errorMessage;
  LocalCounselingsFailedState(this.errorMessage);
}
