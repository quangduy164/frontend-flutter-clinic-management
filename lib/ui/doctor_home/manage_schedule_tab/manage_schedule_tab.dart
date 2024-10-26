import 'package:flutter/material.dart';

class ManageScheduleTab extends StatelessWidget{
  const ManageScheduleTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('This is ManageScheduleTab')
      ),
      body: Center(
        child: Text('This is ManageScheduleTab', style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}