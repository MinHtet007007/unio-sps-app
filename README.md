# To auto generate runner for local database and retrofit

flutter pub run build_runner build --delete-conflicting-outputs


# to do 

# patients create and sync 
- send all local patient and related data 

At server 
- store patient data , isSynced 
- store patient package 
- create a object which can map local patient package id with remote patient package id 
- store support month 
    - for eacth month, store receive package 
        - for receive package patient package id , use the mapped remote patient package id 


if patient is not new 
do not need to map object 
when storing support month and each package, reduce patient package amount 



import 'dart:io';
import 'package:dio/dio.dart';

Future<void> uploadPatientsWithSignatures(
    List<Map<String, dynamic>> patients, List<File> signatures) async {
  try {
    if (patients.length != signatures.length) {
      throw Exception('Each patient must have a corresponding signature.');
    }

    final dio = Dio();
    final formData = FormData();

    // Add patients data
    formData.fields.add(MapEntry(
      'patients',
      patients.map((patient) => patient.toString()).toList().toString(),
    ));

    // Add each signature file
    for (int i = 0; i < signatures.length; i++) {
      final fileName = signatures[i].path.split('/').last;
      formData.files.add(MapEntry(
        'signatures[$i]',
        await MultipartFile.fromFile(signatures[i].path, filename: fileName),
      ));
    }

    // Send the request
    final response = await dio.post(
      'https://your-backend-url/api/upload-patients',
      data: formData,
      options: Options(
        headers: {
          'Authorization': 'Bearer YOUR_TOKEN', // Add auth headers if needed
        },
      ),
    );

    print('Response: ${response.data}');
  } catch (e) {
    print('Error uploading patients: $e');
  }
}

PatientController
namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\Patient;

class PatientController extends Controller
{
    public function uploadPatients(Request $request)
    {
        // Validate the request
        $request->validate([
            'patients' => 'required|array', // Expecting an array of patients
            'patients.*.name' => 'required|string',
            'patients.*.age' => 'required|integer',
            'patients.*.sex' => 'required|string',
            'signatures' => 'required|array', // Array of files
            'signatures.*' => 'required|image|max:2048', // Each file must be an image
        ]);

        $patients = $request->input('patients');
        $uploadedFiles = $request->file('signatures');

        if (count($patients) !== count($uploadedFiles)) {
            return response()->json([
                'message' => 'Each patient must have a corresponding signature.',
            ], 400);
        }

        $storedPatients = [];

        foreach ($patients as $index => $patientData) {
            $signature = $uploadedFiles[$index];
            $signaturePath = $signature->store('signatures', 'public');

            // Create a patient with its corresponding signature path
            $patient = Patient::create(array_merge($patientData, [
                'signature_path' => $signaturePath,
            ]));

            $storedPatients[] = $patient;
        }

        return response()->json([
            'message' => 'Patients and signatures uploaded successfully',
            'patients' => $storedPatients,
        ]);
    }
}

# support months create and sync 


# field officer login flow 

when change township, 
login again 
reset all data 