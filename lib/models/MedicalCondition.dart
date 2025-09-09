class MedicalCondition {
  final int id;
  final String name;
  final String? notes;

  MedicalCondition({
    required this.id,
    required this.name,
    this.notes,
  });

  factory MedicalCondition.fromJson(Map<String, dynamic> json) {
    return MedicalCondition(
      id: json['id'],
      name: json['name'],
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'notes': notes,
    };
  }
}
