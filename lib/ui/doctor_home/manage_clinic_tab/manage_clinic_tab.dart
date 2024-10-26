import 'package:flutter/material.dart';

class ManageClinicTab extends StatelessWidget{
  const ManageClinicTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('This is ManageClinicTab')
      ),
      body: Center(
        child: Text('This is ManageClinicTab', style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}