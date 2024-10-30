import 'dart:convert';

import 'package:http/http.dart' as http;

class DoctorRepository {
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

  // Lưu thông tin doctor qua api
  Future<Map<String, dynamic>> saveInforDoctor(
      int doctorId, String content, String? description, String action,
      String selectedPrice, String selectedPayment, String selectedProvince,
      String nameClinic, String addressClinic, String? note) async {
    final response = await http.post(
      Uri.parse('$apiUrl/save-infor-doctor'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'doctorId': doctorId,
        'content': content.trim(),
        'description': description,
        'action': action,
        'selectedPrice': selectedPrice.trim(),
        'selectedPayment': selectedPayment.trim(),
        'selectedProvince': selectedProvince.trim(),
        'nameClinic': nameClinic.trim(),
        'addressClinic': addressClinic.trim(),
        'note': note
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
      throw Exception('Failed to save information doctor');
    }
  }

  //lấy thông tin chi tiết doctor từ API
  Future<Map<String, dynamic>> getDetailDoctorById(int doctorId) async {
    final response = await http.get(
      Uri.parse('$apiUrl/get-detail-doctor-by-id?id=$doctorId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['errCode'] == 0) {
        return responseBody['data']; // Trả về object data
      } else {
        throw Exception(
            'Failed to fetch detail doctor: ${responseBody['message']}');
      }
    } else {
      throw Exception('Failed to fetch detail doctor');
    }
  }

  //Lưu thông tin lịch khám
  Future<Map<String, dynamic>> saveBulkCreateSchedule(
      List<Map<String, dynamic>> arrSchedule) async {
    final response = await http.post(
      Uri.parse('$apiUrl/bulk-create-schedule'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(arrSchedule),
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
      throw Exception('Failed to save information doctor');
    }
  }

  //lấy tất cả lịch khám bác sĩ theo ngày từ API
  Future<List<Map<String, dynamic>>> getScheduleDoctorByDate(int doctorId, String date) async {
    final response = await http.get(
      Uri.parse('$apiUrl/get-schedule-doctor-by-date?doctorId=${doctorId}&date=${date}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody =
      jsonDecode(response.body); //chuyển phản hồi JSON thành Map
      if (responseBody['errCode'] == 0) {
        List<dynamic> schedules = responseBody['data']; //lấy danh sách schedule
        return List<Map<String, dynamic>>.from(
            schedules); //chuyển danh sách schedule thành list các object
      } else {
        throw Exception('Failed to fetch doctor schedules: ${responseBody['message']}');
      }
    } else {
      throw Exception('Failed to fetch doctor schedules');
    }
  }

}