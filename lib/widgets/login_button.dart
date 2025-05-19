import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  const LoginButton({super.key, required this.formKey});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: Duration(milliseconds: 1500),
      child: ElevatedButton(
        onPressed: () {
          if (formKey.currentState!.validate()) {
            // تنفيذ تسجيل الدخول
          }
        },
        style: ElevatedButton.styleFrom(
          minimumSize: Size(double.infinity, 45),
          backgroundColor: Colors.purple,
        ),
        child: Text(
          "Login",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
