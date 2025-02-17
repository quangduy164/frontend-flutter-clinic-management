import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class ClinicRepository {
  final String apiUrl = 'http://192.168.1.38:8080/api'; //URL api

  // Lưu thông tin clinic qua api
  Future<Map<String, dynamic>> createNewClinic(
      String name, String address, String introduce,
      String strengths, Uint8List imageBytes,) async {
    String base64Image = base64Encode(imageBytes); // Mã hóa ảnh thành Base64
    final response = await http.post(
      Uri.parse('$apiUrl/create-new-clinic'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'address': address,
        'introduce': introduce,
        'strengths': strengths,
        'image': base64Image,
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
      throw Exception('Failed to save information specialty');
    }
  }

  //lấy tất cả name, address clinic từ API
  Future<List<Map<String, dynamic>>> getAllClinics() async {
    final response = await http.get(
      Uri.parse('$apiUrl/get-all-clinics'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody =
      jsonDecode(response.body); //chuyển phản hồi JSON thành Map
      if (responseBody['errCode'] == 0) {
        List<dynamic> clinics = responseBody['data']; //lấy danh sách clinic
        return List<Map<String, dynamic>>.from(
            clinics); //chuyển danh sách clinic thành list các object
      } else {
        throw Exception('Failed to fetch clinics: ${responseBody['message']}');
      }
    } else {
      throw Exception('Failed to fetch clinics');
    }
  }

  //lấy tất cả thông tin clinic từ API
  Future<List<Map<String, dynamic>>> getAllDetailClinics() async {
    final response = await http.get(
      Uri.parse('$apiUrl/get-all-detail-clinics'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody =
      jsonDecode(response.body); //chuyển phản hồi JSON thành Map
      if (responseBody['errCode'] == 0) {
        List<dynamic> clinics = responseBody['data']; //lấy danh sách clinic
        return List<Map<String, dynamic>>.from(
            clinics); //chuyển danh sách clinic thành list các object
      } else {
        throw Exception('Failed to fetch clinics: ${responseBody['message']}');
      }
    } else {
      throw Exception('Failed to fetch clinics');
    }
  }

  //lấy thông tin chi tiết clinic theo id từ API
  Future<Map<String, dynamic>> getDetailClinicById(int clinicId) async {
    final response = await http.get(
      Uri.parse('$apiUrl/get-detail-clinic-by-id?id=$clinicId'),
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
            'Failed to fetch detail clinic: ${responseBody['message']}');
      }
    } else {
      throw Exception('Failed to fetch detail clinic');
    }
  }

}
