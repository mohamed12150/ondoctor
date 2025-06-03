import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const CategoryPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  // بيانات الأطباء حسب القسم
  List<Map<String, dynamic>> getDoctorsForCategory(String category) {
    switch (category) {
      case 'Cardiology':
        return [
          {'name': 'Dr. Heartwell', 'specialty': 'Cardiologist', 'rating': 4.9, 'price': '\$45/hr'},
          {'name': 'Dr. Pulse', 'specialty': 'Cardiologist', 'rating': 4.7, 'price': '\$40/hr'},
        ];
      case 'Neurology':
        return [
          {'name': 'Dr. Brainstorm', 'specialty': 'Neurologist', 'rating': 4.8, 'price': '\$50/hr'},
        ];
      case 'Dentistry':
        return [
          {'name': 'Dr. White Smile', 'specialty': 'Dentist', 'rating': 4.6, 'price': '\$30/hr'},
        ];
      case 'Radiology':
        return [
          {'name': 'Dr. Scanwell', 'specialty': 'Radiologist', 'rating': 4.5, 'price': '\$35/hr'},
        ];
      case 'Ophthalmology':
        return [
          {'name': 'Dr. Vision', 'specialty': 'Ophthalmologist', 'rating': 4.7, 'price': '\$38/hr'},
        ];
      default:
        return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final doctors = getDoctorsForCategory(categoryName);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(categoryName),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: doctors.isEmpty
            ? const Center(child: Text("No doctors available"))
            : ListView.builder(
                itemCount: doctors.length,
                itemBuilder: (context, index) {
                  final doc = doctors[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundImage: AssetImage("assets/images/a.jpg"),
                      ),
                      title: Text(doc['name']),
                      subtitle: Text("${doc['specialty']} • ${doc['rating']} ★"),
                      trailing: Text(doc['price'], style: const TextStyle(color: Colors.green)),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
