// utils.dart
import 'package:flutter/material.dart';
import 'package:signature/signature.dart';
import 'package:sps/local_database/entity/patient_package_entity.dart';

class PackageFormUtils {
  static bool validateAndCalculateBMI({
    required TextEditingController weightController,
    required double height,
    required bool isReimbursement,
    required Function(double) onBMICalculated,
  }) {
    final weightText = weightController.text;
    if (weightText.isNotEmpty) {
      final weight = double.tryParse(weightText) ?? 0.0;
      if (weight > 0 && height > 0) {
        final bmi = weight / (height * height);
        onBMICalculated(bmi);
        return true;
      }
    }
    onBMICalculated(0.0);
    return false;
  }

  static void updatePackageList({
    required List<PatientPackageEntity> packages,
    required int packageId,
    required int givenAmount,
  }) {
    final packageIndex = packages.indexWhere((pkg) => pkg.id == packageId);
    if (packageIndex != -1) {
      final updatedPackage = packages[packageIndex].copyWith(
        remainingAmount: packages[packageIndex].remainingAmount - givenAmount,
      );
      packages[packageIndex] = updatedPackage;
    }
  }
}

class SnackbarUtils {
  static void showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}

extension PackageEntityExtensions on PatientPackageEntity {
  PatientPackageEntity copyWith({
    int? remainingAmount,
  }) {
    return PatientPackageEntity(
      id: this.id,
      remoteId: this.remoteId,
      localPatientId: this.localPatientId,
      remotePatientId: this.remotePatientId,
      packageName: this.packageName,
      eligibleAmount: this.eligibleAmount,
      updatedEligibleAmount: this.updatedEligibleAmount,
      remainingAmount: remainingAmount ?? this.remainingAmount,
    );
  }
}
