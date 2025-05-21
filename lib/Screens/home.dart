import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:ondoctor/Screens/appointments_screen.dart';
import 'package:ondoctor/Screens/doctor_details_page.dart' as details;
import 'package:ondoctor/Screens/list_doctors.dart';
import 'package:ondoctor/Screens/messages/listchat.dart';
import 'package:ondoctor/Screens/profile_screen.dart';
import 'package:ondoctor/category_item.dart';
import 'package:ondoctor/doctor_card.dart';

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
    Icons.person,
  ];

  final List<Widget> _screens = [
    const HomeScreen(),
    const AppointmentPage(),
    ChatListScreen(),
    const ProfileScreen(),
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
      body: Stack(
        children: [
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) {
              return FadeTransition(opacity: animation, child: child);
            },
            child: _screens[_selectedIndex],
          ),
          Positioned(
            left: 30,
            right: 24,
            bottom: 16,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(90),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.07),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(_icons.length, (index) {
                  final isSelected = _selectedIndex == index;
                  return GestureDetector(
                    onTap: () => _onItemTapped(index),
                    behavior: HitTestBehavior.translucent,
                    child: Icon(
                      _icons[index],
                      color: isSelected
                          ? Colors.blue.shade700
                          : Colors.grey.shade400,
                      size: isSelected ? 30 : 24,
                    ),
                  );
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // بيانات الأطباء
  final List<Map<String, dynamic>> doctors = [
    {
      "name": "Dr. Amelia Emma",
      "specialty": "Gynecologist",
      "rating": 4.9,
      "price": "\$25/hr",
    },
    {
      "name": "Dr. Daniel Jack",
      "specialty": "Neurologist",
      "rating": 4.7,
      "price": "\$30/hr",
    },
  ];

  // نسخة من الأطباء لعرضها مع إمكانية الفلترة
  late List<Map<String, dynamic>> filteredDoctors;

  // للتحكم في TextField
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredDoctors = doctors;
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    String searchText = _searchController.text.toLowerCase();

    setState(() {
      filteredDoctors = doctors.where((doctor) {
        final nameLower = doctor["name"].toLowerCase();
        final specialtyLower = doctor["specialty"].toLowerCase();
        return nameLower.contains(searchText) || specialtyLower.contains(searchText);
      }).toList();
    });
  }

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
                    Text(
                      "Hello, Rakib",
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                        letterSpacing: 0.4,
                      ),
                    ),
                    SizedBox(height: 5),
                  ],
                ),
                const Icon(Icons.notifications_active_outlined,
                    size: 30, color: Colors.black54),
              ],
            ),
            const SizedBox(height: 20),

            // مربع البحث 
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 253, 252, 252),
                boxShadow: [
                  BoxShadow(
                    color: const Color.fromARGB(255, 128, 104, 170).withOpacity(0.1),
                    blurRadius: 1,
                    offset: const Offset(0, 5),
                  ),
                ],
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  icon: Icon(
                    Icons.search,
                    color: Color.fromARGB(255, 90, 34, 187),
                  ),
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.grey),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Departments",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  DoctorsListPage()),
                    );
                   
                  },
                  child: Text(
                    "See All",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 95,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 2),
                children: [
                  CategoryItem(
                    title: "Cardiology",
                    iconWidget: SvgPicture.asset(
                      "assets/images/icons8-cardiology-48.svg",
                      height: 30,
                      width: 30,
                    ),
                    routeName: '/Cardiology',
                  ),
                  CategoryItem(
                      title: "Neurology",
                      iconWidget: SvgPicture.asset(
                        "assets/images/icons8-neurology-32.svg",
                        height: 30,
                        width: 30,
                      ),
                      routeName: "/neurology"),
                  CategoryItem(
                      title: "Dentistry",
                      iconWidget: SvgPicture.asset(
                        "assets/images/dentist-svgrepo-com.svg",
                        colorFilter: const ColorFilter.mode(
                            Colors.purple, BlendMode.srcIn),
                        height: 30,
                        width: 30,
                      ),
                      routeName: "/dentistry"),
                  CategoryItem(
                      title: "Radiology",
                      iconWidget: SvgPicture.asset(
                        "assets/images/icons8-ultrasound-machine-100.svg",
                        height: 30,
                        width: 30,
                      ),
                      routeName: "/radiology"),
                  CategoryItem(
                      title: "Ophthalmology",
                      iconWidget: SvgPicture.asset(
                        "assets/images/icons8-ophthalmology-100.svg",
                        height: 30,
                        width: 30,
                      ),
                      routeName: "/ophthalmology"),
                ],
              ),
            ),

            const SizedBox(height: 30),
            const Text(
              "Upcoming Schedule",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            _buildAutoScrollSchedule(),

            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Popular Doctors",
                  style: TextStyle(
                      color: Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.w900),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                               DoctorsListPage(
                                
                              )),
                    );
                  },
                  child: Text(
                    "See All",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.purple),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),

            // عرض الأطباء حسب الفلترة
            ...filteredDoctors.map((doctor) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: DoctorCard(
                  name: doctor["name"],
                  specialty: doctor["specialty"],
                  rating: doctor["rating"],
                  price: doctor["price"],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

Widget _buildAutoScrollSchedule() {
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

  return SizedBox(
    height: 150,
    child: CarouselSlider.builder(
      itemCount: scheduleList.length,
      itemBuilder: (context, index, realIdx) {
        final schedule = scheduleList[index];
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => details.DoctorDetailsPage(
                  name: schedule["name"],
                  specialty: schedule["specialty"],
                  date: schedule["date"],
                  rating: schedule["rating"].toDouble(),
                  image: schedule["image"],
                ),
              ),
            );
          },
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.deepPurple,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 35,
                  backgroundImage: AssetImage(schedule["image"]),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        schedule["name"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        schedule["date"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 4,
                        children: [
                          const Icon(Icons.star, color: Colors.amber, size: 18),
                          Text(
                            "${schedule["rating"]}",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.w600,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
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
      options: CarouselOptions(
        height: 150,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 3),
        enlargeCenterPage: true,
        viewportFraction: 0.90,
        scrollDirection: Axis.vertical,
      ),
    ),
  );
}
