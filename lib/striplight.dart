import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'util.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: ApiKey,
          appId: ApiId,
          messagingSenderId: messagingSenderId,
          projectId: projectId));
  runApp(const StripLight());
}

class StripLight extends StatefulWidget {
  const StripLight({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StripLightState createState() => _StripLightState();
}

class _StripLightState extends State<StripLight> {
  final databaseReference = FirebaseDatabase.instance.reference();
  Color pickerColor = Color.fromRGBO(96, 96, 96, 1);
  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();


  }
  Future<void> fetchDataFromFirebase() async {
    EasyLoading.show(
        status: 'loading...'

    );
    DatabaseEvent snapshot = await databaseReference.child('striplight').once();
    dynamic value = snapshot.snapshot.value;
    print("value");
    print(value);
   setState(() =>{
     pickerColor =   Color.fromARGB(
      value["opacity"],
       value["red"],
       value["green"],
       value["blue"],
     ),
   });
    EasyLoading.dismiss();
  }


  void showDialog(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }






  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }



  void resetColor() async {
    databaseReference.child('striplight').update( {'red': 96, 'green': 96 ,'blue': 96 ,'opacity':  255 }).then((value) => {
      showDialog("Success"),
      setState(() => pickerColor = Color.fromRGBO(96,96,96,1)),
      databaseReference.update({'isStripLightUpdated': true}).then((value) => {}),
      fetchDataFromFirebase(),
    }).onError((error, stackTrace) => {
      showDialog("Error In Update"),
    });
  }


  void sendColor() async {
    databaseReference.child('striplight').update( {'red': pickerColor.red, 'green': pickerColor.green, 'blue': pickerColor.blue ,'opacity': pickerColor.alpha }).then((value) => {
      showDialog("Success"),
      databaseReference.update({'isStripLightUpdated': true}).then((value) => {}),
      fetchDataFromFirebase(),
    }).onError((error, stackTrace) => {
      showDialog("Error In Update"),
    });
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Control Strip Light Color",style: TextStyle(color: Color(0xFFa5a6aa),fontWeight: FontWeight.bold),),
                ],
              )
          ),
          body:  SingleChildScrollView(
            child:   Padding(
              padding: const EdgeInsets.all(24),
              child:Expanded(
                child:              new Column(
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment:CrossAxisAlignment.center,
                        children: [




                          SlidePicker(
                            pickerColor:pickerColor,
                            onColorChanged: changeColor,
                            colorModel:ColorModel.rgb,
                            enableAlpha: true,
                            sliderSize: Size(250,60),
                            displayThumbColor: false,
                            showParams: true,
                            showIndicator: true,
                            indicatorBorderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
                          ),



                        ]
                    ),
                    Row(
                      children: [

                        Expanded(child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0), // Set border radius here
                              ),
                            ),
                            onPressed: () => {

                              resetColor()
                            }, child: new Text(
                            style: TextStyle(color: Color(0xFFa5a6aa)),
                            "Reset") )),
                        SizedBox(width: 20),
                        Expanded(child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.all(8),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0), // Set border radius here
                              ),
                            ),
                            onPressed: () => {

                              sendColor()
                            }, child: new Text(
                            style: TextStyle(color: Color(0xFFa5a6aa)),
                            "Send") )),


                      ],
                    )
                  ],
                )
              )

            )
          )


      ),
    );
  }




}

