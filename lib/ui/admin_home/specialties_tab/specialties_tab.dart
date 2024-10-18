import 'package:flutter/material.dart';

class SpecialtiesTab extends StatelessWidget{
  const SpecialtiesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('This is SpecialtiesTab')
      ),
      body: Center(
        child: Text('This is SpecialtiesTab', style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}