import 'package:flutter/material.dart';

class AllDoctorsPage extends StatelessWidget {
  const AllDoctorsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> doctors = [
      {
        "name": "Dr. Amelia Emma",
        "specialty": "Gynecologist",
        "rating": 4.9,
        "price": "\$25/hr"
      },
      {
        "name": "Dr. Daniel Jack",
        "specialty": "Neurologist",
        "rating": 4.7,
        "price": "\$30/hr"
      },
      {
        "name": "Dr. Olivia Stone",
        "specialty": "Cardiologist",
        "rating": 4.8,
        "price": "\$28/hr"
      },
      {
        "name": "Dr. Ethan Hawk",
        "specialty": "Dentist",
        "rating": 4.6,
        "price": "\$20/hr"
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("All Doctors"),
        backgroundColor: Colors.purple,
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return ListTile(
            leading: const CircleAvatar(
              backgroundImage: AssetImage("assets/images/a.jpg"),
            ),
            title: Text(doctor["name"]),
            subtitle: Text(doctor["specialty"]),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(doctor["price"], style: const TextStyle(color: Colors.green)),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 14),
                    Text("${doctor["rating"]}"),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
