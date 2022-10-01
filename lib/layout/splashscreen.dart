


import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:vendorpro/modules/homescreen/homescreen.dart';
import 'package:vendorpro/modules/registerscreens/registerscreen.dart';


class SplashScreen extends StatefulWidget {
  static const String id='splash-screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(Duration(seconds: 3,
    ),(){
      FirebaseAuth.instance.authStateChanges().listen((User? user) async {
        if(user==null){

          Navigator.pushReplacementNamed(context,RegisterScreen.id);
        }else{
          Navigator.pushReplacementNamed(context, HomeScreen.id);
        }
      });

    });

  }

  @override

  Widget build(BuildContext context) {
    return Scaffold(
      
      body:
      Center(
        child: Container(decoration:  BoxDecoration(
            color: Colors.grey[200]
        ),
          child: Center(
            child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image(image:AssetImage('assets/images/OIP.jpg'),
                  height: 250,
                  width: 250,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
