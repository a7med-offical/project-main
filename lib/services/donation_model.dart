import 'dart:convert';
import 'package:http/http.dart' as http;

class Services {
  Future<int> makePrediction({
    required int bloodPressure,
    required double levelHemoglobin,
    required int age,
    required int bmi,
    required int gender,
    required int pregancy,
    required int smoking,
    required int chronicKidney,
    required int adrenalAndThyroidDisorders,
    required String bloodType,
  }) async {
    const apiUrl = 'https://atr-tykl.onrender.com/';
    Map<String, dynamic> inputData = {
      "Blood_Pressure_Abnormality": (bloodPressure - 1),
      "Level_of_Hemoglobin": levelHemoglobin,
      "Age": age,
      "BMI": bmi,
      "Sex": (gender - 1),
      "Pregnancy": (pregancy - 1),
      "Smoking": (smoking - 1),
      "Chronic_kidney_disease": (chronicKidney - 1),
      "Adrenal_and_thyroid_disorders": (adrenalAndThyroidDisorders - 1)
    };
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json'
        },
        body: jsonEncode(inputData),
      );

      if (response.statusCode == 200) {
        if ((response.body).contains('0')) {
          print('Rejected');
          return 0;
        } else {
          print('Accepted');
          return 1;
        }
      } else {
        throw Exception(response.statusCode);
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
