import 'package:flutter/material.dart';

class DoctorsByCategory extends StatelessWidget {
  final String category;

  const DoctorsByCategory({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    // بيانات الأطباء API لاحقًا
    final allDoctors = [
      {"name": "Dr. Amina", "specialty": "Cardiology", "rating": 4.9, "price": "\$25/hr"},
      {"name": "Dr. Omar", "specialty": "Neurology", "rating": 4.7, "price": "\$30/hr"},
      {"name": "Dr. Lina", "specialty": "Dentistry", "rating": 4.8, "price": "\$22/hr"},
      {"name": "Dr. Sara", "specialty": "Cardiology", "rating": 4.5, "price": "\$27/hr"},
    ];

    // تصفية الأطباء حسب التخصص المختار
    final filteredDoctors = allDoctors.where((doc) => doc["specialty"] == category).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text("$category Doctors"),
        backgroundColor: Colors.purple,
      ),
      body: filteredDoctors.isEmpty
          ? Center(
              child: Text(
                "لا يوجد أطباء في تخصص $category حالياً",
                style: const TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: filteredDoctors.length,
              itemBuilder: (context, index) {
                final doctor = filteredDoctors[index];
                return ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage("assets/images/a.jpg"), // ممكن تغيّر الصورة حسب الدكتور
                  ),
                  title: Text(doctor["name"] as String? ?? ''),
                  subtitle: Text(doctor["specialty"] as String? ?? ''),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        (doctor["price"] as String? ?? ''),
                        style: const TextStyle(fontSize: 16, color: Colors.green),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.star, color: Colors.orange, size: 14),
                          Text("${doctor["rating"] ?? ''}"),
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
