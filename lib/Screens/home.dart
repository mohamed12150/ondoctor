import 'package:curved_labeled_navigation_bar/curved_navigation_bar.dart';
import 'package:curved_labeled_navigation_bar/curved_navigation_bar_item.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
// أضف هذه المكتبة
import 'package:lucide_icons/lucide_icons.dart';
import 'package:ondoctor/Screens/appointment.dart';

import 'package:ondoctor/Screens/list_doctors.dart';

import 'package:ondoctor/Screens/messages/chat_list.dart';
import 'package:ondoctor/Screens/nativation_page.dart';
import 'package:ondoctor/Screens/profile/profile_screen.dart';

import 'package:ondoctor/controllers/theme_controller.dart';
import 'package:ondoctor/widgets//category_item.dart';
import 'package:ondoctor/Screens/doctor_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:card_swiper/card_swiper.dart';
import '../controllers/chat_room_controller.dart';
import '../controllers/doctor_controller.dart';
import '../controllers/category_controller.dart';
import '../controllers/profile_controller.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

final themeController = Get.find<ThemeController>();
final isEnglish = Get.locale?.languageCode == 'en';

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
    GetBuilder<ChatRoomController>(
      init: ChatRoomController(),
      builder: (_) => ChatListScreen(),
    ),
    GetBuilder<ProfileController>(
      init: ProfileController(),
      builder: (_) => ProfileScreen(),
    ),
  ];


  void _onItemTapped(int index) async {
    if (index == 3 || index == 1 || index == 2) {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');

      if (token == null || token.isEmpty) {
        // لو ما مسجل دخول
        Get.snackbar(
          "تنبيه",
          "يجب تسجيل الدخول أولاً",
          backgroundColor: Colors.red.shade100,
          colorText: Colors.black,
          duration: const Duration(seconds: 2),
        );

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
      extendBody: true, // مهم لظهور الانحناء بشكل صحيح
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _selectedIndex,
        height: 70,
        backgroundColor: Colors.transparent,
        color:
            themeController.isDarkMode ? Colors.grey[900]! : Colors.grey[200]!,
        buttonBackgroundColor:
            themeController.isDarkMode ? Colors.white : Colors.deepPurple,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        items: List.generate(_icons.length, (index) {
          return CurvedNavigationBarItem(
            child: Icon(
              _icons[index],
              color: themeController.isDarkMode ? Colors.grey : Colors.black87,
            ),
            label: "", // تقدر تضيف اسم الصفحة هنا لو حبيت
          );
        }),
        onTap: (index) {
          setState(() {
            _onItemTapped(index);
          });
        },
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
  String role = '';
  // للتحكم في TextField
  final TextEditingController _searchController = TextEditingController();
  final ThemeController themeController = Get.find<ThemeController>();

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
      filteredDoctors =
          doctors.where((doctor) {
            final nameLower = doctor["name"].toLowerCase();
            final specialtyLower = doctor["specialty"].toLowerCase();
            return nameLower.contains(searchText) ||
                specialtyLower.contains(searchText);
          }).toList();
    });
  }

  void loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
       role =prefs.getString('role') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          themeController.isDarkMode ? Colors.black87 : Colors.white,
      appBar: AppBar(
        backgroundColor:
            themeController.isDarkMode ? Colors.grey[900] : Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.notifications_none,
            color: themeController.isDarkMode ? Colors.white : Colors.black87,
          ),
          onPressed: () {
            Get.dialog(
              NotificationPopup(
                notifications: List.generate(15, (i) => 'إشعار رقم ${i + 1}'),
              ),
              barrierColor: Colors.black.withOpacity(0.3),
              barrierDismissible: true,
            );
            // TODO: افتح صفحة الإشعارات
          },
        ),
        title: Text(
          "Home".tr,
          style: TextStyle(
            color: themeController.isDarkMode ? Colors.white : Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 22,
            fontFamily: "Cairo",
          ),
        ),
        centerTitle: true,
        actions: [
          Obx(
            () => IconButton(
              icon: Icon(
                themeController.isDarkMode ? Icons.dark_mode : Icons.light_mode,
                color:
                    themeController.isDarkMode ? Colors.white : Colors.black87,
              ),
              onPressed: themeController.toggleTheme,
              tooltip: isEnglish ? "Toggle Theme" : "تغيير الوضع",
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  themeController.isDarkMode ? Colors.deepPurple : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: const BorderSide(color: Colors.black, width: 1),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
              minimumSize: const Size(40, 30),
              elevation: 1,
            ),
            onPressed: () {
              final newLocale =
                  Get.locale?.languageCode == 'en'
                      ? const Locale('ar')
                      : const Locale('en');
              Get.updateLocale(newLocale);
              print("Language changed to: ${newLocale.languageCode}");
            },
            child: Text(
              "English".tr,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    userName.isNotEmpty ? "Hello, $userName" : "Hello".tr,
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color:
                          themeController.isDarkMode
                              ? Colors.white
                              : Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 5),
                ],
              ),
              const SizedBox(height: 20),

              // Search box will be added here
              if (role != 'doctor')
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: "Search doctors...".tr,
                    border: InputBorder.none,
                    icon: const Icon(Icons.search),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Divider(
                color:
                    themeController.isDarkMode
                        ? Colors.white70
                        : Colors.black26,
                thickness: 1,
              ),
              if (role != 'doctor')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Departments".tr,
                    style: TextStyle(
                      color:
                          themeController.isDarkMode
                              ? Colors.white
                              : Colors.black87,
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DoctorsListPage(doctors: []),
                        ),
                      );
                    },
                    child: Text(
                      "See All".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            themeController.isDarkMode
                                ? Colors.white
                                : Colors
                                    .purple
                                    .shade700, // استخدام اللون البنفسجي
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              if (role != 'doctor')
                Obx(() {
                if (categoryController.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (categoryController.categories.isEmpty) {
                  return Center(child: Text("لا توجد تصنيفات متاحة".tr));
                }

                return SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: categoryController.categories.length,
                    itemBuilder: (context, index) {
                      final category = categoryController.categories[index];

                      return CategoryItem(
                        title: category.getLocalizedName(),
                        iconWidget: Image.network(
                          category.iconUrl,
                          height: 35,
                          width: 30,
                          fit: BoxFit.contain,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return const SizedBox(
                              height: 500,
                              width: 30,
                              child: Center(
                                child: CircularProgressIndicator(
                                  strokeWidth: 5,
                                ),
                              ),
                            );
                          },
                          errorBuilder:
                              (_, __, ___) => const Icon(Icons.category),
                        ),
                        onTap: () {
                          print(
                            'Category Tapped: id=${category.id}, name=${category.getLocalizedName()}, iconUrl=${category.iconUrl}',
                          );

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

              const SizedBox(height: 10),
              if (role != 'doctor')
              Text(
                "Upcoming Schedule".tr,
                style: TextStyle(
                  color:
                      themeController.isDarkMode
                          ? Colors.white
                          : Colors.black87,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 10),
              if (role != 'doctor')
              buildStackedVerticalCards(), // ✅ هذا هو الويدجت الصحيح

              const SizedBox(height: 30),
              if (role != 'doctor')
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Popular Doctors".tr,
                    style: TextStyle(
                      color:
                          themeController.isDarkMode
                              ? Colors.white
                              : Colors.black87,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Get.to(
                        () => DoctorsListPage(
                          doctors: doctorController.filteredDoctors,
                        ),
                      );
                    },
                    child: Text(
                      "See All".tr,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color:
                            themeController.isDarkMode
                                ? Colors.white
                                : Colors
                                    .purple
                                    .shade700, // استخدام اللون البنفسجي
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (role != 'doctor')
              // عرض الأطباء حسب الفلترة
              Obx(() {
                return Column(
                  children:
                      doctorController.filteredDoctors.map((doctor) {
                        return GestureDetector(
                          onTap: () {
                            Get.toNamed('/appointment', arguments: doctor);
                          },
                          child: DoctorCard(doctor: doctor),
                        );
                      }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}

Widget buildStackedVerticalCards() {
  final List<Map<String, dynamic>> scheduleList = [
    {
      "name": "Dr.MHmd",
      "specialty": "Dentist",
      "date": "June 12, 9:30 AM",
      "image": "assets/images/a.jpg",
    },
    {
      "name": "Dr. Sarah Connor",
      "specialty": "Cardiologist",
      "date": "June 15, 11:00 AM",
      "image": "assets/images/a.jpg",
    },
    {
      "name": "Dr. Ahmed",
      "specialty": "Neurologist",
      "date": "June 18, 2:00 PM",
      "image": "assets/images/a.jpg",
    },
  ];

  return SizedBox(
    height: 220, // زيادة الارتفاع لعرض جزء من البطاقة التالية
    child: Swiper(
      itemCount: scheduleList.length,
      itemWidth:
          MediaQueryData.fromView(WidgetsBinding.instance.window).size.width *
          0.9,
      itemHeight: 180,
      layout: SwiperLayout.STACK,
      scrollDirection: Axis.vertical,
      loop: true,
      duration: 600,
      viewportFraction:
          0.65, // لتقليل المساحة المحتلة لكل كرت وإظهار جزء من الكرت الذي يليه
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
        colors:
            themeController.isDarkMode
                ? [Colors.purple.shade600, Colors.purpleAccent.shade100]
                : [Colors.purple.shade600, Colors.purpleAccent.shade100],
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
              radius: 35,
              backgroundImage: AssetImage(schedule["image"]),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    schedule["name"],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    schedule["specialty"],
                    style: TextStyle(
                      color:
                          themeController.isDarkMode
                              ? Colors.grey[900]
                              : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(LucideIcons.messageCircle, color: Colors.white70),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween, // مثل justify-content: center;

          children: [
            buildDatePill(Icons.calendar_today, date),

            if (time.isNotEmpty) ...[
              const SizedBox(width: 1),
              buildDatePill(Icons.access_time, time),
            ],
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
      color: themeController.isDarkMode ? Colors.black : Colors.white,
      borderRadius: BorderRadius.circular(30),
    ),
    child: Row(
      children: [
        Icon(
          icon,
          color: themeController.isDarkMode ? Colors.white : Colors.black87,
          size: 16,
        ),
        const SizedBox(width: 6),
        Text(
          text.tr,
          style: TextStyle(
            color: themeController.isDarkMode ? Colors.white : Colors.black87,
            fontSize: 13,
          ),
        ),
      ],
    ),
  );
}
