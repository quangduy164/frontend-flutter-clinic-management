import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

class SpecialtyRepository {
  final String apiUrl = 'http://192.168.1.38:8080/api'; //URL api

  // Lưu thông tin specialty qua api
  Future<Map<String, dynamic>> createNewSpecialty(
      String name, Uint8List imageBytes, String description) async {
    String base64Image = base64Encode(imageBytes); // Mã hóa ảnh thành Base64
    final response = await http.post(
      Uri.parse('$apiUrl/create-new-specialty'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'name': name,
        'image': base64Image,
        'description': description,
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

  //lấy tất cả thông tin specialty từ API
  Future<List<Map<String, dynamic>>> getAllSpecialties() async {
    final response = await http.get(
      Uri.parse('$apiUrl/get-all-specialties'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody =
      jsonDecode(response.body); //chuyển phản hồi JSON thành Map
      if (responseBody['errCode'] == 0) {
        List<dynamic> specialties = responseBody['data']; //lấy danh sách specialty
        return List<Map<String, dynamic>>.from(
            specialties); //chuyển danh sách specialty thành list các object
      } else {
        throw Exception('Failed to fetch specialties: ${responseBody['message']}');
      }
    } else {
      throw Exception('Failed to fetch specialties');
    }
  }

  //lấy tất cả thông tin specialty từ API
  Future<List<Map<String, dynamic>>> getAllDetailSpecialties() async {
    final response = await http.get(
      Uri.parse('$apiUrl/get-all-detail-specialties'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody =
      jsonDecode(response.body); //chuyển phản hồi JSON thành Map
      if (responseBody['errCode'] == 0) {
        List<dynamic> specialties = responseBody['data']; //lấy danh sách specialties
        return List<Map<String, dynamic>>.from(
            specialties); //chuyển danh sách specialties thành list các object
      } else {
        throw Exception('Failed to fetch specialties: ${responseBody['message']}');
      }
    } else {
      throw Exception('Failed to fetch specialties');
    }
  }

  //lấy thông tin chi tiết specialty theo id từ API
  Future<Map<String, dynamic>> getDetailSpecialtyById(int specialtyId, String location) async {
    final response = await http.get(
      Uri.parse('$apiUrl/get-detail-specialty-by-id?id=$specialtyId&location=$location'),
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
            'Failed to fetch detail specialty: ${responseBody['message']}');
      }
    } else {
      throw Exception('Failed to fetch detail specialty');
    }
  }

}
