import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';



class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(

            children: <Widget>[
              Container(

               height: 300,

                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage('assets/images/DeWatermark.ai_1746715065362.png'),
                    )
                ),

              ),
              Positioned(
height: 90,
                child: Padding(

                  padding: EdgeInsets.all(45.0),

                  child: Positioned(
                    height: 10,
                    bottom: 500,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        FadeInUp(duration: Duration(milliseconds: 1800), child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Color.fromRGBO(143, 148, 251, 1)),
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(143, 148, 251, .2),
                                    blurRadius: 20.0,
                                    offset: Offset(0, 10)
                                )
                              ]
                          ),

                            child: Column(
                              children: <Widget>[
                                Container(
                                  padding: EdgeInsets.all(1.0),
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
                                  padding: EdgeInsets.all(1.0),
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
                          ),
                        ),
SizedBox(height: 10,),
                        FadeInUp(duration: Duration(milliseconds: 2000),

                     child:

                        Text(" Forgot Password?",
                          textAlign: TextAlign.right,
                          style: TextStyle(


                              color: Color.fromRGBO(143, 148, 251, 1)),)),

SizedBox(height: 10,),
                        FadeInUp(
                            duration: Duration(milliseconds: 1900),
                            child: Container(
                          height: 35,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            color: Colors.purple,
                          ),
                              child: Center(

                            child: Text("Login", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                          ),
                        )),



                                               ],
                                             ),
                       ),
                  ),
                ),

            ],
          ),
        )
    );
  }
}
