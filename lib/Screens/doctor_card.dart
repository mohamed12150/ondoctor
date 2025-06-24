import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondoctor/Screens/home.dart';
import '../models/doctor_model.dart';

class DoctorCard extends StatelessWidget {
  final Doctor doctor;

  const DoctorCard({super.key, required this.doctor});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: themeController.isDarkMode ? Colors.black12 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundImage:
                          doctor.profileImage != null &&
                                  doctor.profileImage!.isNotEmpty
                              ? NetworkImage(doctor.fullImageUrl)
                              : const AssetImage(
                                    "assets/images/default_doctor.png",
                                  )
                                  as ImageProvider,
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: Colors.green,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.star, size: 16, color: Colors.deepPurpleAccent),
                    SizedBox(width: 4),
                    Text(
                      "4.8",
                      style: TextStyle(color: Colors.deepPurple, fontSize: 13),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            flex: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor.name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doctor.categories.map((c) => c.name).join(", "),
                  style: const TextStyle(
                    color: Color(0xFF888DA7),
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    InkWell(
                      onTap: () {
                        // الانتقال باستخدام GetX مثلاً
                        Get.toNamed('/appointment', arguments: doctor);
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black38.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          color: Color(0xFFF6F6FA),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Text(
                          "Appointment",
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(width: 15),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconBadge({required IconData icon, required size}) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF1EDFD),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: size, color: Color(0xFFB69DF8)),
    );
  }
}
