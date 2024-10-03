import 'package:meta/meta.dart'; //cung cấp @immutable

@immutable //Đánh dấu lớp này là bất biến, tức là không thể thay đổi giá trị của các trường sau khi đối tượng được tạo.
class LoginState {
  final bool isValidEmail; //Kiểm tra email hợp lệ
  final bool isValidPassword;
  final bool isSubmitting; //Kiểm tra đang đăng nhập không
  final bool isSuccess; //Kiểm tra đăng nhập thành công
  final bool isFailure;

  bool get isValidEmailAndPassword => isValidEmail && isValidPassword;

  //Contructor
  LoginState(
      {required this.isValidEmail,
      required this.isValidPassword,
      required this.isSubmitting,
      required this.isSuccess,
      required this.isFailure});

  //factory để tạo ra các trạng thái khởi đầu khác nhau của lớp
  factory LoginState.initial() {
    return LoginState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false);
  }

  //Trạng thái loading
  factory LoginState.loading() {
    return LoginState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false);
  }

  factory LoginState.success() {
    return LoginState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false);
  }

  factory LoginState.failure() {
    return LoginState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true);
  }

  //Nhân bản trạng thái
  LoginState cloneWith(
      {bool? isValidEmail,
      bool? isValidPassword,
      bool? isSubmitting,
      bool? isSuccess,
      bool? isFailure}) {
    return LoginState(
        isValidEmail: isValidEmail ?? this.isValidEmail,
        //Nếu isValidEmail đưa vào ==null thì lấy giá trị cũ
        isValidPassword: isValidPassword ?? this.isValidPassword,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure);
  }

  //Nhân bản đối tượng và cập nhật đối tượng
  LoginState cloneAndUpdate({bool? isValidEmail, bool? isValidPassword}) {
    return cloneWith(
        isValidEmail: isValidEmail, isValidPassword: isValidPassword);
  }
}
