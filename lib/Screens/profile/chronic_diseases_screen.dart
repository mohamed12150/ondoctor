import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/medical_condition_controller.dart';
import '../../models/MedicalCondition.dart';

class ChronicDiseasesScreen extends StatefulWidget {
  const ChronicDiseasesScreen({super.key});

  @override
  State<ChronicDiseasesScreen> createState() => _ChronicDiseasesScreenState();
}

class _ChronicDiseasesScreenState extends State<ChronicDiseasesScreen> {
  final TextEditingController _diseaseController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();
  final controller = Get.find<MedicalConditionController>();


  @override
  void initState() {
    super.initState();
    controller.fetchConditions();
  }

  void _showAddDialog() {
    _diseaseController.clear();
    _notesController.clear();


    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor:  Colors.grey[900] ,
        title: Text(
          'إضافة مرض',
          style: TextStyle(
            color:  Colors.black,
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _diseaseController,
              decoration: const InputDecoration(labelText: 'اسم المرض'),
            ),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'ملاحظات'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              await controller.addCondition(
                _diseaseController.text.trim(),
                _notesController.text.trim(),
              );
              Navigator.pop(context);
            },
            child: const Text('حفظ'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(MedicalCondition condition) {
    _diseaseController.text = condition.name;
    _notesController.text = condition.notes ?? '';

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('تعديل المرض'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _diseaseController,
              decoration: const InputDecoration(labelText: 'اسم المرض'),
            ),
            TextField(
              controller: _notesController,
              decoration: const InputDecoration(labelText: 'ملاحظات'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              await controller.updateCondition(
                id: condition.id,
                name: _diseaseController.text.trim(),
                notes: _notesController.text.trim(),
              );
              Navigator.pop(context);
            },
            child: const Text('تحديث'),
          ),
        ],
      ),
    );
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
            ElevatedButton.icon(
              onPressed: _showAddDialog,
              icon: const Icon(Icons.add),
              label:  Text("إضافة مرض"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white24,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (controller.conditions.isEmpty) {
                  return const Center(
                    child: Text("لا توجد أمراض مسجلة"),
                  );
                }

                return ListView.builder(
                  itemCount: controller.conditions.length,
                  itemBuilder: (context, index) {
                    final condition = controller.conditions[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        leading: const Icon(Icons.medical_services_outlined, color: Colors.deepPurple),
                        title: Text(condition.name),
                        subtitle: condition.notes != null && condition.notes!.isNotEmpty
                            ? Text(condition.notes!)
                            : null,
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.orange),
                              onPressed: () => _showEditDialog(condition),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red),
                              onPressed: () => controller.deleteCondition(condition.id),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            )
          ],
        ),
      ),
    );
  }
}
