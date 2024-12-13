import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/local_database/entity/patient_package_entity.dart';
import 'package:sps/local_database/entity/support_month_entity.dart';

sealed class LocalPatientState {}

class LocalPatientLoadingState extends LocalPatientState {}

class LocalPatientSuccessState extends LocalPatientState {
  final PatientEntity localPatient;
  final List<SupportMonthEntity> localSupportMonths;
  final List<PatientPackageEntity> localPatientPackages;
  LocalPatientSuccessState(this.localPatient, this.localSupportMonths, this.localPatientPackages);
}

class LocalPatientFailedState extends LocalPatientState {
  final String errorMessage;
  LocalPatientFailedState(this.errorMessage);
}
