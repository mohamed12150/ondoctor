import 'package:flutter/material.dart';

class CategoryItem extends StatelessWidget {
  final String title;
  final Widget? iconWidget;
  final VoidCallback? onTap;

  const CategoryItem({
    super.key,
    required this.title,
    this.iconWidget,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            height: 60,
            width: 70,
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 6,
                  offset: Offset(0, 3),
                ),
              ],
            ),
          child: Center(
            child:
                iconWidget ??
                const Icon(
                  Icons.medical_services,
                  color: Color(0xFF6C63FF),
                  size: 32,
                ),
          ),
        ),
        
        Text(
          title,
          style: const TextStyle(
            fontSize: 12,
            
            fontWeight: FontWeight.bold,
          ),
        ),
      
      ],
  
      ),
    );
  }
}
