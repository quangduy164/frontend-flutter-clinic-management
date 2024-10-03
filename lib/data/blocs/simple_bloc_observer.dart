import 'package:flutter_bloc/flutter_bloc.dart';

//Xem lịch sử bloc cho phép quan sát và can thiệp các sự kiện trong chu trình bloc
class SimpleBlocObserver extends BlocObserver{
  @override
  void onEvent(Bloc bloc, Object? event) {//được gọi khi event gửi đến bloc
    // TODO: implement onEvent
    super.onEvent(bloc, event);
  }
  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {//được gọi khi lỗi xảy ra
    // TODO: implement onError
    super.onError(bloc, error, stackTrace);
  }
  @override
  void onTransition(Bloc bloc, Transition transition) {//được gọi khi chuyển state
    // TODO: implement onTransition
    super.onTransition(bloc, transition);
  }
}