class ScheduleClass {
  final int score;
  final String subject;
  final String identifier;
  final Map<String, List<DateTime>>? schedule;

  ScheduleClass({
    this.schedule,
    this.subject = '',
    this.score = 0,
    this.identifier = '0',
  });

  bool checkOverlaping(ScheduleClass scheduleClass) {
    bool isOverlapped = false;
    for (String day in ['Mo', 'Tu', 'We', 'Th', 'Fr']) {
      if ((schedule?.containsKey(day) ?? false) &&
          (scheduleClass.schedule?.containsKey(day) ?? false)) {
        final DateTime class1StartTime = schedule?[day]?[0] ?? DateTime.now();
        final DateTime class1EndTime = schedule?[day]?[1] ?? DateTime.now();
        final DateTime class2StartTime =
            scheduleClass.schedule?[day]?[0] ?? DateTime.now();
        final DateTime class2EndTime =
            scheduleClass.schedule?[day]?[1] ?? DateTime.now();
        if (!(class1StartTime.isAfter(class2EndTime) ||
            class1StartTime.isAtSameMomentAs(class2EndTime) ||
            class1EndTime.isBefore(class2StartTime) ||
            class1EndTime.isAtSameMomentAs(class2StartTime))) {
          isOverlapped = true;
        }
      }
    }
    return isOverlapped;
  }

  @override
  String toString() {
    final parsedSchedule = schedule?.entries
        .map((e) =>
            '${e.key}: ${e.value[0].hour} hrs. - ${e.value[1].hour} hrs.')
        .toList();
    return 'Score: $score | Identifier: $identifier | Subject: $subject | Schedule: $parsedSchedule';
  }
}
