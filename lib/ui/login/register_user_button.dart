import 'package:clinic_management/data/blocs/register_bloc.dart';
import 'package:clinic_management/data/repository/user_repository.dart';
import 'package:clinic_management/ui/register/register_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterUserButton extends StatelessWidget {
  final UserRepository _userRepository;

  RegisterUserButton({required UserRepository userRepository})
      : _userRepository = userRepository;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextButton(
          child: Text(
            'Register account',
            style: TextStyle(fontSize: 14, color: Colors.green),
          ),
          onPressed: (){
            Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context){
                      return BlocProvider<RegisterBloc>(
                        create: (context) => RegisterBloc(userRepository: _userRepository),
                        child: RegisterPage(),
                      );
                    }
                )
            );
          }
      ),
    );
  }
}