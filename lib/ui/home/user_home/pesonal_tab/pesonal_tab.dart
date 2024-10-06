import 'package:clinic_management/data/blocs/authentication_bloc.dart';
import 'package:clinic_management/data/events/authentication_event.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PesonalTab extends StatelessWidget{
  const PesonalTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('This is PesonalTab'),
        actions: [
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              BlocProvider.of<AuthenticationBloc>(context).
              add(AuthenticationEventLoggedOut());
            },
          ),
        ],
      ),
      body: Center(
        child: Text('This is PesonalTab', style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}