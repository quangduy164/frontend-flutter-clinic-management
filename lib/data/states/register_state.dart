import 'package:meta/meta.dart';

@immutable
class RegisterState {
  final bool isValidEmail;
  final bool isValidPassword;
  final bool isSubmitting;
  final bool isSuccess;
  final bool isFailure;
  final String? successMessage;//thêm thuộc tính thông báo thành công
  final String? errMessage;//thêm thuộc tính thông báo lỗi

  bool get isValidEmailAndPassword => isValidEmail && isValidPassword;

  //Contructor
  RegisterState({
    required this.isValidEmail,
    required this.isValidPassword,
    required this.isSubmitting,
    required this.isSuccess,
    required this.isFailure,
    this.successMessage,
    this.errMessage
  });

  //Với mỗi đối tượng có thể tạo ra bởi phương thức static hoặc factory
  factory RegisterState.initial() {
    return RegisterState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: false,
        successMessage: null,
        errMessage: null
    );
  }

  //Trạng thái loading
  factory RegisterState.loading() {
    return RegisterState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: true,
        isSuccess: false,
        isFailure: false,
        successMessage: null,
        errMessage: null
    );
  }

  factory RegisterState.success(String successMessage) {
    return RegisterState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: false,
        isSuccess: true,
        isFailure: false,
        successMessage: successMessage,
        errMessage: null
    );
  }

  factory RegisterState.failure(String errMessage) {
    return RegisterState(
        isValidEmail: true,
        isValidPassword: true,
        isSubmitting: false,
        isSuccess: false,
        isFailure: true,
        successMessage: null,
        errMessage: errMessage
    );
  }

  //Nhân bản trạng thái
  RegisterState cloneWith({
    bool? isValidEmail,
    bool? isValidPassword,
    bool? isSubmitting,
    bool? isSuccess,
    bool? isFailure,
    String? successMessage,
    String? errMessage,
  }) {
    return RegisterState(
        isValidEmail: isValidEmail ?? this.isValidEmail,
        //Nếu isValidEmail đưa vào ==null thì lấy giá trị cũ
        isValidPassword: isValidPassword ?? this.isValidPassword,
        isSubmitting: isSubmitting ?? this.isSubmitting,
        isSuccess: isSuccess ?? this.isSuccess,
        isFailure: isFailure ?? this.isFailure,
        successMessage: successMessage ?? this.successMessage,
        errMessage: errMessage ?? this.errMessage
    );
  }

  //Nhân bản đối tượng và cập nhật đối tượng
  RegisterState cloneAndUpdate({bool? isValidEmail, bool? isValidPassword}) {
    return cloneWith(
        isValidEmail: isValidEmail, isValidPassword: isValidPassword);
  }
}
