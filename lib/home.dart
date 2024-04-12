import 'dart:async';
import 'dart:ffi';
//import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
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
  bool isShowStipLightSection =  false;
  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();
  }

  Future<void> fetchDataFromFirebase() async {
    EasyLoading.show(
        status: 'loading...'

    );
    DatabaseEvent snapshot = await databaseReference.child('isShowStipLightSection').once();
    dynamic value = snapshot.snapshot.value;
    if(value == true) {
      setState(() {
        isShowStipLightSection  =   value;
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
          brightness: Brightness.dark,
        ),

        // Define the default `TextTheme`. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          // ···

        ),
      ),
      home: Scaffold(
          appBar: AppBar(
              title: new Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text("Home",style: TextStyle(color: Color(0xFFa5a6aa),fontWeight: FontWeight.bold),),
                ],
              )
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                  children: [
                    new Row(
                      children: [
                        Expanded(child: ElevatedButton(


                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.all(8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                  20.0), // Set border radius here
                            ),
                          ),
                          onPressed: () =>
                          {

                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) =>
                                  BluethoothSwicth()),
                            )
                          },
                          child: new Column(
                            children: [
                              SizedBox(height: 15),
                              Column(
                                  children: [
                                    Image.asset('assets/bicon.png', width: 80,),

                                  ]),
                              SizedBox(height: 30),
                              Column(
                                  children: [
                                    Text('Bluethooth Control Switches',
                                      style: TextStyle(
                                          fontSize: 20,
                                          color: Color(0xFFa5a6aa)
                                      ),),

                                  ]),
                              SizedBox(height: 15),
                            ],
                          ),))
                      ],
                    ),
                    SizedBox(height: 30),
                    new Row(
                      children: [

                        Expanded(child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Set border radius here
                              ),
                            ),
                            onPressed: () =>
                            {

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    WifiSwitch()),
                              )
                            }, child: new Column(children: [

                          SizedBox(height: 15),
                          Column(
                              children: [
                                Image.asset('assets/wicon.png', width: 80,),

                              ]),
                          SizedBox(height: 30),
                          Column(children: [
                            Text('Wifi Control Swicthes', style: TextStyle(
                                fontSize: 20, // Set the font size here
                                color: Color(0xFFa5a6aa)
                            ),),

                          ]),
                          SizedBox(height: 15),
                        ],)))
                      ],
                    ),
                    SizedBox(height: 30),
                    isShowStipLightSection ? new Row(
                      children: [

                        Expanded(child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    20.0), // Set border radius here
                              ),
                            ),
                            onPressed: () =>
                            {

                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) =>
                                    StripLight()),
                              )
                            }, child: new Column(children: [

                          SizedBox(height: 15),
                          Column(
                              children: [
                                Image.asset('assets/wicon.png', width: 80,),

                              ]),
                          SizedBox(height: 30),
                          Column(children: [
                            Text('Strip light Color Control ', style: TextStyle(
                                fontSize: 20, // Set the font size here
                                color: Color(0xFFa5a6aa)
                            ),),

                          ]),
                          SizedBox(height: 15),
                        ],)))
                      ],
                    ) : new Text(""),


                  ]
              ),
            ),
          )

      ),
    );
  }


}

