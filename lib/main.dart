
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:vendorpro/layout/splashscreen.dart';
import 'package:vendorpro/modules/homescreen/homescreen.dart';
import 'package:vendorpro/shared/network/local/widget/images_picker.dart';

import 'modules/registerscreens/registerscreen.dart';
import 'shared/network/remote/providers/authprovider.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Provider.debugCheckInvalidValueType = null;

  await Firebase.initializeApp();
  runApp(MultiProvider(
    providers:[
      Provider (create: (_) => AuthProvider()),

    ],
  child: MyApp(),
  ),
  );




}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      debugShowCheckedModeBanner: false,
      theme:ThemeData(
        primaryColor: Colors.lightBlue,
        fontFamily: 'Lato',
      ),
      initialRoute: SplashScreen.id,
      routes: {
        SplashScreen.id:(context)=>SplashScreen(),
        RegisterScreen.id:(context)=>RegisterScreen(),
        HomeScreen.id:(context)=>HomeScreen(),
        SopePicCard.id:(context)=>SopePicCard(),

      },

    );
  }
}


