import 'dart:convert';

import 'package:http/http.dart' as http;


class DoctorRepository{
  final String apiUrl = 'http://192.168.1.31:8080/api'; //URL api

  //lấy thông tin outstandingdoctor từ API
  Future<List<Map<String, dynamic>>> getOutstandingDoctor(int limit) async {
    final response = await http.get(
      Uri.parse('$apiUrl/top-doctor-home?limit=${limit}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody =
      jsonDecode(response.body); //chuyển phản hồi JSON thành Map
      if (responseBody['errCode'] == 0) {
        List<dynamic> doctors = responseBody['data']; //lấy danh sách doctor
        return List<Map<String, dynamic>>.from(
            doctors); //chuyển danh sách doctor thành list các object
      } else {
        throw Exception('Failed to fetch doctors: ${responseBody['message']}');
      }
    } else {
      throw Exception('Failed to fetch doctors');
    }
  }

  //lấy tất cả thông tin doctor từ API
  Future<List<Map<String, dynamic>>> getAllDoctors() async {
    final response = await http.get(
      Uri.parse('$apiUrl/get-all-doctors'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody =
      jsonDecode(response.body); //chuyển phản hồi JSON thành Map
      if (responseBody['errCode'] == 0) {
        List<dynamic> doctors = responseBody['data']; //lấy danh sách doctor
        return List<Map<String, dynamic>>.from(
            doctors); //chuyển danh sách doctor thành list các object
      } else {
        throw Exception('Failed to fetch doctors: ${responseBody['message']}');
      }
    } else {
      throw Exception('Failed to fetch doctors');
    }
  }
}