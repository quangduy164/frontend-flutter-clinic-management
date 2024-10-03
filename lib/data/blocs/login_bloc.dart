import 'package:clinic_management/data/events/login_event.dart';
import 'package:clinic_management/data/repository/user_repository.dart';
import 'package:clinic_management/data/states/login_state.dart';
import 'package:clinic_management/data/validators/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; //quản lý trạng thái tách xử lý logic và giao diện

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  //lắng nghe event để thay đổi state
  final UserRepository _userRepository;

  LoginBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(LoginState.initial()) {
    on<LoginEmailChanged>(_onEmailChanged);
    on<LoginPasswordChanged>(_onPasswordChanged);
    on<LogInEventWithGooglePressed>(_onLoginWithGoogle);
    on<LogInEventWithEmailAndPasswordPressed>(_onLoginWithEmailAndPassword);
  }

  // Xử lý sự kiện khi email thay đổi
  void _onEmailChanged(LoginEmailChanged event, Emitter<LoginState> emit) {
    final isValidEmail = Validators.isValidEmail(event.email);
    emit(state.cloneAndUpdate(
        isValidEmail:
            isValidEmail)); //Phát ra trạng thái mới dựa trên kết quả kiểm tra email hợp lệ hay k
  }

  // Xử lý sự kiện khi mật khẩu thay đổi
  void _onPasswordChanged(
      LoginPasswordChanged event, Emitter<LoginState> emit) {
    final isValidPassword = Validators.isValidPassword(event.password);
    emit(state.cloneAndUpdate(isValidPassword: isValidPassword));
  }

  // Xử lý sự kiện khi người dùng đăng nhập bằng Google
  Future<void> _onLoginWithGoogle(
      LogInEventWithGooglePressed event, Emitter<LoginState> emit) async {
    emit(LoginState
        .loading()); //Phát ra trạng thái "loading" để thông báo giao diện trong quá trình xử lý
    try {
      //await _userRepository.signInWithGoogle();
      emit(LoginState.success());
    } catch (error) {
      emit(LoginState.failure());
    }
  }

  // Xử lý sự kiện khi người dùng đăng nhập bằng Email và Mật khẩu
  Future<void> _onLoginWithEmailAndPassword(
      LogInEventWithEmailAndPasswordPressed event,
      Emitter<LoginState> emit) async {
    emit(LoginState.loading());
    try {
      await _userRepository.signInWithEmailAndPassword(
          event.email, event.password);
      emit(LoginState.success());
    } catch (error) {
      emit(LoginState.failure());
    }
  }
}
