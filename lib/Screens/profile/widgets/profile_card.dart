import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondoctor/Screens/home.dart';
// import 'package:ondoctor/screens/profile/profile_controller.dart';

import '../../../controllers/profile_controller.dart';

class ProfileCard extends StatelessWidget {
  final ProfileController controller;
  final VoidCallback onAvatarChanged;

  const ProfileCard({
    super.key,
    required this.controller,
    required this.onAvatarChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: themeController.isDarkMode ? Colors.grey[800] : Colors.white,
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
          GestureDetector(
            onTap: onAvatarChanged,
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 90,
                  height: 90,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: themeController.isDarkMode ? Colors.grey[800] : Colors.grey[300],
                    image: (controller.profileImage != null || controller.avatarUrl != null)
                        ? DecorationImage(
                      image: controller.profileImage != null
                          ? FileImage(controller.profileImage!)
                          : NetworkImage(controller.avatarUrl!) as ImageProvider,
                      fit: BoxFit.cover,
                    )
                        : null,
                  ),
                  child: (controller.profileImage == null && controller.avatarUrl == null)
                      ? Icon(
                    Icons.person,
                    size: 40,
                    color: themeController.isDarkMode
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
                  (controller.userName != null && controller.userName!.isNotEmpty)
                      ? controller.userName!
                      : 'اسم المستخدم',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: themeController.isDarkMode 
                        ? Colors.white 
                        : Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  controller.email ?? 'البريد الإلكتروني',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    final nameController = TextEditingController(text: controller.userName ?? '');
                    final emailController = TextEditingController(text: controller.email ?? '');

                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            top: 16,
                            left: 16,
                            right: 16,
                            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'تعديل الملف الشخصي',
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: nameController,
                                decoration:  InputDecoration(labelText: 'name'.tr),
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                controller: emailController,
                                decoration:  InputDecoration(labelText: 'email'.tr),
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton.icon(

                                label: Text('save_changes'.tr),

                                onPressed: () async {
                                  try {
                                    await controller.updateProfileData(
                                      name: nameController.text.trim(),
                                      email: emailController.text.trim(),
                                    );
                                    Navigator.pop(context);
                                    Get.snackbar('تم', 'تم تحديث البيانات بنجاح');
                                  } catch (e) {
                                    Get.snackbar(
                                      'خطأ',
                                      e.toString(),
                                      backgroundColor: Colors.red.shade100,
                                    );
                                  }
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple[50],
                    foregroundColor: Colors.deepPurple,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    textStyle: const TextStyle(fontSize: 12),
                    minimumSize: const Size(0, 32), // ⬅️ تحكم في الارتفاع بدقة
                  ),
                  child: Text('تعديل الملف الشخصي'.tr),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}