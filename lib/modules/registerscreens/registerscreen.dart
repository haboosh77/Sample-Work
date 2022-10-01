

import 'package:flutter/material.dart';
import 'package:vendorpro/modules/registerscreens/registreform.dart';
import 'package:vendorpro/shared/network/local/widget/images_picker.dart';

class RegisterScreen extends StatelessWidget {
  static const String id='register-screen';


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  SopePicCard(),
                  RegisterForm(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
