import 'package:equatable/equatable.dart';

class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object?> get props => [];
}

class AuthenticationStateInitial
    extends AuthenticationState {} //khởi đầu trạng thái xác thực

//Trạng thái đăng nhập thành công lưu email và roleUser
class AuthenticationStateSuccess extends AuthenticationState {
  final int userId;
  final String role; // Thêm thuộc tính role
  final String firstName; // Thêm thuộc tính firstName

  const AuthenticationStateSuccess({
    required this.userId,
    required this.role,
    required this.firstName
  });

  @override
  List<Object?> get props => [userId, role];

  @override
  String toString() {
    return 'AuthenticationStateSuccess{userId: $userId, role: $role}';
  }
}

//Trạng thái đăng nhập thất bại
class AuthenticationStateFailure extends AuthenticationState {}
