import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:typed_data';
//import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';

import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:test1/striplight.dart';
import 'package:test1/wifiswitch.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BluethoothSwicth());
}

class BluethoothSwicth extends StatefulWidget {
  const BluethoothSwicth({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _BluethoothSwicthState createState() => _BluethoothSwicthState();
}

class _BluethoothSwicthState extends State<BluethoothSwicth> {
  late BluetoothConnection connection;
  final FlutterBluetoothSerial flutterBluetoothSerial = FlutterBluetoothSerial.instance;
  bool connectionState = false;
  Map<int, String> buttonState = {
    for (int i = 1; i <= 16; i++) i: 'OFF',
  };

  @override
  void initState() {
    super.initState();
    _checkBluetoothStatus();
    connect();

  }

  void connect() async {
    var bluetoothScan = await Permission.bluetoothScan.request();
    var bluetoothConnect = await Permission.bluetoothConnect.request();
    if (bluetoothConnect.isGranted && bluetoothScan.isGranted) {
      try {
        EasyLoading.show(status: 'Connecting To Device...');
        connection = await BluetoothConnection.toAddress(
            "98:DA:50:02:5B:0B"); //Use your MAC address here
        showDialog("Bluethooth Connected");

        setState(() {
          connectionState = true;
        });
        try {
          connection.input?.listen((Uint8List data) {
            String message =
            utf8.decode(data); // Decode data to string using UTF-8 encoding

            List<String> values = message.split(',');

            for (String value in values) {
              int intValue = int.parse(value);
              setState(() {
                buttonState[intValue] = 'ON';
              });
            }
          }).onDone(() {
            print('Disconnected by remote request');
          });
        } catch (exception) {
          print('Cannot connect, exception occured');
        }
      } catch (e) {
        showDialog("Bluethooth Connection Error");
      } finally {

        Future.delayed(Duration(seconds: 2), () {
          EasyLoading.dismiss();
        });
      }
    }
  }
  
  Future<void> _checkBluetoothStatus() async {
    // Check if Bluetooth is enabled
    bool? isEnabled = await flutterBluetoothSerial?.isEnabled;
    if (!isEnabled!) {
      // Request user to enable Bluetooth
      flutterBluetoothSerial.requestEnable().then((dynamic val) => {
        if(val) {
          connect()
        }

      });

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


  void showDialog(message) {
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void sendMessage(message, index, value) async {
    try {
      connection.output.add(utf8.encode(message));
      connection.output.allSent.then((_) {
        setState(() {
          buttonState[index] = value.toString();
        });
        showDialog("Success");
      });
    } catch (error) {
      showDialog("Error Send Message");
    }
  }

  void onPress(index, message) async {

    var bluetoothScan = await Permission.bluetoothScan.request();
    var bluetoothConnect = await Permission.bluetoothConnect.request();
    if (bluetoothConnect.isGranted && bluetoothScan.isGranted) {
      if (connection == null) {
        connect();
      }
      var value = message;

      if (buttonState[index] == "ON" && message == "ON") {
        showDialog("Already light is on");
      }

      setState(() {
        buttonState[index] = value.toString();
      });
      sendMessage('{"light${index}":"${message}"}', index, value);
    }

  }

  void dispose() {
    if (connection != null && connection.isConnected) {
      connection.close();
    }
    super.dispose();
  }


  List<Widget> buildRowChildren() {
    List<Widget> row = [];
    List<Widget> col = [];
    for (int i = 0; i < 8; i++) {
      col = [];
      for (int j = 0; j < 2; j++) {
        bool isLightOn = buttonState[i * 2 + j + 1] == "ON";
        Color textColor = buttonState[i * 2 + j + 1] == "ON"
            ? Color.fromRGBO(255,255,255,1)
            : Color.fromRGBO(0, 0, 0 , 1);

        String imageUrl = buttonState[i * 2 + j + 1] == "ON"
            ? 'assets/nlighton.png'
            : 'assets/nlightoff.png';

        Color bgColor= buttonState[i * 2 + j + 1] == "ON"
            ? Color.fromRGBO(32, 98, 255, 1) :  Color.fromRGBO(255,255,255,1);

        dynamic btnColor = buttonState[i * 2 + j + 1] == "ON" ? [
          Color(0xFF1576d5), // First color
          Color(0xFF1989f7), // Second color
        ]:  [
          Color(0xffffffff), //  First color
          Color(0xffffffff), //
        ];
        col.add(Expanded(
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Padding(
                padding: EdgeInsets.all(5),
                child:  new Container(
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
                  child: new Column(

                    children: [

                      SizedBox(height: 20),
                      new Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Image.asset(imageUrl, width: 50),
                      ]),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          new Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: new Text('Light ${i * 2 + j + 1}',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18, color: textColor)),
                          )
                        ],
                      ),
                      new Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0), // Set border radius here
                                    )),
                                onPressed: () => {onPress(i * 2 + j + 1, "ON")},
                                child: new Text("ON",
                                    style: TextStyle(

                                        fontSize: 18, color:Color.fromRGBO(0, 0, 0, 1)))),
                          ),
                          Padding(
                            padding: EdgeInsets.all(4.0),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    padding: EdgeInsets.all(8),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          20.0), // Set border radius here
                                    )),
                                onPressed: () => {onPress(i * 2 + j + 1, "OFF")},
                                child: new Text(
                                  "OFF",
                                  style: TextStyle(
                                      fontSize: 18, color: Color.fromRGBO(0, 0, 0, 1)),
                                )),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            )));
      }
      row.add(new Row(children: col));
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

            backgroundColor:Color.fromRGBO(247, 248, 255, 1),
            title: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Bluetooth Control Switch",style: TextStyle(fontWeight: FontWeight.bold),),
              ],
            )
        ),
          bottomNavigationBar: Container(
            height: 40,
            child: Center(
              child: Text(connectionState ? 'Device connected' : 'Device disconnected',style: TextStyle(
                color: Color.fromRGBO(0, 0, 0, 1)
              ),),
            ),
          ),
          body: Container(
              color: Color.fromRGBO(247, 248, 255, 1),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,

            child:        SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: buildRowChildren(),
                ),
              ),
            )),
      )






    );
  }
}
