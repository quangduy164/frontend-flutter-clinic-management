import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class DoctorRepository {
  final String apiUrl = 'http://192.168.1.38:8080/api'; //URL api

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
      int selectedSpecialty, int selectedClinic,
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
        'selectedSpecialty': selectedSpecialty,
        'selectedClinic': selectedClinic,
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

  //lấy thông tin thêm của bác sĩ:địa chỉ, giá khám, payment từ API
  Future<Map<String, dynamic>> getExtraInforDoctorById(int doctorId) async {
    final response = await http.get(
      Uri.parse('$apiUrl/get-extra-infor-doctor-by-id?doctorId=${doctorId}'),
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
            'Failed to fetch extra infor doctor: ${responseBody['message']}');
      }
    } else {
      throw Exception('Failed to fetch extra infor doctor');
    }
  }

  //lấy thông tin profile doctor từ API
  Future<Map<String, dynamic>> getProfileDoctorById(int doctorId) async {
    final response = await http.get(
      Uri.parse('$apiUrl/get-profile-doctor-by-id?doctorId=$doctorId'),
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
            'Failed to fetch profile doctor: ${responseBody['message']}');
      }
    } else {
      throw Exception('Failed to fetch profile doctor');
    }
  }

  //lấy danh sách patient đặt lịch theo ngày từ API
  Future<List<Map<String, dynamic>>> getListPatientForDoctorByDate(
      int doctorId, String date) async {
    final response = await http.get(
      Uri.parse('$apiUrl/get-list-patient-for-doctor?doctorId=$doctorId&date=$date'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody =
      jsonDecode(response.body); //chuyển phản hồi JSON thành Map
      if (responseBody['errCode'] == 0) {
        List<dynamic> patients = responseBody['data']; //lấy danh sách patient
        return List<Map<String, dynamic>>.from(
            patients); //chuyển danh sách patient thành list các object
      } else {
        throw Exception('Failed to fetch patients: ${responseBody['message']}');
      }
    } else {
      throw Exception('Failed to fetch patients');
    }
  }

  //xác nhận khám xong và gửi email hóa đơn cho patient
  Future<Map<String, dynamic>> sendRemedy(
      int doctorId, String email, String name,
      Uint8List imageBytes, String token) async {
    String base64Image = base64Encode(imageBytes); // Mã hóa ảnh thành Base64
    final response = await http.post(
      Uri.parse('$apiUrl/send-remedy'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'doctorId': doctorId,
        'email': email.trim(),
        'name': name,
        'image': base64Image,
        'token': token.trim(),
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
      throw Exception('Failed to send remedy');
    }
  }

}