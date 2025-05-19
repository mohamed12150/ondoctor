import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:ondoctor/Screens/all_doctors_page.dart';
import 'category_page.dart'; // تأكد من المسار الصحيح حسب مشروعك

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  final List<IconData> _icons = [
    Icons.home,
    Icons.calendar_today,
    Icons.chat,
    Icons.settings,
  ];

  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(child: Text("Appointments")),
    const Center(child: Text("Messages")),
    const Center(child: Text("Settings")),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.only(bottom: 16, left: 16, right: 17),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.purple.withOpacity(0.1),
                blurRadius: 10,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: BottomNavigationBar(
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              backgroundColor: Colors.grey[190],
              selectedFontSize: 0,
              elevation: 0,
              type: BottomNavigationBarType.fixed,
              selectedItemColor: Colors.purple,
              unselectedItemColor: Colors.black45,
              showSelectedLabels: false,
              showUnselectedLabels: false,
              items: _icons
                  .map((icon) => BottomNavigationBarItem(
                        icon: Icon(icon),
                        label: '',
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text("Hello, Rakib", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.purple)),
                    SizedBox(height: 5),
                    Text("Welcome Back", style: TextStyle(color: Colors.grey)),
                  ],
                ),
                CircleAvatar(
                  radius: 24,
                  backgroundImage: AssetImage("assets/images/user_profile.jpg"),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // مربع البحث بعد التعديل
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Color(0xFFF5F5F5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 6),
                  ),
                ],
                border: Border.all(color: Colors.purple[100]!),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const TextField(
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: Colors.purple),
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            // الأقسام مع التنقل
            const Text("Departments", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  CategoryItem(title: "Cardiology", icon: Icons.favorite),
                  CategoryItem(title: "Neurology", icon: Icons.memory),
                  CategoryItem(title: "Dentistry", icon: Icons.medical_services),
                  CategoryItem(title: "Radiology", icon: Icons.scanner),
                  CategoryItem(title: "Ophthalmology", icon: Icons.visibility),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text("Upcoming Schedule (3)", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            _buildScheduleSlider(context),

            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Popular Doctors", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AllDoctorsPage()),
                    );
                  },
                  child: const Text(
                    "See All",
                    style: TextStyle(color: Colors.purple),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),
            const DoctorCard(
                name: "Dr. Amelia Emma",
                specialty: "Gynecologist",
                rating: 4.9,
                price: "\$25/hr"),
            const SizedBox(height: 10),
            const DoctorCard(
                name: "Dr. Daniel Jack",
                specialty: "Neurologist",
                rating: 4.7,
                price: "\$30/hr"),
          ],
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final String title;
  final IconData icon;

  const CategoryItem({super.key, required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => CategoryPage(category: title)));
      },
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.1),
                blurRadius: 6,
                offset: const Offset(0, 3),
              )
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: Colors.purple,
              child: Icon(icon, size: 16, color: Colors.white),
            ),
            const SizedBox(height: 5),
            Text(title,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87)),
          ],
        ),
      ),
    );
  }
}

Widget _buildScheduleSlider(BuildContext context) {
  final List<Map<String, dynamic>> scheduleList = [
    {
      "name": "Prof. Dr. Logan Mason",
      "specialty": "Dentist",
      "date": "June 12, 9:30 AM",
      "rating": 4.9,
      "image": "assets/images/a.jpg"
    },
    {
      "name": "Dr. Sarah Connor",
      "specialty": "Cardiologist",
      "date": "June 15, 11:00 AM",
      "rating": 4.8,
      "image": "assets/images/a.jpg"
    },
    {
      "name": "Dr. John Smith",
      "specialty": "Neurologist",
      "date": "June 18, 2:00 PM",
      "rating": 4.7,
      "image": "assets/images/a.jpg"
    },
  ];

  return CarouselSlider(
    options: CarouselOptions(
      height: 160,
      enlargeCenterPage: true,
      enableInfiniteScroll: false,
      autoPlay: true,
    ),
    items: scheduleList.map((schedule) {
      return Builder(
        builder: (BuildContext context) {
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.purple,
              borderRadius: BorderRadius.circular(20),
            ),
            width: MediaQuery.of(context).size.width * 0.8,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(schedule["image"]),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(schedule["name"],
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text(schedule["specialty"],
                          style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 5),
                      Text(schedule["date"],
                          style: const TextStyle(color: Colors.white)),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.amber, size: 16),
                          const SizedBox(width: 4),
                          Text("${schedule["rating"]}",
                              style: const TextStyle(color: Colors.white)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    }).toList(),
  );
}

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
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              blurRadius: 6,
              offset: const Offset(0, 3),
            )
          ]),
      child: Row(
        children: [
          const CircleAvatar(
            backgroundImage: AssetImage("assets/images/a.jpg"),
            radius: 30,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                Text(specialty, style: const TextStyle(color: Colors.grey)),
                Row(
                  children: [
                    const Icon(Icons.star, color: Colors.orange, size: 16),
                    Text("$rating (2345 Reviews)",
                        style: const TextStyle(fontSize: 12)),
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
