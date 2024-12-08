import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/local_database/entity/support_month_entity.dart';

sealed class LocalPatientState {}

class LocalPatientLoadingState extends LocalPatientState {}

class LocalPatientSuccessState extends LocalPatientState {
  final PatientEntity localPatient;
  final List<SupportMonthEntity> localSupportMonths;
  LocalPatientSuccessState(this.localPatient, this.localSupportMonths);
}

class LocalPatientFailedState extends LocalPatientState {
  final String errorMessage;
  LocalPatientFailedState(this.errorMessage);
}
