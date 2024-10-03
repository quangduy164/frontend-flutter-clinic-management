import 'package:clinic_management/data/blocs/authentication_bloc.dart';
import 'package:clinic_management/data/events/authentication_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context)
                  .add(AuthenticationEventLoggedOut());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Welcome, Admin!', style: TextStyle(fontSize: 22)),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
