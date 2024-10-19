import 'package:clinic_management/data/blocs/authentication_bloc.dart';
import 'package:clinic_management/data/blocs/login_bloc.dart';
import 'package:clinic_management/data/blocs/simple_bloc_observer.dart';
import 'package:clinic_management/data/events/authentication_event.dart';
import 'package:clinic_management/data/repository/user_repository.dart';
import 'package:clinic_management/data/states/authentication_state.dart';
import 'package:clinic_management/ui/login/login_page.dart';
import 'package:clinic_management/ui/splash/splash_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'ui/admin_home/admin_home_page.dart';
import 'ui/user_home/user_home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();//đảm bảo flutter khởi động đúng cách
  Bloc.observer = SimpleBlocObserver();//theo dõi các sự kiện
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserRepository _userRepository = UserRepository();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music App',
      theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.lightBlueAccent),
          useMaterial3: true),
      home: BlocProvider(//cung cấp authenticationbloc cho các widget con
        create: (context) {
          final authenticationBloc =
              AuthenticationBloc(userRepository: _userRepository);
          //phát ra event start để kiểm tra trạng thái đăng nhập người dùng
          authenticationBloc.add(AuthenticationEventStarted());
          return authenticationBloc;
        },
        //blocbuilder lắng nghe thay đổi về state để xây dựng ui
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, authenticationState) {
            if (authenticationState is AuthenticationStateSuccess) {
              if (authenticationState.role == '1') {
                return AdminHomePage(firstName: authenticationState.firstName,); // Trang chính cho Admin
              } else {
                return UserHomePage(
                  email: authenticationState.email,
                  firstName: authenticationState.firstName,); // Trang chính cho User
              }
            } else if (authenticationState is AuthenticationStateFailure) {
              return BlocProvider(
                create: (context) => LoginBloc(userRepository: _userRepository),
                child: LoginPage(
                  userRepository: _userRepository,
                ),
              );
            }
            return SplashPage();
          },
        ),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
