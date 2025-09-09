import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondoctor/models/DoctorDetailsModel.dart';
import '../controllers/doctor_details_controller.dart';

class DoctorDetailsPage extends StatefulWidget {
  final int doctorId; // 🟢 استقبال id الدكتور من الراوت

  const DoctorDetailsPage({super.key, required this.doctorId});

  @override
  State<DoctorDetailsPage> createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  final controller = Get.put(DoctorDetailsController());

  final Color primaryColor = const Color(0xFF8255FF);

  String? selectedDay;
  String? selectedTime;
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();
    controller.fetchDoctor(widget.doctorId); // 🟢 استدعاء API
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border, color: Colors.amber),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.doctor.value == null) {
          return const Center(
              child: Text("لم يتم تحميل بيانات الدكتور",
                  style: TextStyle(color: Colors.red)));
        }

        final DoctorDetailsModel doctor = controller.doctor.value!;
        debugPrint("✅ عرض بيانات الدكتور: ${doctor.name}");

        return Stack(
          children: [
            // الخلفية بالصورة
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: MediaQuery.of(context).size.height * 0.45,
              child: Container(
                color: const Color(0xB37744C6),
                child: Container(
                  margin: const EdgeInsets.only(top: 40),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: doctor.profileImage != null &&
                          doctor.profileImage!.isNotEmpty
                          ? NetworkImage(doctor.fullImageUrl)
                          : const AssetImage("assets/images/default_doctor.png")
                      as ImageProvider,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
            ),

            // المحتوى الأبيض السفلي
            Positioned(
              top: MediaQuery.of(context).size.height * 0.42,
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(32)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, -2),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Column(
                          children: [
                            Text("Dr. ${doctor.name}",
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Text(
                              doctor.categories.map((c) {
                                final lang =
                                    Get.locale?.languageCode ?? 'ar';
                                return lang == 'en'
                                    ? c.nameEn
                                    : c.nameAr;
                              }).join(", "),
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 14.5),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // التابز
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                            onTap: () => setState(() => selectedTab = 0),
                            child: _tabButton("Schedule",
                                selected: selectedTab == 0),
                          ),
                          const SizedBox(width: 12),
                          GestureDetector(
                            onTap: () => setState(() => selectedTab = 1),
                            child: _tabButton("About Doctor",
                                selected: selectedTab == 1),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // المحتوى حسب التاب
                      selectedTab == 0
                          ? _buildScheduleSection(doctor)
                          : _buildAboutSection(doctor),
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  /// 🟢 قسم الجدول (الحجز) - باستخدام بيانات الـ API
  Widget _buildScheduleSection(DoctorDetailsModel doctor) {
    // الأيام من API
    final days = doctor.schedules.map((s) => s.dayOfWeek).toList();

    // الأوقات بناءً على اليوم المحدد
    final slotsForSelectedDay = doctor.schedules
        .firstWhereOrNull((s) => s.dayOfWeek == selectedDay)
        ?.slots ??
        [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("Select Day",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 12),

        // الأيام
        SizedBox(
          height: 40,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            itemBuilder: (context, index) {
              final day = days[index];
              final isSelected = selectedDay == day;
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: GestureDetector(
                  onTap: () => setState(() {
                    selectedDay = day;
                    selectedTime = null;
                  }),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? primaryColor : const Color(0xFFF1F1F4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      day,
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 24),
        const Text("Select Time",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        const SizedBox(height: 12),

        // الساعات
        if (slotsForSelectedDay.isEmpty)
          Center(
            child: const Text(" لا توجد مواعيد لهذا اليوم",
                style: TextStyle(color: Colors.red)),
          )
        else
          SizedBox(
            height: 40,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: slotsForSelectedDay.length,
              itemBuilder: (context, index) {
                final time = slotsForSelectedDay[index];
                final isSelected = selectedTime == time;
                return Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: GestureDetector(
                    onTap: () => setState(() => selectedTime = time),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected ? primaryColor : const Color(0xFFF1F1F4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        time,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

        const SizedBox(height: 115),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: (selectedDay == null || selectedTime == null )
                ? null
                : () {
              print(" ✅ day {$selectedDay} ,times {$selectedTime} doctor_id {${doctor.id}} perhoure {${doctor.pricePerHour}");
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("تم الحجز"),
                  content: Text(
                      "تم حجز الموعد يوم $selectedDay الساعة $selectedTime"),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text("موافق"),
                    ),
                  ],
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: primaryColor,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: const Text("Book Appointment",
                style: TextStyle(color: Colors.white, fontSize: 16)),
          ),
        )
      ],
    );
  }

  /// قسم الـ About Doctor
  Widget _buildAboutSection(DoctorDetailsModel doctor) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.0),
      child: Text(
        doctor.dec ?? "لا يوجد وصف",
        style: const TextStyle(fontSize: 14, color: Colors.black87, height: 1.5),
      ),
    );
  }

  /// زر التاب
  Widget _tabButton(String title, {bool selected = false}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
      decoration: BoxDecoration(
        color: selected ? primaryColor : const Color(0xFFF1F1F4),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
