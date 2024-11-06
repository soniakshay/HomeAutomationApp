import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test1/bluethooth.dart';
import 'package:test1/groupLightSettings.dart';
import 'package:test1/striplight.dart';
import 'package:test1/wifiswitch.dart';
import 'drawer.dart';
import 'util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: ApiKey,
          appId: ApiId,
          messagingSenderId: messagingSenderId,
          projectId: projectId));
  runApp(const GroupLight());
}

class GroupLight extends StatefulWidget {
  const GroupLight({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GroupLightState createState() => _GroupLightState();
}

class _GroupLightState extends State<GroupLight> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List<Map> lights = [];
  List<Map> lights1 = [];

  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();


  }
  Future<void> fetchDataFromFirebase() async {
    EasyLoading.show(
        status: 'loading...'

    );

    databaseReference.child('lights').onValue.listen((snapshot) {
      lights.clear();
      dynamic value = snapshot.snapshot.value;
      Map<dynamic, dynamic> lightsMap = value ;
      lights.clear();
      for(int i =1;i<=lightsCount; i++) {
        setState(() {
          Map<String, dynamic> lightsObject = {
            'light${i}': lightsMap['light${i}'],
            // Add more lights as needed
          };
          lights.add(lightsObject);
        });
      }
    });

    databaseReference.child('LightGroups').onValue.listen((snapshot) {



      if (snapshot.snapshot.value != null) {
        dynamic value = snapshot.snapshot.value;
        Map<dynamic, dynamic> rooms = value;
        lights1.clear();
        rooms.forEach((room, lights) {
          if (lights != '') {
            List <String> arrayOfObjects = [];
            lights.forEach((lightKey, lightValue) {
              arrayOfObjects.add(lightValue);
            });
            setState(() {
              lights1.add({
                room: arrayOfObjects
              });
            });
          }
        });
      }
    });




    EasyLoading.dismiss();
  }
  Widget buildButton(String title) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            // Add your button onPressed logic here
          },
          child: Text(title),
        ),
      ),
    );
  }
  void onPress(values, isLightOn) async {

     DatabaseEvent snapshot = await databaseReference.child('lights').once();
    // // Retrieve data
     if(!isLightOn){
       Map<String, String> object = {};

       for (var key in values) {
         object[key] = 'ON'; // Set the value to 'ON'
       }
       databaseReference.child('lights').update(object).then((value) => {
         showDialog("Success"),
         databaseReference.update({'isUpdated': true}).then((value) => {}),
         // fetchDataFromFirebase(),
       }).onError((error, stackTrace) => {
         showDialog("Error In Update"),
       });

     } else {
       Map<String, String> object1 = {};

       for (var key in values) {
         object1[key] = 'OFF'; // Set the value to 'ON'
       }
       databaseReference.child('lights').update(object1).then((value) => {
         showDialog("Success"),
         databaseReference.update({'isUpdated': true}).then((value) => {}),
         // fetchDataFromFirebase(),
       }).onError((error, stackTrace) => {
         showDialog("Error In Update"),
       });


     }
    // if(value['light${index}'] == 'OFF') {
    //   databaseReference.child('lights').update( {'light${index}': 'ON'}).then((value) => {
    //     showDialog("Success"),
    //     databaseReference.update({'isUpdated': true}).then((value) => {}),
    //     fetchDataFromFirebase(),
    //   }).onError((error, stackTrace) => {
    //     showDialog("Error In Update"),
    //   });
    // } else {
    //   databaseReference.child('lights').update( {'light${index}': 'OFF'}).then((value) => {
    //     showDialog("Success"),
    //     databaseReference.update({'isUpdated': true}).then((value) => {}),
    //     fetchDataFromFirebase(),
    //   }).onError((error, stackTrace) => {
    //     showDialog("Error In Update"),
    //   });
    // };
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

  bool areLightsOn(List<Map<dynamic, dynamic>> lights, List<String> keysToCheck) {
    for (var lightKey in keysToCheck) {
      bool lightIsOn = false;
      for (var light in lights) {
        if (light.containsKey(lightKey) && light[lightKey] == 'ON') {
          lightIsOn = true;
          break;
        }
      }
      if (!lightIsOn) {
        return false;
      }
    }
    return true;
  }

  List<Widget> buildRowChildren() {
    List<Widget> row = [];
    List<Widget> col = [];
    if(lights1.isNotEmpty){


        for (int i = 0; i < (lights1.length/2).ceil(); i++) {
          col = [];
          for (int j = 0; j < 2; j++) {
              int index =  (i*2+j+1) - 1;
              if(lights1.length >  index) {
                print(index);
                 Map roomMap =  lights1[index];
                 String roomKey = roomMap.keys.first;
                 dynamic roomValues = roomMap.values.first;

                bool isLightON  =  areLightsOn(lights, roomValues);
                 String lightOnOffText =  isLightON ?  "ON": "OFF";

                Color textColor = isLightON ?   Color.fromRGBO(255, 255, 255, 1): Color.fromRGBO(0, 0, 0, 1);
                dynamic btnColor = isLightON ?  [
                  Color(0xFF1576d5), // First color
                  Color(0xFF1989f7), // Second color
                ]:  [
                  Color(0xffffffff), //  First color
                  Color(0xffffffff), //
                ];
                String imageUrl = isLightON ? 'assets/nlighton.png' : 'assets/nlightoff.png';;
                col.add(
                    Expanded(child: Padding(
                      padding: EdgeInsets.all(1.0),
                      child: ElevatedButton(

                          style: ElevatedButton.styleFrom(
                            shadowColor: Colors.transparent,
                            backgroundColor: Colors.transparent,
                            surfaceTintColor:Colors.transparent,
                            padding: EdgeInsets.all(8),

                            shape: RoundedRectangleBorder(
                              // borderRadius: BorderRadius.circular(20.0), // Set border radius here
                            ),
                          ),


                          onPressed: () => {
                            onPress(roomValues,isLightON)

                          }, child: Ink(
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.1), // color of shadow
                              spreadRadius: 1, // spread radius
                              blurRadius: 0, // blur radius
                              offset: Offset(0, 2), // changes position of shadow
                            ),
                          ],
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: btnColor,
                          ),
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                        child: Container(


                            child:

                            new Column(children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [

                                  new Column(children: [
                                    new Row(
                                      children: [

                                        Padding(padding: EdgeInsets.fromLTRB(11, 12, 0, 0) , child:   new Text("Switch",style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                            color: textColor

                                        ) )),

                                        Padding(padding: EdgeInsets.fromLTRB(11, 12, 0, 0) , child:   new Text(lightOnOffText,style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            fontSize: 15,
                                            color: textColor

                                        ) )),

                                      ],
                                    )





                                  ],
                                  )
                                ],),
                              Row(
                                mainAxisAlignment: lights1.length !=  index+1 && lights1.length % 2 == 0    ?  MainAxisAlignment.start : MainAxisAlignment.center,

                                children: [

                                  new Column(children: [
                                    Padding(padding: EdgeInsets.fromLTRB(15, 20, 20, 10) , child:     Image.asset(imageUrl, width: 50,))




                                  ],
                                  )
                                ],),
                              SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: lights1.length !=  (index+1)  && lights1.length % 2 == 0     ?  MainAxisAlignment.start : MainAxisAlignment.center,

                                children: [
                                  new Column(


                                    children: [

                                    Padding(
                                      padding: EdgeInsets.all(8),
                                      child:  new Column(

                                        children: [
                                        Padding(padding: EdgeInsets.fromLTRB(5,0,10,5),child:

                                        new Column(


                                          children: [

                                          new Text('${roomKey}',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 16,
                                                  color:textColor

                                              )),
                                          // SizedBox(width: 12),
                                          // new Text('ON',
                                          //     style: TextStyle(
                                          //         fontWeight: FontWeight.bold,
                                          //         fontSize: 16,
                                          //          color: textColor
                                          //
                                          //     )),
                                        ],)
                                        ),




                                      ],) ,
                                    ),

                                  ],)

                                ],)


                            ],)


                        ),
                      )),
                    ))

                );
              }


          }
          row.add(new Row(children: col));
        }
    } else {
      col.add(
        Padding(padding: EdgeInsets.fromLTRB(1,1,5,1),
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Wrap(
                  children: [
                    new Text("Currently, there are no lights available."
                        " Please add a light using the edit button.", textAlign: TextAlign.center)

                  ],
                )

              ],
            )
        ),

      );
    }


    row.add(new Column(children: col));
    return row;
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

        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          // ···

        ),
      ),
      home: Scaffold(
          drawer: AppDrawer(),
          appBar: AppBar(

              backgroundColor:Color.fromRGBO(247, 248, 255, 1),
              title: new Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Group Switch",style: TextStyle(fontWeight: FontWeight.bold),),

                  IconButton(
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.black,
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => GroupLightSettings()),
                        );

                      })
                ],
              )
          ),
          body:Container(
            color: Color.fromRGBO(247, 248, 255, 1),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,

            child:           SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child:
                Column(
                  children: buildRowChildren()
                ),
              ),
            ),
          )





      ),
    );
  }




}

