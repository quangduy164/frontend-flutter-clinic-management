import 'package:clinic_management/data/blocs/register_bloc.dart';
import 'package:clinic_management/data/events/register_event.dart';
import 'package:clinic_management/data/repository/user_repository.dart';
import 'package:clinic_management/data/states/register_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class RegisterPage extends StatefulWidget {
  final UserRepository _userRepository;

  RegisterPage({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>{
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  String? _selectedGender; //biến chọn giới tính
  late RegisterBloc _registerBloc;

  final UserRepository _userRepository = UserRepository();

  @override
  void initState() {
    super.initState();
    _registerBloc = BlocProvider.of<RegisterBloc>(context);
    //Khi thay đổi email hàm  này đc gọi
    _emailController.addListener((){
      _registerBloc.add(RegisterEmailChanged(email: _emailController.text));
    });
    _passwordController.addListener((){
      _registerBloc.add(RegisterPasswordChanged(password: _passwordController.text));
    });
  }

//Kiểm tra email và mật khẩu không trống
  bool get isPopulated => _emailController.text.isNotEmpty && _passwordController.text.isNotEmpty;
  bool isRegisterButtonEnabled(RegisterState registerState){
    return registerState.isValidEmailAndPassword && isPopulated && !registerState.isSubmitting;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Register'),
          actions: [
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
        body: BlocBuilder<RegisterBloc, RegisterState>(
          builder: (context, registerState){
            if(registerState.isFailure && registerState.errMessage != null){
              Navigator.of(context).pop();
              //Scheduler đảm bảo xây dựng xong ui mới hiện scaffoldMessage
              SchedulerBinding.instance.addPostFrameCallback((_) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Lỗi: ${registerState.errMessage}')),
                );
              });
              print('Register failed');
            }
            else if(registerState.isSubmitting){
              print('Register in progress');
            }
            else if(registerState.isSuccess){
              SchedulerBinding.instance.addPostFrameCallback((_){
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${registerState.successMessage}')),
                );
              });
            }
            return Padding(
              padding: EdgeInsets.all(20),
              child: Form(
                  child: ListView(
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.email),
                            labelText: 'Email'
                        ),
                        keyboardType: TextInputType.emailAddress,
                        autovalidateMode: AutovalidateMode.always,
                        autocorrect: false,
                        validator: (_){
                          return registerState.isValidEmail ? null : 'Invalid email format';
                        },
                      ),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.lock),
                            labelText: 'Password'
                        ),
                        obscureText: true,
                        autovalidateMode: AutovalidateMode.always,
                        autocorrect: false,
                        validator: (_){
                          return registerState.isValidPassword ? null : 'Invalid password format';
                        },
                      ),
                      TextFormField(
                        controller: _firstNameController,
                        decoration: InputDecoration(
                            icon: Icon(Icons.drive_file_rename_outline),
                            labelText: 'First Name'
                        ),
                        autocorrect: false,
                      ),
                      DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          icon: Icon(Icons.person),
                          labelText: 'Gender',
                        ),
                        value: _selectedGender,
                        items: [
                          DropdownMenuItem(
                            value: 'M',
                            child: Text('Male'),
                          ),
                          DropdownMenuItem(
                            value: 'F',
                            child: Text('Female'),
                          ),
                          DropdownMenuItem(
                            value: 'O',
                            child: Text('Other'),
                          ),
                        ],
                        onChanged: (value) {
                          setState(() {
                            _selectedGender = value; // Cập nhật giới tính được chọn
                          });
                        },
                        validator: (value) {
                          return value == null ? 'Please select a gender' : null;
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: SizedBox(
                          height: 45,
                          child: ElevatedButton(
                              child: Text(
                                'Register',
                                style: TextStyle(fontSize: 16, color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: BeveledRectangleBorder(
                                  borderRadius: BorderRadius.circular(13),
                                ),
                              ),
                              onPressed: (){
                                isRegisterButtonEnabled(registerState) ?
                                _onRegisterEmailAndPassword() : null;
                              }
                          ),
                        )
                      )
                    ],
                  )
              ),
            );
          },
        ),
      ),
    );
  }

  void _onRegisterEmailAndPassword() {
    _registerBloc.add(RegisterEventWithEmailAndPasswordPressed(
        email: _emailController.text,
        password: _passwordController.text,
        firstName: _firstNameController.text,
        gender: _selectedGender.toString()
    ));

  }
}