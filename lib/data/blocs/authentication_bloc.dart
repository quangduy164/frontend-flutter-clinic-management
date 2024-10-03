import 'package:clinic_management/data/events/authentication_event.dart';
import 'package:clinic_management/data/repository/user_repository.dart';
import 'package:clinic_management/data/states/authentication_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AuthenticationBloc extends Bloc<AuthenticationEvent, AuthenticationState> {
  final UserRepository _userRepository;

  AuthenticationBloc({required UserRepository userRepository})
      : _userRepository = userRepository,
        super(AuthenticationStateInitial()) {
    on<AuthenticationEventStarted>(_onAuthenticationStarted);
    on<AuthenticationEventLoggedIn>(_onAuthenticationLoggedIn);
    on<AuthenticationEventLoggedOut>(_onAuthenticationLoggedOut);
  }

  // Xử lý sự kiện khi ứng dụng khởi động
  Future<void> _onAuthenticationStarted(AuthenticationEventStarted event,
      Emitter<AuthenticationState> emit) async {
    final accessToken = await _userRepository.getAccessToken();

    if (accessToken != null) {
      // Kiểm tra token hợp lệ qua API Express
      final userData = await _userRepository.getUserFromToken(accessToken);
      if (userData != null) {
        emit(AuthenticationStateSuccess(email: userData['email'], role: userData['roleId']));
      } else {
        emit(AuthenticationStateFailure());
      }
    } else {
      emit(AuthenticationStateFailure());
    }
  }

  // Xử lý sự kiện khi người dùng đăng nhập thành công
  Future<void> _onAuthenticationLoggedIn(AuthenticationEventLoggedIn event,
      Emitter<AuthenticationState> emit) async {
    final accessToken = await _userRepository.getAccessToken();
    if (accessToken != null) {
      final userData = await _userRepository.getUserFromToken(accessToken);
      emit(AuthenticationStateSuccess(email: userData?['email'], role: userData?['roleId']));
    } else {
      emit(AuthenticationStateFailure());
    }
  }

  // Xử lý sự kiện khi người dùng đăng xuất
  Future<void> _onAuthenticationLoggedOut(AuthenticationEventLoggedOut event,
      Emitter<AuthenticationState> emit) async {
    await _userRepository.signOut();
    emit(AuthenticationStateFailure());
  }
}
