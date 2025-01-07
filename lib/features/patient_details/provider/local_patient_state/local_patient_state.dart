import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/local_database/entity/patient_package_entity.dart';
import 'package:sps/local_database/entity/receive_package_entity.dart';
import 'package:sps/local_database/entity/support_month_entity.dart';

sealed class LocalPatientState {}

class LocalPatientLoadingState extends LocalPatientState {}

class LocalPatientSuccessState extends LocalPatientState {
  final PatientEntity localPatient;
  final List<SupportMonthEntity> localSupportMonths;
  final List<PatientPackageEntity> localPatientPackages;
  final SupportMonthEntity? localSupportMonth;
  final List<ReceivePackageEntity>? localReceivedPackagesBySupportMonthId;
  final List<ReceivePackageEntity>? localReceivedPackagesByPatientId;
  LocalPatientSuccessState(this.localPatient, this.localSupportMonths,
      this.localPatientPackages, this.localSupportMonth, this.localReceivedPackagesBySupportMonthId, this.localReceivedPackagesByPatientId);
}

class LocalPatientFailedState extends LocalPatientState {
  final String errorMessage;
  LocalPatientFailedState(this.errorMessage);
}
