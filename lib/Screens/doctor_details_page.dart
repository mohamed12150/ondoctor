import 'package:flutter/material.dart';

class DoctorDetailsPage extends StatelessWidget {
  final String name;
  final String specialty;
  final String date;
  final double rating;
  final String image;

  const DoctorDetailsPage({
    super.key,
    required this.name,
    required this.specialty,
    required this.date,
    required this.rating,
    required this.image,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage(image),
              radius: 50,
            ),
            const SizedBox(height: 20),
            Text(name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            Text(specialty, style: const TextStyle(fontSize: 16, color: Colors.grey)),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 6),
                Text(date),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 16),
                Text(" $rating"),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                // Add booking logic here
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.purple,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
              ),
              child: const Text("Book Appointment"),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
