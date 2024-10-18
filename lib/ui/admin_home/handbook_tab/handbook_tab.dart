import 'package:flutter/material.dart';

class HandbookTab extends StatelessWidget{
  const HandbookTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('This is HandbookTab')
      ),
      body: Center(
        child: Text('This is HandbookTab', style: TextStyle(fontSize: 22),
        ),
      ),
    );
  }
}