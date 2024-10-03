import 'package:equatable/equatable.dart'; //giúp so sánh các đối tượng dựa trên giá trị của thuộc tính

abstract class LoginEvent extends Equatable {
  const LoginEvent();

  @override
  List<Object?> get props =>
      []; //xác định thuộc tính nào được sử dụng để so sánh hai đối tượng với nhau
}

class LoginEmailChanged extends LoginEvent {
  //Khi email ở UI thay đổi thì kích hoạt event
  final String email;

  const LoginEmailChanged({required this.email});

  @override
  List<Object?> get props => [
        email
      ]; //khi so sánh hai đối tượng LoginEmailChanged, nó sẽ dựa vào giá trị của thuộc tính email
  @override
  String toString() {
    return 'LogIn Email Changed: $email'; //debug
  }
}

class LoginPasswordChanged extends LoginEvent {
  final String password;

  const LoginPasswordChanged({required this.password});

  @override
  List<Object?> get props => [password];

  @override
  String toString() {
    return 'LogIn Password Changed: $password';
  }
}

//Khi nhấn vào đăng nhập bằng goole
class LogInEventWithGooglePressed
    extends LoginEvent {} //Kích hoạt event LoginGoogle khi nhấn nút

class LogInEventWithEmailAndPasswordPressed extends LoginEvent {
  final String email;
  final String password;

  const LogInEventWithEmailAndPasswordPressed(
      {required this.email, required this.password});

  @override
  // TODO: implement props
  List<Object?> get props => [email, password];

  @override
  String toString() =>
      'LogInEventWithEmailAndPasswordPressed, email: $email, password: $password';
}
