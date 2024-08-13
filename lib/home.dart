import 'dart:async';
import 'dart:ffi';
//import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:test1/groupLight.dart';
import 'package:test1/striplight.dart';
import 'package:test1/wifiswitch.dart';
import 'bluethooth.dart';
import 'util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: ApiKey,
          appId: ApiId,
          messagingSenderId: messagingSenderId,
          projectId: projectId));
  runApp(const Home());
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final databaseReference = FirebaseDatabase.instance.reference();
  bool isShowStipLightSection = false;

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<void> fetchDataFromFirebase() async {
    EasyLoading.show(status: 'loading...');
    DatabaseEvent snapshot =
        await databaseReference.child('isShowStipLightSection').once();
    dynamic value = snapshot.snapshot.value;
    if (value == true) {
      setState(() {
        isShowStipLightSection = value;
      });
    }
    EasyLoading.dismiss();
  }

  @override
  Widget build(BuildContext context) {
    MaterialColor customColor = MaterialColor(
      0xFF292A2F, // Primary color value
      <int, Color>{
        50: Color(0xFFE0E0E1), // Shades for different opacities (50-900)
        100: Color(0xFFB3B3B6),
        200: Color(0xFF85878C),
        300: Color(0xFF57595F),
        400: Color(0xFF3A3C41),
        500: Color(0xFF292A2F),
        600: Color(0xFF242528),
        700: Color(0xFF1E1F23),
        800: Color(0xFF191A1E),
        900: Color(0xFF101113),
      },
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),
      theme: ThemeData(
        useMaterial3: true,

        // Define the default brightness and colors.
        colorScheme: ColorScheme.fromSeed(
          seedColor: customColor,
          // ···
          brightness: Brightness.light,
        ),

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        // textTheme: TextTheme(
        //   displayLarge: const TextStyle(
        //     fontSize: 72,
        //     fontWeight: FontWeight.bold,
        //   ),
        //   // ···
        //
        // ),
      ),
      home: Scaffold(
        body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/dbg.png"),
                      fit: BoxFit.fitHeight)),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  new Container(
                    child: new Column(
                      children: [
                        Image.asset('assets/logo.png', width: 90),
                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.3),
                  new Container(
                    width: MediaQuery.of(context).size.width * 0.8,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          // Color of the shadow
                          spreadRadius: 5,
                          // Spread radius
                          blurRadius: 7,
                          // Blur radius
                          offset: Offset(0, 3), // Offset in x and y directions
                        ),
                      ],
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xffffffff), // First color
                          Color(0xffffffff), // Gradient color
                        ],
                      ),
                    ),
                    child: new Padding(
                        padding: EdgeInsets.all(10),
                        child: new Column(
                          children: [
                            new Row(
                              children: [
                                Expanded(
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shadowColor: Colors.transparent,
                                          backgroundColor: Colors.transparent,
                                          surfaceTintColor: Colors.transparent,
                                          padding: EdgeInsets.all(8),
                                          shape: RoundedRectangleBorder(
                                              // borderRadius: BorderRadius.circular(20.0), // Set border radius here
                                              ),
                                        ),
                                        onPressed: () => {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        WifiSwitch()),
                                              )
                                            },
                                        child: new Column(
                                          children: [
                                            Image.asset('assets/wifiicon.png',
                                                width: 30),
                                            SizedBox(height: 10),
                                            new Text("Wifi",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ))
                                          ],
                                        ))),
                                Expanded(
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          shadowColor: Colors.transparent,
                                          backgroundColor: Colors.transparent,
                                          surfaceTintColor: Colors.transparent,
                                          padding: EdgeInsets.all(8),
                                          shape: RoundedRectangleBorder(
                                              // borderRadius: BorderRadius.circular(20.0), // Set border radius here
                                              ),
                                        ),
                                        onPressed: () => {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        BluethoothSwicth()),
                                              )
                                            },
                                        child: new Column(
                                          children: [
                                            Image.asset(
                                                'assets/bluetoothicon.png',
                                                width: 30),
                                            SizedBox(height: 10),
                                            new Text("Bluethooth",
                                                style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                ))
                                          ],
                                        )))
                              ],
                            ),
                            new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shadowColor: Colors.transparent,
                                        backgroundColor: Colors.transparent,
                                        surfaceTintColor: Colors.transparent,
                                        padding: EdgeInsets.all(8),
                                        shape: RoundedRectangleBorder(

                                            // borderRadius: BorderRadius.circular(20.0), // Set border radius here
                                            ),
                                      ),
                                      onPressed: () => {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      StripLight()),
                                            )
                                          },
                                      child: new Column(
                                        children: [
                                          Image.asset(
                                              'assets/striplighticon.png',
                                              width: 30),
                                          SizedBox(height: 10),
                                          new Text("Strip Light",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ))
                                        ],
                                      )),
                                ),
                                Expanded(
                                  child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shadowColor: Colors.transparent,
                                        backgroundColor: Colors.transparent,
                                        surfaceTintColor: Colors.transparent,
                                        padding: EdgeInsets.all(8),
                                        shape: RoundedRectangleBorder(

                                            // borderRadius: BorderRadius.circular(20.0), // Set border radius here
                                            ),
                                      ),
                                      onPressed: () => {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      GroupLight()),
                                            )
                                          },
                                      child: new Column(
                                        children: [
                                          Image.asset('assets/grouplight.png',
                                              width: 30),
                                          SizedBox(height: 10),
                                          new Text("Group Light",
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                              ))
                                        ],
                                      )),
                                )
                              ],
                            )
                          ],
                        )),
                  )
                ],
              )),
        ),
      ),
    );
  }
}
