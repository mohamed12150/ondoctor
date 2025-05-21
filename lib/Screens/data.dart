
//الملف ده فيه بيانات وهمية عشان نستخدمها في التطبيق



final List<Map<String, dynamic>> specialties = [
  {
    'name': 'Cardiology',
    'iconPath': 'assets/images/icons8-cardiology-48.svg',
  },
  {
    'name': 'Dentistry',
    'iconPath': 'assets/images/icons8-neurology-32.svg',
  },
  {
    'name': 'Neurology',
    'iconPath': 'assets/images/dentist-svgrepo-com.svg',
  },
  {
    'name': 'Dermatology',
    'iconPath': 'assets/images/icons8-ultrasound-machine-100.svg',
  },
  {
    'name': 'Pediatrics',
    'iconPath': 'assets/images/icons8-ophthalmology-100.svg',
  },
];

final Map<String, List<String>> doctorsBySpecialty = {
  'Cardiology': ['Dr. Ahmed Ali', 'Dr. Sara Hassan'],
  'Dentistry': ['Dr. Salma Omar', 'Dr. Tarek Nabil'],
  'Neurology': ['Dr. Mohamed Farid', 'Dr. Lina Samir'],
  'Dermatology': ['Dr. Youssef Adel', 'Dr. Rania Kamel'],
  'Pediatrics': ['Dr. Omar Mahmoud', 'Dr. Dina Farouk'],
};
