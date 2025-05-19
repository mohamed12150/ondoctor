import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';

class EmailField extends StatelessWidget {
  final TextEditingController controller;

  const EmailField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return FadeInUp(
      duration: Duration(milliseconds: 1300),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: "Email",
            hintStyle: TextStyle(color: Colors.grey[700]),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.grey),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.purple),
            ),
          ),
          validator: (val) {
            if (val == null || val.isEmpty) {
              return 'Required';
            }
            if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(val)) {
              return 'Invalid email format';
            }
            return null;
          },
        ),
      ),
    );
  }
}
