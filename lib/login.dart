import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
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
  runApp(const Login());
}

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginState createState() => _LoginState();
}

enum _SupportState {
  unknown,
  supported,
  unsupported,
}

class _LoginState extends State<Login> {
  final databaseReference = FirebaseDatabase.instance.reference();

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
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
  Future<void>  _onSubmit()  async {
    DatabaseEvent snapshot = await databaseReference.child('appPassword').once();
    String textValue = _controller.text;  // Get the value of TextField
    dynamic value =  snapshot.snapshot.value;
    if(textValue == '') {
      showTostDialog('Enter Password');
    } else {
      if(textValue == value) {
        Navigator.pushNamed(context,'/home');

      } else {
        showTostDialog('Invalid Password');
      }
    }

  }

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
        body: SingleChildScrollView(
          child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/fullbg.png"),
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.2),
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
                        padding: EdgeInsets.all(20),
                        child: new Column(
                          children: [
                            new TextField(
                              controller: _controller,
                              obscureText: true,
                              cursorColor: appColor, // Change the cursor color here
                              decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 20.0), // Set the height

                                labelStyle: TextStyle(
                                  color: appColor, // Set the label color here
                                  fontSize: 14
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: appColor, // Focused border color
                                    width: 2.0,
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color:
                                        appColor, // Set the border color here
                                    width:
                                        2.0, // Optional: set the border width
                                  ),
                                ),
                                labelText: 'Password',
                              ),
                            ),
                            SizedBox(height: 5),
                            SizedBox(
                              width: double.infinity,  // This makes the button full width
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  padding: EdgeInsets.all(8),
                                  backgroundColor: appColor,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(5.0), // Set border radius here
                                  ),
                                ),
                                onPressed:_onSubmit,
                                child: Text(
                                  style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
                                  "Login",
                                ),
                              ),
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
