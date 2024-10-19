import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
//cho phép ứng dụng lưu trữ dữ liệu dưới dạng key-value trên bộ nhớ cục bộ của thiết bị
import 'package:shared_preferences/shared_preferences.dart';

class UserRepository {
  final String apiUrl = 'http://192.168.1.31:8080/api'; //URL api

  // Đăng nhập với email và mật khẩu thông qua API Express
  Future<Map<String, dynamic>> signInWithEmailAndPassword(
      String email, String password) async {
    final response = await http.post(
      Uri.parse('$apiUrl/login'),
      headers: <String, String>{
        //Tiêu đề HTTP chứa thông tin về kiểu dữ liệu trong yêu cầu.
        'Content-Type': 'application/json; charset=UTF-8',
        //dữ liệu gửi đi là JSON.
      },
      body: jsonEncode(<String, String>{
        //req dạng JSON
        'email': email.trim(), //trim() để loại bỏ khoảng trắng
        'password': password.trim(),
      }),
    );

    if (response.statusCode == 200) {
      // Xử lý phản hồi từ API
      //Lưu thông tin người dùng vào bộ nhớ cục bộ SharedPreferences
      await saveAccessToken(jsonDecode(response.body)['accessToken']);
      return jsonDecode(response
          .body); //chuyển chuỗi JSON thành Map<String, dynamic> (dạng object Dart)
    } else {
      throw Exception('Failed to log in');
    }
  }

  // Tạo tài khoản mới với email và mật khẩu thông qua API Express
  Future<Map<String, dynamic>> createUserWithEmailAndPassword(
      String email, String password, String firstName, int gender) async {
    final response = await http.post(
      Uri.parse('$apiUrl/create-new-user'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'email': email.trim(),
        'password': password.trim(),
        'firstName': firstName.trim(),
        'lastName': 'Nguyen'.trim(),
        'address': 'VietNam'.trim(),
        'gender': gender,
        'roleId': 3
      }),
    );

    if (response.statusCode == 200) {
      // Xử lý phản hồi từ API
      //chuyển phản hồi JSON thành Map
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      print('-------------------------------------------------------');
      print(responseBody);
      print(responseBody['errCode']);
      if (responseBody['errCode'] == 0) {
        return {'success': true, 'message': responseBody['message']};
      } else {
        return {'success': false, 'message': responseBody['errMessage']};
      }
    } else {
      throw Exception('Failed to create account');
    }
  }

  //cập nhật thông tin người dùng
  Future<Map<String, dynamic>> updateUser(int id, String firstName, String lastName, String address, int roleId) async {
    final response = await http.put(
      Uri.parse('$apiUrl/edit-user'), // Đường dẫn API update
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': id,
        'firstName': firstName.trim(),
        'lastName': lastName.trim(),
        'address': address.trim(),
        'roleId': roleId
      }),
    );
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['errCode'] == 0) {
        return {'success': true, 'message': responseBody['message']};
      } else {
        return {'success': false, 'message': responseBody['errMessage']};
      }
    } else {
      throw Exception('Failed to update user');
    }
  }

  // Hàm cập nhật avatar người dùng vào database
  Future<Map<String, dynamic>> updateUserImage(int userId, Uint8List imageBytes) async {
    String base64Image = base64Encode(imageBytes); // Mã hóa ảnh thành Base64

    final response = await http.put(
      Uri.parse('$apiUrl/update-user-image'), // Đường dẫn API
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'id': userId,
        'image': base64Image, // Gửi ảnh dưới dạng chuỗi Base64
      }),
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['errCode'] == 0) {
        return {'success': true, 'message': responseBody['message']};
      } else {
        return {'success': false, 'message': responseBody['errMessage']};
      }
    } else {
      throw Exception('Failed to update user image');
    }
  }

  //xóa người dùng qua API Express
  Future<Map<String, dynamic>> deleteUser(int userId) async {
    final response = await http.delete(
      Uri.parse('$apiUrl/delete-user'), // Đường dẫn API xóa
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, int>{
        'id': userId, // Tham số id của người dùng cần xóa
      }),
    );

    if (response.statusCode == 200) {
      // Xử lý phản hồi từ API
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['errCode'] == 0) {
        return {'success': true, 'message': responseBody['message']};
      } else {
        return {'success': false, 'message': responseBody['errMessage']};
      }
    } else {
      throw Exception('Failed to delete user');
    }
  }

  // Lấy thông tin người dùng từ accessToken
  Future<Map<String, dynamic>?> getUserFromToken(String accessToken) async {
    final response = await http.get(
      Uri.parse('$apiUrl/user/profile'),
      headers: <String, String>{
        'Authorization': accessToken, //Gửi token để xác thực
      },
    );
    if (response.statusCode == 200) {
      return jsonDecode(
          response.body); //Trả về thông tin người dùng và vai trò dạng object
    } else {
      //token k hợp lệ hoặc hết hạn
      return null;
    }
  }

  //lấy tất cả thông tin người dùng từ API
  Future<List<Map<String, dynamic>>> getAllUsers(String userId) async {
    final response = await http.get(
      Uri.parse('$apiUrl/get-all-users?id=${userId}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody =
          jsonDecode(response.body); //chuyển phản hồi JSON thành Map
      if (responseBody['errCode'] == 0) {
        List<dynamic> users = responseBody['user']; //lấy danh sách user
        return List<Map<String, dynamic>>.from(
            users); //chuyển danh sách user thành list các object
      } else {
        throw Exception('Failed to fetch users: ${responseBody['message']}');
      }
    } else {
      throw Exception('Failed to fetch users');
    }
  }

  //lấy thông tin người dùng từ API
  Future<Map<String, dynamic>> getUser(int userId) async {
    final response = await http.get(
      Uri.parse('$apiUrl/get-user?id=$userId'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = jsonDecode(response.body);
      if (responseBody['errCode'] == 0) {
        return responseBody['user']; // Trả về object user
      } else {
        throw Exception('Failed to fetch user: ${responseBody['message']}');
      }
    } else {
      throw Exception('Failed to fetch user');
    }
  }

  //Kiểm tra xem user đã đăng nhập chưa qua accessToken
  Future<bool> isSignIn() async {
    final accessToken = await getAccessToken();
    if (accessToken != null) {
      final user =
          await getUserFromToken(accessToken); //kiểm tra thông tin có hợp lệ k
      return user != null;
    }
    return false;
  }

  //Đăng xuất
  Future<void> signOut() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('accessToken'); //xóa accessToken
  }

  // Lưu accessToken sau khi đăng nhập thành công
  Future<void> saveAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('accessToken', token);
  }

// Lấy accessToken từ SharedPreferences
  Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }
}
