import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ondoctor/Screens/home.dart';

class NotificationPopup extends StatelessWidget {
  final List<String> notifications;

  const NotificationPopup({super.key, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Container(
          width: 280,
          height: 320,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: themeController.isDarkMode ? const Color.fromARGB(255, 63, 63, 63) : Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'الإشعارات',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.separated(
                    itemCount: notifications.length,
                    separatorBuilder: (_, __) => const Divider(height: 8),
                    itemBuilder: (context, index) {
                      return ListTile(
                        leading: const Icon(Icons.notifications),
                        title: Text(
                          notifications[index],
                          style: const TextStyle(fontSize: 14),
                        ),
                        onTap: () => Get.back(), // يغلق النافذة عند الضغط
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
