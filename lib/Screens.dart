import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Splash extends StatelessWidget {
  const Splash({super.key});

  @override
  Widget build(BuildContext context) {





    return Scaffold(

body: Column(

  children: [
    Container(
      margin: EdgeInsets.all(10),
height:300,

        decoration: BoxDecoration(
          borderRadius: BorderRadius.only( bottomLeft: Radius.circular(60), bottomRight: Radius.circular(60)),
            image: DecorationImage(
                image: AssetImage('assets/images/DeWatermark.ai_1746714902475.png'),
                fit: BoxFit.fill
            ),


    color: Colors.white,

    ),
),
SizedBox(height: 40,),

    Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color:  Color.fromRGBO(143, 148, 251, 1)))
      ),
      child: TextField(
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Email or Phone number",
            hintStyle: TextStyle(color: Colors.grey[700])
        ),
      ),
    ),
    Container(
      padding: EdgeInsets.all(8.0),
      child: TextField(
        obscureText: true,
        decoration: InputDecoration(
            border: InputBorder.none,
            hintText: "Password",
            hintStyle: TextStyle(color: Colors.grey[700])
        ),
      ),
    )
  ],
),

       );




  }
}