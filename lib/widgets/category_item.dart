// lib/widgets/category_item.dart
import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;

  const CategoryItem({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: Colors.deepPurple,
            child: Icon(icon, size: 16, color: Colors.white),
          ),
          const SizedBox(height: 5),
          Text(title, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }
}
