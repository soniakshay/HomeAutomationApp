import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fluttertoast/fluttertoast.dart';
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
  runApp(const StripLight());
}

class StripLight extends StatefulWidget {
  const StripLight({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _StripLightState createState() => _StripLightState();
}

class DropdownItem {
  final String label;
  final String value;

  DropdownItem(this.label, this.value);
}
class _StripLightState extends State<StripLight> {
  final databaseReference = FirebaseDatabase.instance.reference();
  Color pickerColor = Color.fromRGBO(96, 96, 96, 1);
  String? _selectedValue;
  final List<DropdownItem> _items = [
    DropdownItem('Water Flow', 'waterflow'),
    DropdownItem('Shooting Star', 'shootingstar'),

  ];


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
      _selectedValue = value['effect'],
    });
    EasyLoading.dismiss();
  }



  void changeColor(Color color) {
    setState(() => pickerColor = color);
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




  void resetColor() async {
    databaseReference.child('striplight').update( {'red': 96, 'green': 96 ,'blue': 96 ,'opacity':  255, 'effect' : 'waterflow' }).then((value) => {
      showDialog("Success"),
      setState(() => {
        pickerColor = Color.fromRGBO(96,96,96,1),
        _selectedValue = 'waterflow',
      }),
      databaseReference.update({'isStripLightUpdated': true}).then((value) => {}),
      fetchDataFromFirebase(),
    }).onError((error, stackTrace) => {
      showDialog("Error In Update"),
    });
  }


  void sendColor() async {
    databaseReference.child('striplight').update( {'red': pickerColor.red, 'green': pickerColor.green, 'blue': pickerColor.blue ,'opacity': pickerColor.alpha, 'effect': _selectedValue }).then((value) => {
      showDialog("Success"),
      databaseReference.update({'isStripLightUpdated': true}).then((value) => {}),
      fetchDataFromFirebase(),
    }).onError((error, stackTrace) => {
      showDialog("Error In Update"),
    });
  }




  @override
  Widget build(BuildContext context) {


    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: EasyLoading.init(),

      home: Scaffold(

          drawer: SizedBox(
              width: MediaQuery.of(context).size.width * 0.3,
              child:
              Drawer(

                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF1576d5), // First color
                        Color(0xFF1989f7), // Gradient color
                      ],
                    ),
                  ),
                  child: new Column(
                    children: [
                      Padding(padding: EdgeInsets.fromLTRB(0, 50, 0, 0),child:
                      Image.asset('assets/logo.png',width: 50,),
                      ),
                      SizedBox(height: 50),

                      ElevatedButton(
                        onPressed: () {


                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => WifiSwitch()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          surfaceTintColor:Colors.transparent,
                          padding: EdgeInsets.all(8),

                          shape: RoundedRectangleBorder(
                            // borderRadius: BorderRadius.circular(20.0), // Set border radius here
                          ),
                        ),
                        child: new Column(
                          children: [
                            SizedBox(height: 10),
                            Image.asset('assets/wicon.png', width: 20,),
                            SizedBox(height: 10),
                            new Text("Wifi" ,style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1) ))
                          ],
                        ) ,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BluethoothSwicth()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          surfaceTintColor:Colors.transparent,
                          padding: EdgeInsets.all(8),

                          shape: RoundedRectangleBorder(
                            // borderRadius: BorderRadius.circular(20.0), // Set border radius here
                          ),
                        ),
                        child: new Column(
                          children: [
                            SizedBox(height: 10),
                            Image.asset('assets/bicon.png', width: 20),
                            SizedBox(height: 10),
                            new Text("Bluetooth",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)))
                          ],
                        ) ,
                      ),
                      SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => StripLight()),
                          );

                        },
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.transparent,
                          backgroundColor: Colors.transparent,
                          surfaceTintColor:Colors.transparent,
                          padding: EdgeInsets.all(8),

                          shape: RoundedRectangleBorder(
                            // borderRadius: BorderRadius.circular(20.0), // Set border radius here
                          ),
                        ),
                        child: new Column(
                          children: [
                            SizedBox(height: 10),
                            Image.asset('assets/wstrip-light.png', width: 20),
                            SizedBox(height: 10),
                            new Text("Strip Light",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)))
                          ],
                        ) ,
                      ),

                    ],
                  ),
                ),
              )),
          appBar: AppBar(
              title: new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Control Strip Light Color",style: TextStyle(fontWeight: FontWeight.bold),),
                ],
              )
          ),
          body: Container(
            color: Color.fromRGBO(247, 248, 255, 1),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: SingleChildScrollView(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [

              SizedBox(height: 30),
                
                  new Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          Text(style: TextStyle(fontSize: 18),"Effect"),
                          SizedBox(width: 20),
                          DropdownButton<String>(
                            value: _selectedValue,

                            hint: Text('Select an option'),
                            onChanged: (newValue) {
                              setState(() {
                                // Update the selected value when a new option is chosen
                                _selectedValue = newValue;
                              });
                              // Handle the change event here
                              print('Selected value: $_selectedValue');
                            },
                            items: _items.map<DropdownMenuItem<String>>((DropdownItem item) {
                              return DropdownMenuItem<String>(
                                value: item.value,
                                child: Text(item.label),
                              );
                            }).toList(),
                          )
                      ]

                    ),
                  ),

                  SizedBox(height: 30),

                SlidePicker(
                pickerColor:pickerColor,
                onColorChanged: changeColor,
                colorModel:ColorModel.rgb,
                enableAlpha: true,
                sliderSize: Size(250,60),
                displayThumbColor: true,
                showParams: true,
                showIndicator: true,
                indicatorBorderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
              ),




                  SizedBox(height: 30),




                  new Container(
                    alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width,
                    child: new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,

                        children: [
                          SizedBox(width: 20),
                          Expanded(child:
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                padding: EdgeInsets.all(8),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20.0), // Set border radius here
                                ),
                              ),
                              onPressed: () => {

                                resetColor()
                              }, child: new Text(
                              style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
                              "Reset") ),
                          ),

                          SizedBox(width: 20),
Expanded(child:   ElevatedButton(
    style: ElevatedButton.styleFrom(
      padding: EdgeInsets.all(8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0), // Set border radius here
      ),
    ),
    onPressed: () => {

      sendColor()
    }, child: new Text(
    style: TextStyle(color: Color.fromRGBO(0, 0, 0, 1)),
    "Send") ) ),
                          SizedBox(width: 20),

                        ]

                    ),
                  ),


                ],),
            )
          )




      ),
    );
  }




}

