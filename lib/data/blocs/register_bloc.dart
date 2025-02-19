import 'package:clinic_management/data/events/register_event.dart';
import 'package:clinic_management/data/repository/user_repository.dart';
import 'package:clinic_management/data/states/register_state.dart';
import 'package:clinic_management/data/validators/validators.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final UserRepository _userRepository;

  RegisterBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(RegisterState.initial()) {
    on<RegisterEmailChanged>(_onEmailChanged);
    on<RegisterPasswordChanged>(_onPasswordChanged);
    on<RegisterEventWithGoogleChanged>(_onRegisterWithGoogle);
    on<RegisterEventWithEmailAndPasswordPressed>(
        _onRegisterWithEmailAndPassword);
  }

  // Xử lý sự kiện khi email thay đổi
  void _onEmailChanged(
      RegisterEmailChanged event, Emitter<RegisterState> emit) {
    final isValidEmail = Validators.isValidEmail(event.email);
    emit(state.cloneAndUpdate(isValidEmail: isValidEmail));
  }

  // Xử lý sự kiện khi mật khẩu thay đổi
  void _onPasswordChanged(
      RegisterPasswordChanged event, Emitter<RegisterState> emit) {
    final isValidPassword = Validators.isValidPassword(event.password);
    emit(state.cloneAndUpdate(isValidPassword: isValidPassword));
  }

  // Xử lý sự kiện khi người dùng đăng ký bằng Google
  Future<void> _onRegisterWithGoogle(
      RegisterEventWithGoogleChanged event, Emitter<RegisterState> emit) async {
    emit(RegisterState.loading());
    try {
      //await _userRepository.signInWithGoogle();
      //emit(RegisterState.success());
    } catch (error) {
      emit(RegisterState.failure(error.toString()));
    }
  }

  // Xử lý sự kiện khi người dùng đăng ký bằng Email và Mật khẩu
  Future<void> _onRegisterWithEmailAndPassword(
      RegisterEventWithEmailAndPasswordPressed event,
      Emitter<RegisterState> emit) async {
    emit(RegisterState.loading());
    try {
      final result = await _userRepository.createUserWithEmailAndPassword(
          event.email, event.password, event.firstName, event.gender);
      if(result['success']){
        emit(RegisterState.success(result['message']));
      }
    } catch (error) {
      emit(RegisterState.failure(error.toString()));
    }
  }
}
