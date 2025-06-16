import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondoctor/Screens/Auth/siginup.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _controller = PageController();
  int _currentPage = 0;

  final List<Map<String, String>> _pages = [
    {
      "title": "  Doctor مرحبًا بك في ",
      "subtitle": "منصة استشارات طبية سهلة وآمنة",
      "image": "assets/images/3725530.jpg",
    },
    {
      "title": "احجز بسهولة",
      "subtitle": "اختر تخصصك والطبيب المناسب واحجز موعدك فورًا",
      "image": "assets/images/3725530.jpg",
    },
    {
      "title": "تابع ملفك الطبي",
      "subtitle": "راجع محادثاتك السابقة وتوصيات الأطباء",
      "image": "assets/images/3725530.jpg",
    },
  ];

  void _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("seen", true); // نستخدم نفس المفتاح اللي استخدمناه في main.dart

    Get.offAllNamed('/home'); // أو: Get.offAll(() => Home());
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple,
      body: Stack(
        children: [
          PageView.builder(
            controller: _controller,
            itemCount: _pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) {
              final page = _pages[index];
              return Column(
                children: [
                  // الجزء العلوي المقوس بالدائرة البيضاء مع الصورة في المنتصف
                  TopHalfCircle(imagePath: page["image"]!),

                  SizedBox(height: 40),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: Column(
                      children: [
                        Text(
                          page["title"]!,
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 15),
                        Text(
                          page["subtitle"]!,
                          style: TextStyle(fontSize: 16, color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 40),
                        if (index == _pages.length - 1)
                          ElevatedButton(
                            onPressed: _finishOnboarding,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                            ),
                            child: Text(
                              "ابدأ الآن",
                              style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          // زر "تخطي"
          Positioned(
            top: 50,
            right: 20,
            child: TextButton(
              onPressed: _finishOnboarding,
              child: Text(
                "تخطي",
                style: TextStyle(color: Colors.deepPurple, fontSize: 16),
              ),
            ),
          ),

          // نقاط التقدم
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _pages.length,
                (index) => AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  width: _currentPage == index ? 16 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index
                        ? Colors.white
                        : Colors.white54,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// الكلاسر الخاص بالشكل المقوس في الأعلى
class TopHalfCircle extends StatelessWidget {
  final String imagePath;

  const TopHalfCircle({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return ClipPath(
      clipper: BottomCurveClipper(),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.56,
        color: Colors.white,
        width: double.infinity,
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover, 
        ),
      ),
    );
  }
}



class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height - 60); // ابدأ من اليسار عند الارتفاع

    path.quadraticBezierTo(
      size.width / 2, size.height, // نقطة التحكم للمنحنى
      size.width, size.height - 60, // نهاية الخط الأيمن
    );

    path.lineTo(size.width, 0); // مباشرة للأعلى على اليمين
    path.lineTo(0, 0); // خط أعلى للشمال
    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
