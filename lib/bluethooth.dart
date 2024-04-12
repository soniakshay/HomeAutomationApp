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
            ? Color(0xFFc7b698)
            : Color(0xFFa5a6aa);

        String imageUrl = buttonState[i * 2 + j + 1] == "ON"
            ? 'assets/onlight.png'
            : 'assets/offlight.png';
        col.add(Expanded(
            child: Padding(
              padding: EdgeInsets.all(0),
              child: Card(
                  child: Padding(
                    padding: EdgeInsets.all(8.0),
                    child: new Column(
                      children: [
                        new Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                          Image.asset(imageUrl, width: 100),
                        ]),
                        new Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            new Padding(
                              padding: EdgeInsets.only(top: 8),
                              child: new Text('Light ${i * 2 + j + 1}',
                                  style: TextStyle(fontSize: 18, color: textColor)),
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
                                          fontSize: 18, color: Color(0xFFa5a6aa)))),
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
                                        fontSize: 18, color: Color(0xFFa5a6aa)),
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  )),
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
              const Text(
                "Bluetooth Control Switch",
                style: TextStyle(
                    color: Color(0xFFa5a6aa), fontWeight: FontWeight.bold),
              ),
            ],
          )),

          bottomNavigationBar: Container(
            height: 40,
            child: Center(
              child: Text(connectionState ? 'Device connected' : 'Device disconnected',),
            ),
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: buildRowChildren(),
              ),
            ),
          )),



    );
  }
}
