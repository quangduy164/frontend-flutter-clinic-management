import 'package:flutter/material.dart';

class ScheduleTab extends StatelessWidget{
  const ScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('This is ScheduleTab')
      ),
      body: Center(
        child: Text('This is ScheduleTab', style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}