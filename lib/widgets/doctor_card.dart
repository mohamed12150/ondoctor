// lib/widgets/doctor_card.dart
import 'package:flutter/material.dart';

class DoctorCard extends StatelessWidget {
  final String name;
  final String specialty;
  final double rating;
  final String price;

  const DoctorCard({
    super.key,
    required this.name,
    required this.specialty,
    required this.rating,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(16)),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            radius: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(specialty, style: const TextStyle(color: Colors.grey)),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    Text("$rating (2345 Reviews)", style: const TextStyle(fontSize: 12)),
                  ],
                )
              ],
            ),
          ),
          Text(price,
              style: const TextStyle(
                  color: Colors.green, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
