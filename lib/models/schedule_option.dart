import 'package:schedule_builder/models/models.dart';

class ScheduleOption {
  final int score;
  final List<ScheduleClass>? schedule;

  ScheduleOption({
    this.schedule,
    this.score = 0,
  });

  Set<String> generateSignatureSet() {
    Set<String> signature = {};
    for (ScheduleClass scheduleClass in schedule ?? []) {
      signature.add('${scheduleClass.subject}|${scheduleClass.identifier}');
    }
    return signature;
  }
}
