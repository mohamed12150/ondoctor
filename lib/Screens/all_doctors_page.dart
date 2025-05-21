import 'package:flutter/material.dart';

class AllDoctorsPage extends StatelessWidget {
  final String department;

  const AllDoctorsPage({super.key, required this.department});

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

    final filteredDoctors = doctors.where((doc) {
      final specialty = doc["specialty"].toString().toLowerCase();
      final departmentLower = department.toLowerCase();
      return specialty.contains(departmentLower) || departmentLower.contains(specialty);
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("$department Doctors"),
        backgroundColor: Colors.purple,
      ),
      body: filteredDoctors.isEmpty
          ? const Center(child: Text("No doctors available in this department."))
          : ListView.builder(
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                final doctor = filteredDoctors[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage("assets/images/a.jpg"),
                  ),
                  title: Text(doctor["name"]),
                  subtitle: Text(doctor["specialty"]),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(doctor["price"],
                          style: const TextStyle(
                              fontSize: 16, color: Colors.green)),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star,
                              color: Colors.orange, size: 14),
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
