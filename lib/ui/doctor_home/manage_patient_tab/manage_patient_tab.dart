import 'package:flutter/material.dart';

class ManagePatientTab extends StatelessWidget{
  const ManagePatientTab({super.key});

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