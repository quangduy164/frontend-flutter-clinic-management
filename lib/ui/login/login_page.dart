import 'package:clinic_management/data/blocs/authentication_bloc.dart';
import 'package:clinic_management/data/blocs/login_bloc.dart';
import 'package:clinic_management/data/events/authentication_event.dart';
import 'package:clinic_management/data/events/login_event.dart';
import 'package:clinic_management/data/repository/user_repository.dart';
import 'package:clinic_management/data/states/login_state.dart';
import 'package:clinic_management/ui/login/login_button.dart';
import 'package:clinic_management/ui/login/register_user_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LoginPage extends StatefulWidget {
  final UserRepository _userRepository;

  LoginPage({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late LoginBloc _loginBloc;
  late bool _obscurePassword; //biến theo dõi trạng thái hiển thị mật khẩu

  UserRepository get _userRepository => widget._userRepository;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loginBloc = BlocProvider.of<LoginBloc>(context);
    //Khi thay đổi email hàm này đc gọi
    _emailController.addListener(() {
      _loginBloc.add(LoginEmailChanged(email: _emailController.text));
    });
    _passwordController.addListener(() {
      _loginBloc.add(LoginPasswordChanged(password: _passwordController.text));
    });
    _obscurePassword = true;
  }

  //Kiểm tra email và mật khẩu không trống
  bool get isPopulated =>
      _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;

  bool isLoginButtonEnabled(LoginState loginState) {
    return loginState.isValidEmailAndPassword &&
        isPopulated &&
        !loginState.isSubmitting;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Clinic Management', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          backgroundColor: Colors.lightBlueAccent,
          systemOverlayStyle: SystemUiOverlayStyle.light,
        ),
        body: BlocBuilder<LoginBloc, LoginState>(
          builder: (context, loginState) {
            if (loginState.isFailure) {
              print('Login failed');
            } else if (loginState.isSubmitting) {
              print('Login in');
            } else if (loginState.isSuccess) {
              //thêm event authenticationEventLogin
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationEventLoggedIn());
            }
            return Stack(
              children: [
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Form(
                      child: ListView(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.email),
                            labelText: 'Enter your email'),
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.always,
                        autocorrect: false,
                        validator: (_) {
                          return loginState.isValidEmail
                              ? null
                              : 'Invalid email format';
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.lock), labelText: 'Enter password',
                            suffixIcon: IconButton(
                              icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility,
                                color: Colors.black,),
                              onPressed: (){
                                setState(() {
                                  _obscurePassword = !_obscurePassword;
                                });
                              },
                            )),
                        obscureText: _obscurePassword,//che mật khẩu
                        autovalidateMode: AutovalidateMode.always,//tự động validate password mà k cần gọi
                        autocorrect: false,//tắt tự sửa lỗi của hệ thống
                        validator: (_) {
                          return loginState.isValidPassword
                              ? null
                              : 'Invalid password format';
                        },
                      ),
                      SizedBox(height: 10),
                      // Hiển thị thông báo lỗi nếu đăng nhập thất bại
                      loginState.isFailure
                          ? Text(
                        '          Email or pasword invalid',
                        style: TextStyle(
                            color: Colors.red, fontSize: 14,),
                        textAlign: TextAlign.left,
                      )
                          : Container(),
                      // Nếu không có lỗi thì không hiển thị gì
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            LoginButton(
                              onPressed: isLoginButtonEnabled(loginState)
                                  ? _onLoginEmailAndPassword : null,
                            ),
                            const Padding(padding: EdgeInsets.only(top: 20)),
                            const Divider(height: 1, color: Colors.grey),
                            Row(
                              children: [
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: TextButton(
                                      child: const Text('Forgot your password?',
                                        style: TextStyle(fontSize: 14, color: Colors.black),
                                        textAlign: TextAlign.left,
                                      ),
                                      onPressed: (){}
                                  ),
                                ),
                                //Thêm nút để đăng kí tài khoản
                                const Spacer(),
                                RegisterUserButton(userRepository: _userRepository)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  void _onLoginEmailAndPassword() {
    _loginBloc.add(LogInEventWithEmailAndPasswordPressed(
        email: _emailController.text, password: _passwordController.text));
  }
}
