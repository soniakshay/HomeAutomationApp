import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:test1/groupLight.dart';
import 'package:test1/striplight.dart';
import 'package:test1/wifiswitch.dart';

import 'bluethooth.dart';
import 'groupLightSettings.dart';





class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {

  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: MediaQuery.of(context).size.width * 0.3,
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
            child: SingleChildScrollView(
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
                  SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroupLight()),
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
                        Image.asset('assets/wgrouplight.png', width: 20),
                        SizedBox(height: 10),
                        new Text("Group Light",style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)))
                      ],
                    ),
                  ),


                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => GroupLightSettings()),
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
                        Image.asset('assets/wgrouplight.png', width: 20),
                        SizedBox(height: 10),
                        new Text("Group Light Settings",textAlign: TextAlign.center,style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)))
                      ],
                    ),
                  ),



                ],
              ),
            )
          ),
        ));

  }
}
