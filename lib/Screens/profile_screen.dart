import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ondoctor/Screens/Auth/Login_page.dart';
import 'package:ondoctor/Screens/home.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? userName;
  String? email;
  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  File? _profileImage;

  Future<void> loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      userName = prefs.getString('userName') ?? '';
      email = prefs.getString('email') ?? '';
    });
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _changeAvatar() {
    _pickImage();
  }

  void _openChronicDiseasesScreen() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => const ChronicDiseasesScreen()),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('تأكيد تسجيل الخروج'),
            content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('لا'),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop();
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.remove('token');
                  await prefs.remove('userName');
                  await prefs.remove('email');
                  Get.snackbar(
                    'تم تسجيل الخروج',
                    'يرجى تسجيل الدخول مرة أخرى',
                    colorText: Colors.black,
                  );
                  Get.offAllNamed('/login');
                },
                child: const Text('نعم'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            themeController.isDarkMode ? Colors.black : Colors.grey[50],

        appBar: AppBar(
          title: Text(
            'الملف الشخصي'.tr,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor:
              themeController.isDarkMode ? Colors.grey[900] : Colors.white,

          foregroundColor: Colors.deepPurple,
        ),
        body: RefreshIndicator(
          onRefresh: () async => loadUserData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Profile Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color:
                          themeController.isDarkMode
                              ? Colors.grey[800]
                              : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 10,
                          spreadRadius: 2,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        // Profile Image
                        GestureDetector(
                          onTap: _changeAvatar,
                          child: Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Container(
                                width: 90,
                                height: 90,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color:
                                      themeController.isDarkMode
                                          ? Colors.grey
                                          : Colors.grey,
                                  image:
                                      _profileImage != null
                                          ? DecorationImage(
                                            image: FileImage(_profileImage!),
                                            fit: BoxFit.cover,
                                          )
                                          : null,
                                ),
                                child:
                                    _profileImage == null
                                        ? Icon(
                                          Icons.person,
                                          size: 40,
                                          color:
                                              themeController.isDarkMode
                                                  ? Colors.deepPurple
                                                  : Colors.white,
                                        )
                                        : null,
                              ),
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.deepPurple,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 2,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.edit,
                                  size: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userName ?? 'اسم المستخدم',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      themeController.isDarkMode
                                          ? Colors.white
                                          : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                email ?? 'البريد الإلكتروني',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.deepPurple[50],
                                  foregroundColor: Colors.deepPurple,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                ),
                                child: Text(
                                  'تعديل الملف الشخصي'.tr,
                                  style: TextStyle(fontSize: 12),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 30),

                  // Settings Sections
                  _buildSettingsSection(
                    title: "الإعدادات العامة".tr,
                    children: [
                      _buildSettingsTile(
                        icon: Icons.local_hospital_outlined,
                        title: "الأمراض المزمنة".tr,
                        subtitle: "إدارة الأمراض المزمنة".tr,
                        onTap: _openChronicDiseasesScreen,
                      ),
                      _buildSettingsTile(
                        icon: Icons.workspace_premium_outlined,
                        title: "الاشتراك".tr,
                        subtitle: "بريميوم - ينتهي في 2025-12-31".tr,
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  _buildSettingsSection(
                    title: "إعدادات الحساب".tr,
                    children: [
                      _buildSettingsTile(
                        icon: Icons.lock_outline,
                        title: "تغيير كلمة المرور".tr,
                      ),
                      _buildSettingsTile(
                        icon: Icons.support_agent,
                        title: "الدعم الفني".tr,
                      ),
                        _buildSettingsTile(
                        icon: Icons.logout,
                        title: "تسجيل الخروج".tr,
                        subtitle: "تسجيل الخروج من الحساب".tr,
                        iconColor: Colors.red,
                        textColor: Colors.red,
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                          builder: (context) => const LoginPage(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: themeController.isDarkMode ? Colors.white : Colors.black,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: themeController.isDarkMode ? Colors.grey[800] : Colors.white,
            borderRadius: BorderRadius.circular(15),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.05),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    String? subtitle,
    Color? iconColor,
    Color? textColor,
    void Function()? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color:
                    themeController.isDarkMode
                        ? Colors.grey
                        : Colors.deepPurple.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color:
                    themeController.isDarkMode
                        ? Colors.black
                        : Colors.deepPurple,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color:
                          themeController.isDarkMode
                              ? Colors.white
                              : Colors.black87,
                    ),
                  ),
                  if (subtitle != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        subtitle,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 16,
              color: Colors.grey[400],
            ),
          ],
        ),
      ),
    );
  }
}

class ChronicDiseasesScreen extends StatefulWidget {
  const ChronicDiseasesScreen({super.key});

  @override
  State<ChronicDiseasesScreen> createState() => _ChronicDiseasesScreenState();
}

class _ChronicDiseasesScreenState extends State<ChronicDiseasesScreen> {
  final TextEditingController _diseaseController = TextEditingController();
  final List<String> _diseases = [];

  void _addDisease() {
    final text = _diseaseController.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _diseases.add(text);
        _diseaseController.clear();
      });
    }
  }

  void _removeDisease(int index) {
    setState(() {
      _diseases.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("الأمراض المزمنة"),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Add Disease Field
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _diseaseController,
                    decoration: InputDecoration(
                      hintText: "أدخل اسم المرض...",
                      filled: true,
                      fillColor: Colors.grey[100],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addDisease,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(14),
                  ),
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Diseases List
            Expanded(
              child:
                  _diseases.isEmpty
                      ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.medical_services_outlined,
                              size: 50,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "لا توجد أمراض مسجلة",
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                      : ListView.builder(
                        itemCount: _diseases.length,
                        itemBuilder:
                            (context, index) => Card(
                              margin: const EdgeInsets.only(bottom: 10),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: ListTile(
                                leading: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurple.withOpacity(0.1),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.medical_services_outlined,
                                    color: Colors.deepPurple,
                                  ),
                                ),
                                title: Text(_diseases[index]),
                                trailing: IconButton(
                                  icon: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.red,
                                  ),
                                  onPressed: () => _removeDisease(index),
                                ),
                              ),
                            ),
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
