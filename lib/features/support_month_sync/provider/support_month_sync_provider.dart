import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sps/common/helpers/cache.dart';
import 'package:sps/common/provider/dio/dio_provider.dart';

import 'package:sps/common/provider/local_database/local_database_provider.dart';
import 'package:sps/features/patient_home_sync/provider/home_sync_state.dart';
import 'package:sps/features/support_month_sync/service/support_month_sync_service.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

class SupportMonthSyncProvider extends StateNotifier<HomePatientsSyncState> {
  LocalDatabase localDatabase;
  final Dio _dio;

  SupportMonthSyncProvider(this.localDatabase, this._dio)
      : super(HomePatientsSyncLoadingState());

  Future<void> syncSupportMonths() async {
    try {
      state = HomePatientsSyncLoadingState();

      final service = SupportMonthSyncService(_dio);

      // Number of entries
      int number = 2;
      // Load the asset as ByteData
      final ByteData data =
          await rootBundle.load('assets/images/the_union.png');

      // Write the data to a file in the application documents directory
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/the_union.png';
      final File imageFile = File(filePath);
      await imageFile.writeAsBytes(data.buffer.asUint8List());

      // Ensure the file exists
      if (!await imageFile.exists()) {
        throw Exception("Failed to create file for asset");
      }

      // Create MultipartFile using the created file
      final MultipartFile multipartFile = MultipartFile.fromFileSync(
        imageFile.path,
        filename: "the_union.png",
      );
      // Bulk data
      List<Map<String, dynamic>> bulkData = [
        {
          "patient_id": 1,
          "township_id": 10,
          "date": "2024-12-01",
          "month": 1,
          "month_year": "2024-12",
          "height": 160.5,
          "weight": 55.3,
          "BMI": 21.5,
          "plan_packages": "Plan A",
          "receive_package_status": "Yes",
          "reimbursement_status": "No",
          "remark": "First support package",
          "image": multipartFile,
          "receive_packages": [
            {
              "patient_package_id": 101,
              "patient_package_name": "Basic Package",
              "amount": 1500,
              "reimbursement_month": 1,
              "reimbursement_month_year": "2024-12",
            },
            {
              "patient_package_id": 102,
              "patient_package_name": "Advanced Package",
              "amount": 2000,
              "reimbursement_month": 2,
              "reimbursement_month_year": "2025-01",
            },
          ],
        },
        {
          "patient_id": 2,
          "township_id": 11,
          "date": "2024-12-02",
          "month": 2,
          "month_year": "2024-12",
          "height": 170.0,
          "weight": 60.0,
          "BMI": 20.8,
          "plan_packages": "Plan B",
          "receive_package_status": "No",
          "reimbursement_status": "Yes",
          "remark": "Second support package",
          "receive_packages": [
            {
              "patient_package_id": 103,
              "patient_package_name": "Special Package",
              "amount": 2500,
              "reimbursement_month": 3,
              "reimbursement_month_year": "2025-02",
            },
          ],
        },
      ];

      FormData formData = createFormData(bulkData);
      final token = await Cache.getToken();

      final response = await _dio.post(
        'https://205e-103-231-95-45.ngrok-free.app/api/v1/app/support-months/sync',
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer $token", // Add the token here
          },
        ),
      );
      // Send the request
      // final response = await service.syncLocalSupportMonths(
      //   number: number,
      //   bulkData: formData, // Use FormData fields
      // );
      // if (response.data.isNotEmpty) {
      //   state = HomePatientsSyncSuccessState();
      //   return;
      // } else {
      //   state = HomePatientsSyncFailedState('There is no patients');
      // }
      return;
    } catch (error) {
      print(error);
      state = HomePatientsSyncFailedState(error.toString());
    }
  }
}

final supportMonthSyncProvider =
    StateNotifierProvider<SupportMonthSyncProvider, HomePatientsSyncState>(
        (ref) => SupportMonthSyncProvider(
            ref.read(localDatabaseProvider), ref.read(dioProvider)));

// Helper function to flatten bulk data into FormData format

// Helper function to flatten bulk data into FormData format
FormData createFormData(List<Map<String, dynamic>> bulkData) {
  FormData formData = FormData();

  for (int i = 0; i < bulkData.length; i++) {
    final data = bulkData[i];

    // Add the main fields
    formData.fields.addAll([
      MapEntry("[$i][patient_id]", data["patient_id"].toString()),
      MapEntry("[$i][township_id]", data["township_id"].toString()),
      MapEntry("[$i][date]", data["date"]),
      MapEntry("[$i][month]", data["month"].toString()),
      MapEntry("[$i][month_year]", data["month_year"]),
      MapEntry("[$i][height]", data["height"].toString()),
      MapEntry("[$i][weight]", data["weight"].toString()),
      MapEntry("[$i][BMI]", data["BMI"].toString()),
      MapEntry("[$i][plan_packages]", data["plan_packages"]),
      MapEntry("[$i][receive_package_status]", data["receive_package_status"]),
      MapEntry("[$i][reimbursement_status]", data["reimbursement_status"]),
      MapEntry("[$i][remark]", data["remark"] ?? ""),
    ]);

    // Add the image file if it exists
    if (data["image"] is MultipartFile) {
      formData.files.add(
        MapEntry("[$i][image]", data["image"]),
      );
    }

    // Add nested receive_packages
    final receivePackages =
        data["receive_packages"] as List<Map<String, dynamic>>;
    for (int j = 0; j < receivePackages.length; j++) {
      final package = receivePackages[j];
      formData.fields.addAll([
        MapEntry(
          "[$i][receive_packages][$j][patient_package_id]",
          package["patient_package_id"].toString(),
        ),
        MapEntry(
          "[$i][receive_packages][$j][patient_package_name]",
          package["patient_package_name"],
        ),
        MapEntry(
          "[$i][receive_packages][$j][amount]",
          package["amount"].toString(),
        ),
        MapEntry(
          "[$i][receive_packages][$j][reimbursement_month]",
          package["reimbursement_month"].toString(),
        ),
        MapEntry(
          "[$i][receive_packages][$j][reimbursement_month_year]",
          package["reimbursement_month_year"],
        ),
      ]);
    }
  }
  return formData;
}
