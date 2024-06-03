import 'dart:async';
import 'dart:ffi';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test1/bluethooth.dart';
import 'package:test1/drawer.dart';
import 'package:test1/striplight.dart';
import 'package:test1/wifiswitch.dart';
import 'add-light-dialog.dart';
import 'util.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      options: FirebaseOptions(
          apiKey: ApiKey,
          appId: ApiId,
          messagingSenderId: messagingSenderId,
          projectId: projectId));
  runApp(const GroupLightSettings());
}

class GroupLightSettings extends StatefulWidget {
  const GroupLightSettings({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _GroupLightSettingsState createState() => _GroupLightSettingsState();
}

class _GroupLightSettingsState extends State<GroupLightSettings> {
  final databaseReference = FirebaseDatabase.instance.reference();
  List<Map> lights = [];
  List<Map> lights1 = [];
  Map<dynamic,dynamic> rooms = {};
  @override
  void initState() {
    super.initState();
    fetchDataFromFirebase();


  }
  Future<void> fetchDataFromFirebase() async {

    try{
      EasyLoading.show(
          status: 'loading...'

      );
      DatabaseEvent snapshot = await databaseReference.child('LightGroups').once();
      dynamic value = snapshot.snapshot.value;

        setState(() {
          rooms= value;
        });
    }catch(e) {
      setState(() {
        rooms= {};
      });
    } finally {

      EasyLoading.dismiss();
    }

    

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

   

    
  }




  void showTostDialog(message) {
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
  List<bool> lightsState = List.generate(lightsCount, (index) => false);


  bool checkValueInArray(List<String> array, String value) {
    return array.contains(value);
  }


  void AddLightsDialog(room,lightValueArr) {
    List<bool> _selectedLights = List<bool>.generate(lightsCount, (index) => checkValueInArray(lightValueArr,'light${index + 1}'));

    Map<String, String> lightGroup = {
    };

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LightCheckboxDialog(
          initialLights: _selectedLights,
          onLightsSelected: (List<bool> selectedLights) {

            for (int i = 0; i < selectedLights.length; i++){
              if(selectedLights[i]) {
                setState(() {
                  lightGroup['light${i+1}'] = 'light${i+1}';
                });
              }
            }

            databaseReference.child('LightGroups').child(room).set(lightGroup).then((_) {
              showTostDialog("Add Room  Successfully");
              fetchDataFromFirebase();
            }).catchError((error) {
              print('Failed to add LightGroup: $error');
            });

            setState(() {
              _selectedLights = selectedLights;
            });
          },
        );
      },
    );
  }


  void RemoveRoom(room){
    try {
      databaseReference.child("LightGroups").child(room).remove();
      fetchDataFromFirebase();
      showTostDialog("Remove Room Successfully");
    }catch(e) {

    }


  }

  List<Widget> buildRowChildren() {
    List<Widget> row = [];
    if(rooms.length > 0) {
      rooms.forEach((room, lights) {
        List<Widget> col = [];
        List<String> lightValueArr = [];
        if (lights != null && lights is Map) {
          (lights as Map).forEach((lightKey, lightValue) {
            col.add(
              Padding(padding: EdgeInsets.fromLTRB(1,1,5,1),
                child: Chip(label: new Text(lightValue,style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color.fromRGBO(0, 0, 0, 1),

                ))),
              ),

            );
            lightValueArr.add(lightValue);
          });
        } else{
          col.add(
            Padding(padding: EdgeInsets.fromLTRB(1,1,5,1),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Wrap(
                    children: [
                      new Text("Currently, there are no lights available. Please add a light using the edit button.", textAlign: TextAlign.center)

                    ],
                  )

                ],
              )
            ),

          );
        }
        row.add(
            Padding(padding: EdgeInsets.all(10),
                child:
                Container(
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2), // color of shadow
                            spreadRadius: 1, // spread radius
                            blurRadius: 0, // blur radius
                            offset: Offset(0, 2), // changes position of shadow
                          ),
                        ],
                        borderRadius: BorderRadius.circular(8.0),
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xffffffff), //  First color
                            Color(0xffffffff), //r
                          ],
                        )),
                    child: new Container(
                        child:        new Column(
                          children: [
                            new Row(
                              children: [
                                Expanded(child:
                                new Container(
                                  decoration: BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(width: 2.0, color: Colors.white10),
                                    ),
                                  ),
                                  child:
                                  Padding(padding: EdgeInsets.all(20) ,
                                      child:  new Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [

                                          new Text(room,style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                            color: Color.fromRGBO(0, 0, 0, 1),

                                          ) ),

                                          new Row(
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.edit, size: 15),
                                                onPressed: () {
                                                  AddLightsDialog(room,lightValueArr);
                                                },
                                              ),
                                              IconButton(
                                                icon: Icon(Icons.delete, size: 15),
                                                onPressed: () {
                                                  RemoveRoom(room);
                                                },
                                              ),
                                            ],

                                          )

                                        ],
                                      )),

                                )
                                ),
                              ],
                            ),
                            Divider(
                              color: Colors.grey, // Change color as needed
                              thickness: 0.2, // Adjust thickness as needed
                              height: 20.0, // Adjust height as needed
                            ),
                            new Row(
                              children: [
                                Expanded(child: new Padding(padding: EdgeInsets.all(10),child:

                                new Container(
                                    child:Wrap(
                                      children: col,
                                    )
                                ),)
                                ),
                              ],
                            ),
                          ],
                        )

                    )
                ))
        );
      });

    }else {
      row.add(

          Padding(padding: EdgeInsets.fromLTRB(20, 50, 20, 20),child:
          Center(
            child: Wrap(
              children: [
                new Text("Currently, there are no available rooms. Please click on the plus icon to add one.",textAlign: TextAlign.center,style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 14,
                    color: Colors.black,

                )),

              ],
            ))
          )
      );
   
    }



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
                  const Text("Group Switch Settings",style: TextStyle(fontWeight: FontWeight.bold)),
                  IconButton(
                    icon: Icon(Icons.add, size: 19),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          String textFieldValue = ''; // Store the value of the TextField

                          return AlertDialog(
                            title: Text('Add Room'),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                TextField(
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                      borderSide: BorderSide(color: Colors.red), // Change color as needed
                                    ),
                                    hintText: 'Enter text',
                                  ),
                                  onChanged: (value) {
                                    textFieldValue = value; // Update the value of textFieldValue
                                  },
                                ),
                              ],
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  // Add your logic here
                                  Navigator.of(context).pop();
                                },
                                child: Text('Cancel',style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1))),
                              ),

                              ElevatedButton(
                                style:  ElevatedButton.styleFrom(
                                  shadowColor: Colors.transparent,
                                  backgroundColor: Colors.transparent,
                                  surfaceTintColor:Colors.transparent,
                                  padding: EdgeInsets.all(8),
                                  shape: RoundedRectangleBorder(
                                    // borderRadius: BorderRadius.circular(20.0), // Set border radius here
                                  ),
                                ),
                                onPressed: () {

                                  String myKey = textFieldValue;
                                  if(myKey != '') {

                                    DatabaseReference newChildReference = databaseReference.child('LightGroups').child(myKey);
                                    // Set value for the new child
                                    newChildReference.set('').then((value) {
                                      fetchDataFromFirebase();
                                      Navigator.of(context).pop();
                                    }).catchError(() {});
                                  } else {
                                    Navigator.of(context).pop();
                                  }


                                },
                                child: Text('Add',style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1))),
                              ),
                            ],
                          );
                        },
                      );




                    },
                  ),
                ],
              )
          ),
          body:Container(
            color: Color.fromRGBO(247, 248, 255, 1),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,

            child:           SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(1),


                child: Column(
                  children: buildRowChildren()),


              ),
            ),
          )





      ),
    );
  }




}

