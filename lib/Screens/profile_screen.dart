import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
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
      MaterialPageRoute(
        builder: (context) => const ChronicDiseasesScreen(),
      ),
    );
  }

  void _showLogoutConfirmation() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تأكيد تسجيل الخروج'),
        content: const Text('هل أنت متأكد أنك تريد تسجيل الخروج؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(), // إلغاء
            child: const Text('لا'),
          ),
          TextButton(
            onPressed: () async  {
              Navigator.of(context).pop();
              final prefs = await SharedPreferences.getInstance();
              await prefs.remove('token');      // حذف التوكن
              await prefs.remove('userName');
              await prefs.remove('email'); //
              Get.snackbar(
              'تم تسجيل الخروج',
              'يرجى تسجيل الدخول مرة أخرى',
              colorText: Colors.black,
              );

              Get.offAllNamed('/login'); // توجيه لصفحة تسجيل الدخول
              },

            child: const Text('نعم'),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelection() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('اختر اللغة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('العربية'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم اختيار اللغة العربية')),
                );
              },
            ),
            ListTile(
              title: const Text('English'),
              onTap: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('English language selected')),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9FB),
        body: RefreshIndicator(
          onRefresh: () async => setState(() {}),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          spreadRadius: 2,
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            GestureDetector(
                              onTap: _changeAvatar,
                              child: CircleAvatar(
                                radius: 40,
                                backgroundColor: Colors.grey.shade200,
                                backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                                child: _profileImage == null
                                    ? const Icon(Icons.person, size: 45, color: Colors.grey)
                                    : null,
                              ),
                            ),
                            Positioned.fill(
                              child: Material(
                                color: Colors.black26,
                                shape: const CircleBorder(),
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: _changeAvatar,
                                  child: const Center(
                                    child: Icon(Icons.edit, color: Colors.white, size: 20),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                          (userName != null && userName!.isNotEmpty) ? userName! : 'اسم المستخدم',

                          style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                (email ?? '').isNotEmpty ? email! : 'البريد الإلكتروني',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    "General",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  _buildSettingsTile(Icons.local_hospital_outlined, "Chronic Diseases", subtitle: "None", onTap: _openChronicDiseasesScreen),
                  _buildSettingsTile(Icons.workspace_premium_outlined, "Subscription", subtitle: "Premium - expires on 2025-12-31"),

                  const SizedBox(height: 20),

                  const Text(
                    "Account",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),

                  _buildSettingsTile(Icons.language, "Language", onTap: _showLanguageSelection),
                  _buildSettingsTile(Icons.lock_outline, "Change Password"),
                  _buildSettingsTile(Icons.support_agent, "Support"),
                  _buildSettingsTile(Icons.logout, "Log Out", iconColor: Colors.red, textColor: Colors.red, onTap: _showLogoutConfirmation),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSettingsTile(IconData icon, String title, {String? subtitle, Color? iconColor, Color? textColor, void Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.symmetric(vertical: 6),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0.5,
        child: ListTile(
          leading: Icon(icon, color: iconColor ?? Colors.black87),
          title: Text(title, style: TextStyle(color: textColor ?? Colors.black, fontWeight: FontWeight.w500)),
          subtitle: subtitle != null ? Text(subtitle) : null,
          trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 16, color: Colors.grey),
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
        title: const Text("Chronic Diseases"),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        centerTitle: true,
      ),
      backgroundColor: const Color(0xFFF4F3FF),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Add a New Disease",
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.1),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _diseaseController,
                      decoration: InputDecoration(
                        hintText: "Type disease name...",
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                    elevation: 6,
                  ),
                  onPressed: _addDisease,
                  child: const Icon(Icons.add, size: 28, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 30),
            Text(
              "Your Diseases",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: _diseases.isEmpty
                  ? Center(
                      child: Text(
                        "No chronic diseases added yet.",
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.deepPurple.shade200,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _diseases.length,
                      itemBuilder: (context, index) => Card(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        elevation: 3,
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.deepPurple.shade100,
                            child: const Icon(Icons.local_hospital_outlined, color: Colors.deepPurple),
                          ),
                          title: Text(
                            _diseases[index],
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                            onPressed: () => _removeDisease(index),
                            tooltip: "Remove disease",
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
