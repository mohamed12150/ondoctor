import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';

import 'package:ondoctor/Screens/Auth/Password.dart';
import 'package:ondoctor/Screens/Auth/sigin%20up.dart';
import 'package:ondoctor/Screens/home.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     body: 
       SingleChildScrollView(
        child: Column(
          children: [
          
        SizedBox(height:15 ,),
         SizedBox(
              height: 355,
              child: Image.asset(
                "assets/images/DeWatermark.ai_1746715065362.png",
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  FadeInUp(
                    duration: Duration(milliseconds: 1800),
                    child: Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: Color.fromRGBO(143, 148, 251, 1),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromRGBO(143, 148, 251, .2),
                            blurRadius: 20.0,
                            offset: Offset(0, 10),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.all(1.0),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromRGBO(143, 148, 251, 1),
                                ),
                              ),
                            ),
                            child: TextField(
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                hintText: "Email or Phone number",
                                hintStyle: TextStyle(color: Colors.grey[700]),
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
                                hintStyle: TextStyle(color: Colors.grey[700]),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  FadeInUp(
                    duration: Duration(milliseconds: 2000),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: GestureDetector(
                        onTap: () {
                             Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),);
                        },
                      child: Text(
                        "Forgot Password?",
                        textAlign: TextAlign.right,
                        style: TextStyle(
                          color: Color.fromRGBO(143, 148, 251, 1),
                        ),
                      ),
                    ),
                  ),),
                  SizedBox(height: 10),
                  FadeInUp(
                    duration: Duration(milliseconds: 1900),
                    child: GestureDetector(
                      onTap: () {
                             Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const Home()),);
                        },
                 
                      child: Container(
                        height: 45,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.purple,
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  FadeInUp(
                    duration: Duration(milliseconds: 2000),
                    child: Center(
                      child: Text(
                        "Or",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  
                  FadeInUp(
                    duration: Duration(milliseconds: 2000),
                    child: GestureDetector(
                      onTap: () {
                      },
                      child: Container(
                        alignment: Alignment.center,
                        height: 40,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                           Text(
                              "Login with Google",
                              style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14,
                              ),
                            ),

                            SizedBox(width: 10),
                            
                            Image.asset(
                              "assets/images/search.png",
                              height: 20,
                              width: 20,
                              
                            ),
                          ],
                        ),
                        
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  FadeInUp(
                    duration: Duration(milliseconds: 2000),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children:[ Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.grey[700]),
                        
                      ),

                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
  context,
  MaterialPageRoute(builder: (context) => const SignUpPage()),
);
                        },
                        child: Text(
                          " Sign Up",
                          style: TextStyle(
                            color: Colors.purple,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
    
  }
}