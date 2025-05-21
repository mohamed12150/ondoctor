import 'package:flutter/material.dart';

class DoctorsPage extends StatelessWidget {
  final String specialty;
  final Map<String, List<String>> doctorsBySpecialty;

  const DoctorsPage({
    super.key,
    required this.specialty,
    required this.doctorsBySpecialty,
  });

  @override
  Widget build(BuildContext context) {
    final doctors = doctorsBySpecialty[specialty] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text('أطباء $specialty'),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctorName = doctors[index];
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: const BorderSide(color: Colors.black, width: 1.5),
            ),
            color: Colors.white,
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: ListTile(
              title: Text(
                doctorName,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              trailing: const Icon(Icons.arrow_forward_ios, size: 18),
              onTap: () {
                // هنا ممكن تضيف تفاصيل أو حجز
              },
            ),
          );
        },
      ),
    );
  }
}
