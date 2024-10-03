import 'package:equatable/equatable.dart';

class AuthenticationEvent extends Equatable {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

//Kích hoạt event khi bắt đầu xác thực user
class AuthenticationEventStarted extends AuthenticationEvent {}

//kích hoạt event khi người dùng đăng nhập
class AuthenticationEventLoggedIn extends AuthenticationEvent {}

//kích hoạt event khi người dùng đăng xuất
class AuthenticationEventLoggedOut extends AuthenticationEvent {}
