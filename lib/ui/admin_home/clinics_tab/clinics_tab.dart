import 'package:flutter/material.dart';

class ClinicsTab extends StatelessWidget{
  const ClinicsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('This is ClinicsTab')
      ),
      body: Center(
        child: Text('This is ClinicsTab', style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}