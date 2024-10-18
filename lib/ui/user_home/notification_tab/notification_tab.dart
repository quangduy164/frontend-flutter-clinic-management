import 'package:flutter/material.dart';

class NotificationTab extends StatelessWidget{
  const NotificationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('This is NotificationTab')
      ),
      body: Center(
        child: Text('This is NotificationTab', style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}