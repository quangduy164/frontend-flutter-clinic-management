import 'package:flutter/material.dart';

class HomeTab extends StatelessWidget{
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('This is HomeTab')
      ),
      body: Center(
        child: Text('This is HomeTab', style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}