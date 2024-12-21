import 'package:sps/common/provider/local_database/local_database_provider.dart';
import 'package:sps/features/local_patient_create/provider/local_new_patient_state/local_new_patient_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sps/local_database/entity/patient_entity.dart';
import 'package:sps/local_database/entity/patient_package_entity.dart';

class LocalNewPatientProvider extends StateNotifier<LocalNewPatientState> {
  LocalNewPatientState localNewPatientState = LocalNewPatientInitialState();
  LocalDatabase localDatabase;

  LocalNewPatientProvider(this.localDatabase)
      : super(LocalNewPatientInitialState());

  Future<void> addPatient(PatientEntity formData) async {
    try {
      state = LocalNewPatientLoadingState();
      final database = await localDatabase.database;

      final patientDao = database.patientDao;
      final id = await patientDao.insertLocalPatient(formData);
      if (id > 0) {
        await assignPackagesToPatient(id);
        state = LocalNewPatientSuccessState();
        return;
      }
      state = LocalNewPatientFailedState('Patient Not Found');
      return;
    } catch (error, stackTrace) {
      print(error);
      print(stackTrace);
      state = LocalNewPatientFailedState(error.toString());
    } finally {
      state = LocalNewPatientInitialState();
    }
  }

  Future<void> assignPackagesToPatient(int patientId) async {
    final packages = {
      'Package 1': 250000,
      'Package 2': 350000,
      'Package 3': 150000,
      'Package 4': 400000,
      'Package 5': 50000,
      'Package 6': 600000,
      'Package 7': 300000,
      'Package 8': 35000,
      'Package 9': 280000,
    };

    // Create a list of PatientPackage objects
    final patientPackages = packages.entries.map((entry) {
      return PatientPackageEntity(
        localPatientId: patientId,
        packageName: entry.key,
        eligibleAmount: entry.value,
        remainingAmount: entry.value,
      );
    }).toList();

    final database = await localDatabase.database;

    // Insert all packages at once
    await database.patientPackageDao.insertMany(patientPackages);
  }
}

final localNewPatientProvider =
    StateNotifierProvider<LocalNewPatientProvider, LocalNewPatientState>(
        (ref) => LocalNewPatientProvider(ref.read(localDatabaseProvider)));
