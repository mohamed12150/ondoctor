class Schedule {
  final String dayOfWeek;
  final String startTime;
  final String endTime;
  final bool isActive;
  final List<String> slots;

  Schedule({
    required this.dayOfWeek,
    required this.startTime,
    required this.endTime,
    required this.isActive,
    required this.slots,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) {
    return Schedule(
      dayOfWeek: json['day_of_week'] ?? '',
      startTime: json['start_time'] ?? '',
      endTime: json['end_time'] ?? '',
      isActive: json['is_active'] ?? false,
      slots: List<String>.from(json['slots'] ?? []),
    );
  }
}
