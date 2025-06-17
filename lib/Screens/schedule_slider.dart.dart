import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class ScheduleSlider extends StatelessWidget {
  const ScheduleSlider({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> scheduleList = [
      {
        "name": "Prof. Dr. Logan Mason",
        "specialty": "Dentist",
        "date": "June 12,9:30 AM",
        "rating": 4.9,
        "image": "https://via.placeholder.com/150",
      },
      {
        "name": "Dr. Sarah Connor",
        "specialty": "Cardiologist",
        "date": "June 15,11:00 AM",
        "rating": 4.8,
        "image": "https://via.placeholder.com/150",
      },
      {
        "name": "Dr. John Smith",
        "specialty": "Neurologist",
        "date": "June 18,2:00 PM",
        "rating": 4.7,
        "image": "https://via.placeholder.com/150",
      },
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 160,
        enlargeCenterPage: true,
        enableInfiniteScroll: false,
        autoPlay: true,
        viewportFraction: 0.9, // ✅ تقليل عرض العنصر قليلاً لتفادي تجاوز الشاشة
      ),
      items:
          scheduleList.map((schedule) {
            return Builder(
              builder: (BuildContext context) {
                return ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth:
                        MediaQuery.of(context).size.width * 0.85, // ✅ حجم متكيف
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 129, 127, 133),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(schedule["image"]),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          // ✅ هذا يساعد في تجنب الـ overflow
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                schedule["name"],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                schedule["specialty"],
                                style: const TextStyle(color: Colors.white70),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                schedule["date"],
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    "${schedule["rating"]}",
                                    style: const TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }).toList(),
    );
  }
}
