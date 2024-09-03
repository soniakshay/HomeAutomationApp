import 'dart:async';
import 'dart:ffi';
//import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:test1/groupLightSettings.dart';
import 'package:test1/striplight.dart';
import 'package:test1/wifiswitch.dart';

import 'bluethooth.dart';
import 'groupLight.dart';
import 'home.dart';
import 'util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: ApiKey,
          appId: ApiId,
          messagingSenderId: messagingSenderId,
          projectId: projectId));
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Home',
      initialRoute: '/', // Specify the initial route
      routes: {
        '/': (context) => Home(), // HomeScreen is the initial route
        '/wifi':(context) => WifiSwitch(),
        '/bluetooth': (context) =>  BluethoothSwicth(),
        '/striplight': (context) =>  StripLight(),
        '/grouplight':(context) => GroupLight(),
        '/grouplightsettings': (context) => GroupLightSettings()
      },
    );
  }




}

