import 'package:flutter/material.dart';

class SplashPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
            children: [
              Center(
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: Image.asset(
                    'assets/images/splash.png',
                    fit: BoxFit.cover, width: double.infinity, height: double.infinity,
                  ),
                ),
              ),
            ],
          )
      ),
    );
  }

}