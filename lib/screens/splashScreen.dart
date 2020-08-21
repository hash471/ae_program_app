import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(

      body : Container(
        child: Center(
          child: Container(
            width: 75,
            height: 75,
            child: CircularProgressIndicator(backgroundColor: Colors.amberAccent)))
      )
      
    );
  }
}