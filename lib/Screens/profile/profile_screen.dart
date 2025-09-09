import 'package:flutter/material.dart';
// import 'package:ondoctor/screens/profile/profile_controller.dart';
import 'package:ondoctor/Screens/profile/widgets/profile_card.dart';
import 'package:ondoctor/screens/home.dart';
import 'package:ondoctor/screens/profile/widgets/settings_tile.dart';
import 'package:get/get.dart';
import '../../controllers/profile_controller.dart';
import 'widgets/settings_section.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final profileController = Get.find<ProfileController>();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();



  @override
  void initState() {
    super.initState();
    profileController.loadUserData();

      // userName = prefs.getString('userName') ?? '';

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor:
            themeController.isDarkMode ? Colors.black87 : Colors.white,
        appBar: AppBar(
          title: Text(
            'الملف الشخصي'.tr,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor:
              themeController.isDarkMode ? Colors.grey[900] : Colors.white,
          foregroundColor: Colors.deepPurple,
        ),
        body: RefreshIndicator(
          onRefresh: () async => profileController.loadUserData(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  GetBuilder<ProfileController>(
                    builder: (controller) => ProfileCard(
                      controller: controller,
                      onAvatarChanged: controller.changeAvatar,
                    ),
                  ),

                  const SizedBox(height: 30),
                  SettingsSection(
                    title: "الإعدادات العامة".tr,
                    children: [
                      SettingsTile(
                        icon: Icons.local_hospital_outlined,
                        title: "الأمراض المزمنة".tr,
                        subtitle: "إدارة الأمراض المزمنة".tr,
                        onTap: () => Get.toNamed('/chronic-diseases'),
                      ),
                      SettingsTile(
                        icon: Icons.workspace_premium_outlined,
                        title: "الاشتراك".tr,
                        subtitle: "بريميوم - ينتهي في 2025-12-31".tr,
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.workspace_premium,
                                      size: 50,
                                      color: Colors.deepPurple,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "خطة الاشتراك".tr,
                                      style:
                                          Theme.of(
                                            context,
                                          ).textTheme.titleLarge,
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      "بريميوم يتيح لك ميزات إضافية مثل كذا وكذا..."
                                          .tr,
                                      textAlign: TextAlign.center,
                                    ),
                                    const SizedBox(height: 20),
                                    ElevatedButton.icon(
                                      onPressed: () {
                                        // تنفيذ إجراء مثل شراء أو ترقية
                                        Navigator.pop(context);
                                      },
                                      icon: const Icon(Icons.upgrade),
                                      label: Text("ترقية الآن".tr),
                                    ),
                                    const SizedBox(height: 10),
                                  ],
                                ),
                              );
                            },
                          );
                        },
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
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true, // هذا هو المهم
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20),
                              ),
                            ),
                            builder: (context) {
                              return Padding(
                                padding: EdgeInsets.only(
                                  left: 16,
                                  right: 16,
                                  top: 16,
                                  bottom:
                                      MediaQuery.of(context).viewInsets.bottom +
                                      16, // تحريك مع الكيبورد
                                ),
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // محتوى Bottom Sheet مثل TextFields وأزرار...
                                      Text(
                                        "تغيير كلمة المرور".tr,
                                        style:
                                            Theme.of(
                                              context,
                                            ).textTheme.titleLarge,
                                      ),
                                      const SizedBox(height: 20),
                                      TextField(
                                        controller: currentPasswordController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          labelText: "كلمة المرور الحالية".tr,
                                          border: const OutlineInputBorder(),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      TextField(
                                        controller: newPasswordController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          labelText: "كلمة المرور الجديدة".tr,
                                          border: const OutlineInputBorder(),
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      TextField(
                                        controller: confirmPasswordController,
                                        obscureText: true,
                                        decoration: InputDecoration(
                                          labelText: "تأكيد كلمة المرور".tr,
                                          border: const OutlineInputBorder(),
                                        ),
                                      ),
                                      const SizedBox(height: 20),
                                      Center(
                                        child: ElevatedButton.icon(
                                          onPressed: () async {
                                            final current = currentPasswordController.text.trim();
                                            final newPass = newPasswordController.text.trim();
                                            final confirm = confirmPasswordController.text.trim();

                                            if (newPass != confirm) {
                                              Get.snackbar('خطأ', 'كلمة المرور الجديدة غير متطابقة');
                                              return;
                                            }

                                            try {
                                              await profileController.changePassword(
                                                currentPassword: current,
                                                newPassword: newPass,
                                                confirmPassword: confirm,
                                              );


                                              Navigator.pop(context);
                                              Get.snackbar('تم', 'تم تغيير كلمة المرور بنجاح');
                                            } catch (e) {
                                              Get.snackbar('خطأ', e.toString(),
                                                backgroundColor: Colors.red.shade100,
                                              );
                                            }
                                          },
                                          icon: const Icon(Icons.lock_reset),
                                          label: Text("حفظ التغييرات".tr),
                                        ),

                                      ),

                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
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
                        onTap:
                            () => profileController.showLogoutConfirmation(context),
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
