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
  final String email;
  final String role; // Thêm thuộc tính role

  const AuthenticationStateSuccess({required this.email, required this.role});

  @override
  List<Object?> get props => [email, role];

  @override
  String toString() {
    return 'AuthenticationStateSuccess{userId: $email, role: $role}';
  }
}

//Trạng thái đăng nhập thất bại
class AuthenticationStateFailure extends AuthenticationState {}
