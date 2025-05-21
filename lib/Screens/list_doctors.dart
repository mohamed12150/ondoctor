import 'package:flutter/material.dart';

// صفحة تفاصيل الدكتور (الكود اللي أرسلته أنت)
class DoctorDetailsPage extends StatefulWidget {
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
  State<DoctorDetailsPage> createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  String? selectedSlot;
  bool isFavorite = false;
  bool isBooking = false;

  @override
  Widget build(BuildContext context) {
    final royalPurple = Color(0xFF6A0DAD);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Specialist Details",
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 2,
        iconTheme: IconThemeData(color: royalPurple),
        actions: [
          IconButton(
            icon: Icon(
              isFavorite ? Icons.favorite : Icons.favorite_border,
              color: isFavorite ? Colors.red : Colors.grey.shade700,
              size: 24,
            ),
            onPressed: () {
              setState(() {
                isFavorite = !isFavorite;
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 12,
                        spreadRadius: 1,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: CircleAvatar(
                    backgroundImage: AssetImage(widget.image),
                    radius: 50,
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.name,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        widget.specialty,
                        style: TextStyle(color: Colors.grey.shade700, fontSize: 15),
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 22),
                          SizedBox(width: 6),
                          Text(
                            "${widget.rating}",
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.grey.shade800),
                          ),
                          SizedBox(width: 12),
                          Text(
                            "(432 reviews)",
                            style: TextStyle(color: Colors.grey.shade600, fontSize: 13),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _infoCard("2400+", "Patients", royalPurple),
                _infoCard("7 yr+", "Experience", royalPurple),
                _infoCard("4.9", "Rating", royalPurple),
              ],
            ),
            SizedBox(height: 35),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Morning Slots",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16),
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 16,
              runSpacing: 10,
              children: [
                _slotButton("10:00 AM", royalPurple),
                _slotButton("10:30 AM", royalPurple),
                _slotButton("11:00 AM", royalPurple),
                _slotButton("11:30 AM", royalPurple),
              ],
            ),
            SizedBox(height: 22),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Afternoon Slots",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                    fontSize: 16),
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 16,
              runSpacing: 10,
              children: [
                _slotButton("2:00 PM", royalPurple),
                _slotButton("3:30 PM", royalPurple),
                _slotButton("4:00 PM", royalPurple),
              ],
            ),
            SizedBox(height: 35),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: royalPurple.withOpacity(0.3),
                    blurRadius: 7,
                    spreadRadius: 1,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.message, color: Colors.blue),
                  SizedBox(width: 14),
                  Expanded(
                      child: Text(
                    "Messaging\nCan communicate with the doctor.",
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  )),
                  Text("\$05",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Colors.green)),
                ],
              ),
            ),
            SizedBox(height: 35),
            ElevatedButton(
              onPressed: selectedSlot == null || isBooking
                  ? null
                  : () async {
                      setState(() {
                        isBooking = true;
                      });

                      await Future.delayed(Duration(seconds: 2));

                      setState(() {
                        isBooking = false;
                      });

                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          content: Row(
                            children: [
                              Icon(Icons.check_circle_outline,
                                  color: royalPurple),
                              SizedBox(width: 12),
                              Expanded(
                                child: RichText(
                                  text: TextSpan(
                                    children: [
                                      TextSpan(
                                        text:
                                            "Appointment booked successfully ",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      TextSpan(
                                        text: "at $selectedSlot",
                                        style: TextStyle(
                                            color: Colors.green.shade700,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );

                      Future.delayed(Duration(seconds: 2), () {
                        Navigator.of(context).pop();
                      });
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor:
                    selectedSlot == null ? Colors.grey : royalPurple,
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 40),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                elevation: 4,
                shadowColor: royalPurple.withOpacity(0.7),
              ),
              child: isBooking
                  ? SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : Text(
                      "Book Appointment",
                      style: TextStyle(fontSize: 18, color: Colors.white),
                    ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _infoCard(String title, String subtitle, Color royalPurple) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 85,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: royalPurple.withOpacity(0.15),
            blurRadius: 10,
            spreadRadius: 2,
            offset: Offset(0, 5),
          )
        ],
      ),
      child: Column(
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: royalPurple)),
          SizedBox(height: 4),
          Text(subtitle,
              style: TextStyle(
                color: Colors.grey.shade700,
                fontSize: 13,
              )),
        ],
      ),
    );
  }

  Widget _slotButton(String time, Color royalPurple) {
    final bool isSelected = selectedSlot == time;
    return GestureDetector(
      onTap: () {
        setState(() {
          selectedSlot = isSelected ? null : time;
        });
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 250),
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? royalPurple : Colors.white,
          border: Border.all(
              color: isSelected ? royalPurple : Colors.grey.shade400),
          borderRadius: BorderRadius.circular(12),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: royalPurple.withOpacity(0.3),
                    blurRadius: 6,
                    spreadRadius: 1,
                    offset: Offset(0, 3),
                  )
                ]
              : [],
        ),
        child: Text(
          time,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey.shade800,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 15,
          ),
        ),
      ),
    );
  }
}

// صفحة اللسته 
class DoctorsListPage extends StatelessWidget {
  final List<Map<String, dynamic>> doctors = [
    {
      "name": "Dr. Amelia Emma",
      "specialty": "Gynecologist",
      "image": "assets/images/a.jpg",
      "date": "10 April 2025",
      "rating": 4.7,
    },
    {
      "name": "Dr. Daniel Jack",
      "specialty": "Neurologist",
      "image": "assets/images/a.jpg",
      "date": "11 April 2025",
      "rating": 4.5,
    },
    {
      "name": "Dr. Sarah Connor",
      "specialty": "Cardiologist",
      "image": "assets/images/a.jpg",
      "date": "12 April 2025",
      "rating": 4.8,
    },
    {
      "name": "Dr. Logan Mason",
      "specialty": "Dentist",
      "image": "assets/images/a.jpg",
      "date": "13 April 2025",
      "rating": 4.6,
    },
  ];

  DoctorsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Doctors List"),
        backgroundColor: Colors.deepPurple,
      ),
      body: ListView.builder(
        itemCount: doctors.length,
        itemBuilder: (context, index) {
          final doctor = doctors[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundImage: AssetImage(doctor["image"]),
            ),
            title: Text(doctor["name"]),
            subtitle: Text(doctor["specialty"]),
            trailing: const Icon(Icons.arrow_forward_ios),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DoctorDetailsPage(
                    name: doctor["name"],
                    specialty: doctor["specialty"],
                    date: doctor["date"],
                    rating: doctor["rating"],
                    image: doctor["image"],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
