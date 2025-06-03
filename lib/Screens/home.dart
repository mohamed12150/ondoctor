import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart'; // أضف هذه المكتبة
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ondoctor/Screens/appointments_screen.dart';
import 'package:ondoctor/Screens/doctor_details_page.dart' as details;
import 'package:ondoctor/Screens/doctor_details_page.dart';
import 'package:ondoctor/Screens/list_doctors.dart';
import 'package:ondoctor/Screens/messages/listchat.dart';
import 'package:ondoctor/Screens/profile_screen.dart';
import 'package:ondoctor/widgets//category_item.dart';
import 'package:ondoctor/Screens/doctor_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:card_swiper/card_swiper.dart';
import '../controllers/doctor_controller.dart';
import '../models/category_model.dart';
import '../controllers/category_controller.dart';

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

  void _onItemTapped(int index) async {
    if (index == 3 || index == 1 || index == 2) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        // لو ما مسجل دخول
        Get.snackbar("تنبيه", "يجب تسجيل الدخول أولاً",
            backgroundColor: Colors.red.shade100,
            colorText: Colors.black,
            duration: const Duration(seconds: 2));

        Get.toNamed('/login'); // استخدم الراوت المناسب لي صفحة تسجيل الدخول
        return;
      }
    }

    setState(() {
      _selectedIndex = index;
    });
  }

// bottom navgtion bar
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
                          ? Colors.purple.shade700
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
    {
      "name": "Dr. Daniel Jack",
      "specialty": "Neurologist",
      "rating": 4.7,
      "price": "\$30/hr",
    },
  ];

  // نسخة من الأطباء لعرضها مع إمكانية الفلترة
  late List<Map<String, dynamic>> filteredDoctors;
  String userName = ''; // ✅ لعرض اسم المستخدم

  // للتحكم في TextField
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredDoctors = doctors;
    _searchController.addListener(_onSearchChanged);
    loadUserName();
    // إذا ما عندك Binding تلقائي


  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
  final CategoryController categoryController = Get.put(CategoryController());
  final doctorController = Get.put(DoctorController());


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
  void loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
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
                  children:  [

                    Text(
                      userName.isNotEmpty ? "Hello, $userName" : "Hello",
                      style: const TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 5),
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
                          builder: (context) =>  DoctorsListPage(doctors: [],)),
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
            Obx(() {
              if (categoryController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              if (categoryController.categories.isEmpty) {
                return const Center(child: Text("لا توجد تصنيفات متاحة"));
              }

              return SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categoryController.categories.length,
                  itemBuilder: (context, index) {
                    final category = categoryController.categories[index];

                    return CategoryItem(
                      title: category.name,
                      iconWidget:Image.network(
                        category.iconUrl,
                        height: 30,
                        width: 30,
                        fit: BoxFit.contain,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return const SizedBox(
                            height: 30,
                            width: 30,
                            child: Center(
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          );
                        },
                        errorBuilder: (_, __, ___) => const Icon(Icons.category),
                      ),
                      onTap: () {
                        print('Category Tapped: id=${category.id}, name=${category.name}, iconUrl=${category.iconUrl}');

                        // Get.toNamed('/categories', arguments: {
                        //   'id': category.id,
                        //   'name': category.name,
                        // });
                      },

                    );
                  },
                ),
              );
            }),

            const SizedBox(height: 30),
            const Text(
              "Upcoming Schedule",
              style: TextStyle(
                  color: Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            buildStackedVerticalCards(), // ✅ هذا هو الويدجت الصحيح

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
                    Get.to(() => DoctorsListPage(
                      doctors: doctorController.filteredDoctors,
                    ));
                  },
                  child: Text(
                    "See All",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.purple,
                    ),
                  ),
                ),


              ],
            ),
            const SizedBox(height: 10),

            // عرض الأطباء حسب الفلترة


            Obx(() {
              return Column(
                children: doctorController.filteredDoctors.map((doctor) {
                  return GestureDetector(
                    onTap: () {
                      Get.toNamed('/appointment', arguments: doctor);
                    },
                    child: DoctorCard(doctor: doctor),
                  );
                }).toList(),
              );
            })









          ]),
      ),
    );
  }
}





Widget buildStackedVerticalCards() {
  final List<Map<String, dynamic>> scheduleList = [
    {
      "name": "Prof. Dr. Logan Mason",
      "specialty": "Dentist",
      "date": "June 12, 9:30 AM",
      "image": "assets/images/a.jpg"
    },
    {
      "name": "Dr. Sarah Connor",
      "specialty": "Cardiologist",
      "date": "June 15, 11:00 AM",
      "image": "assets/images/a.jpg"
    },
    {
      "name": "Dr. Ahmed",
      "specialty": "Neurologist",
      "date": "June 18, 2:00 PM",
      "image": "assets/images/a.jpg"
    },
  ];

  return SizedBox(
    height: 220, // زيادة الارتفاع لعرض جزء من البطاقة التالية
    child: Swiper(
      itemCount: scheduleList.length,
      itemWidth: MediaQueryData.fromWindow(WidgetsBinding.instance.window).size.width * 0.9,
      itemHeight: 180,
      layout: SwiperLayout.STACK,
      scrollDirection: Axis.vertical,
      loop: true,
      duration: 600,
      viewportFraction: 0.65, // لتقليل المساحة المحتلة لكل كرت وإظهار جزء من الكرت الذي يليه
      scale: 0.85, // تقليل حجم الكروت الخلفية لإعطاء إحساس بالعمق
      itemBuilder: (context, index) {
        return buildScheduleCard(scheduleList[index]);
      },
    ),
  );
}

Widget buildScheduleCard(Map<String, dynamic> schedule) {
  final dateParts = schedule["date"].split(', ');
  final date = dateParts[0];
  final time = dateParts.length > 1 ? dateParts[1] : '';

  return Container(
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [Colors.purple.shade600, Colors.purpleAccent.shade100],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.pink.withOpacity(0.3),
          blurRadius: 10,
          offset: const Offset(0, 5),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundImage: AssetImage(schedule["image"]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(schedule["name"],
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                  Text(schedule["specialty"],
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 13)),
                ],
              ),
            ),
            const Icon(LucideIcons.messageCircle, color: Colors.white70),

          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,           // مثل justify-content: center;

          children: [
            buildDatePill(Icons.calendar_today, date),
            buildDatePill(Icons.calendar_today, date),
            if (time.isNotEmpty) ...[
              const SizedBox(width: 1),
              buildDatePill(Icons.access_time, time),
            ]
          ],

        ),
      ],
    ),
  );
}

Widget buildDatePill(IconData icon, String text) {
  return Container(
    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
    decoration: BoxDecoration(
      color: Colors.white.withOpacity(0.15),
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      children: [
        Icon(icon, color: Colors.white, size: 16),
        const SizedBox(width: 6),
        Text(text,
            style: const TextStyle(color: Colors.white, fontSize: 13)),
      ],
    ),
  );
}