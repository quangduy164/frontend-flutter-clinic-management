import 'dart:convert';

import 'package:http/http.dart' as http;

class PatientRepository {
  final String apiUrl = 'http://192.168.1.38:8080/api'; //URL api

  // Lưu thông tin patient qua api
  Future<Map<String, dynamic>> patientBookAppointment(
      String email, int doctorId, String doctorName, String date,
      String timeType, String schedule,
      String name, String address, String gender, String phoneNumber
      ) async {
    final response = await http.post(
      Uri.parse('$apiUrl/patient-book-appointment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email,
        'name': name,
        'address': address,
        'gender': gender,
        'phoneNumber': phoneNumber,
        'doctorId': doctorId,
        'doctorName': doctorName,
        'date': date.trim(),
        'schedule': schedule.trim(),
        'timeType': timeType.trim(),
      }),
    );

    if (response.statusCode == 200) {
      // Xử lý phản hồi từ API
      //chuyển phản hồi JSON thành Map
      final Map<String, dynamic> responseBody = jsonDecode(response.body);

      if (responseBody['errCode'] == 0) {
        return {'success': true, 'message': responseBody['message']};
      } else {
        return {'success': false, 'message': responseBody['errMessage']};
      }
    } else {
      throw Exception('Failed to save information patient');
    }
  }
}
