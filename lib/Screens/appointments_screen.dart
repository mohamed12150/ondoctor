import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ondoctor/Screens/home.dart';

class AppointmentPage extends StatefulWidget {
  const AppointmentPage({super.key});

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  bool showNewAppointment = true;

  final List<Map<String, dynamic>> specialties = [
    {
      'name': 'Cardiology',
      'iconPath': 'assets/images/icons8-cardiology-48.svg',
    },
    {'name': 'Dentistry', 'iconPath': 'assets/images/icons8-neurology-32.svg'},
    {'name': 'Neurology', 'iconPath': 'assets/images/dentist-svgrepo-com.svg'},
    {
      'name': 'Dermatology',
      'iconPath': 'assets/images/icons8-ultrasound-machine-100.svg',
    },
    {
      'name': 'Pediatrics',
      'iconPath': 'assets/images/icons8-ophthalmology-100.svg',
    },
  ];

  final List<Map<String, String>> previousAppointments = [
    {
      'doctor': 'Dr. Ahmed Ali',
      'specialty': 'Cardiology',
      'date': '2025-05-15',
      'Status': 'Canceled',
    },
    {
      'doctor': 'Dr. Salma Omar',
      'specialty': 'Dentistry',
      'date': '2025-04-28',
      'Status': 'Completed',
    },
    {
      'doctor': 'Dr. Mohamed Farid',
      'specialty': 'Neurology',
      'date': '2025-03-10',
      'Status': 'Pending',
    },
  ];

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Colors.green;
      case 'canceled':
        return Colors.red;
      case 'pending':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  IconData getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'completed':
        return Icons.check_circle;
      case 'canceled':
        return Icons.cancel;
      case 'pending':
        return Icons.hourglass_top;
      default:
        return Icons.help_outline;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        backgroundColor:
        // استخدام الكنترولر الخاص بالثيم
            themeController.isDarkMode ? Colors.grey[900] : Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showNewAppointment = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          showNewAppointment ? Colors.deepPurple : Colors.grey,
                      foregroundColor:
                          showNewAppointment ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: showNewAppointment ? 4 : 0,
                    ),
                    child: const Text('حجز جديد'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      setState(() {
                        showNewAppointment = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor:
                          !showNewAppointment
                              ? Colors.deepPurple
                              : Colors.grey[200],
                      foregroundColor:
                          !showNewAppointment ? Colors.white : Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: !showNewAppointment ? 4 : 0,
                    ),
                    child: const Text('حجوزاتي السابقة'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child:
                  showNewAppointment
                      ? ListView.builder(
                        itemCount: specialties.length,
                        itemBuilder: (context, index) {
                          final spec = specialties[index];
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                            color:
                                themeController.isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.white,

                            elevation: 0,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              leading: SvgPicture.asset(
                                spec['iconPath'],
                                width: 28,
                                height: 28,
                              ),
                              title: Text(
                                spec['name'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.arrow_forward_ios,
                                size: 18,
                              ),
                              onTap: () {
                                // الانتقال إلى صفحة اختيار الدكتور
                              },
                            ),
                          );
                        },
                      )
                      : ListView.builder(
                        itemCount: previousAppointments.length,
                        itemBuilder: (context, index) {
                          final appointment = previousAppointments[index];
                          final status = appointment['Status'] ?? 'Unknown';
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: const BorderSide(
                                color: Colors.black,
                                width: 1.5,
                              ),
                            ),
                            color:
                                themeController.isDarkMode
                                    ? Colors.grey[800]
                                    : Colors.white,
                            elevation: 0,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 10,
                              ),
                              leading: Icon(
                                getStatusIcon(status),
                                color: getStatusColor(status),
                                size: 32,
                              ),
                              title: Text(
                                appointment['doctor']!,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${appointment['specialty']} - ${appointment['date']}',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'الحالة: $status',
                                    style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600,
                                      color: getStatusColor(status),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
    );
  }
}
