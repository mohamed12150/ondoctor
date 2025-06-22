
import 'package:flutter/material.dart';
import 'package:ondoctor/screens/profile/profile_controller.dart';
import 'package:ondoctor/Screens/profile/widgets/profile_card.dart';

import 'package:ondoctor/screens/home.dart';
import 'package:ondoctor/screens/profile/widgets/settings_tile.dart';

import 'package:get/get.dart';

import 'widgets/settings_section.dart';



class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController _controller = ProfileController();

  @override
  void initState() {
    super.initState();
    _controller.loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:  themeController.isDarkMode ? Colors.black87 : Colors.white,
        appBar: AppBar(
          title: Text(
            'الملف الشخصي'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: themeController.isDarkMode ? Colors.grey[900] : Colors.white,
          foregroundColor: Colors.deepPurple,
        ),
        body: RefreshIndicator(
          onRefresh: () async => _controller.loadUserData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  ProfileCard(
                    controller: _controller,
                    onAvatarChanged: _controller.changeAvatar,
                  ),
                  const SizedBox(height: 30),
                  SettingsSection(
                    title: "الإعدادات العامة".tr,
                    children: [
                      SettingsTile(
                        icon: Icons.local_hospital_outlined,
                        title: "الأمراض المزمنة".tr,
                        subtitle: "إدارة الأمراض المزمنة".tr,
                        onTap: () => _controller.openChronicDiseasesScreen(context),
                      ),
                      SettingsTile(
                        icon: Icons.workspace_premium_outlined,
                        title: "الاشتراك".tr,
                        subtitle: "بريميوم - ينتهي في 2025-12-31".tr,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SettingsSection(
                    title: "إعدادات الحساب".tr,
                    children: [
                      SettingsTile(
                        icon: Icons.lock_outline,
                        title: "تغيير كلمة المرور".tr,
                      ),
                      SettingsTile(
                        icon: Icons.support_agent,
                        title: "الدعم الفني".tr,
                      ),
                      SettingsTile(
                        icon: Icons.logout,
                        title: "تسجيل الخروج".tr,
                        subtitle: "تسجيل الخروج من الحساب".tr,
                        iconColor: Colors.red,
                        textColor: Colors.red,
                        onTap: () => _controller.showLogoutConfirmation(context),
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
}