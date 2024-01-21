import 'package:schedule_builder/models/models.dart';

class ScheduleBuilder {
  static List<List<ScheduleClass>> generatePermutations(
      List<ScheduleClass> elements) {
    List<List<ScheduleClass>> permutations = [];

    void permute(List<ScheduleClass> list, int start, int end) {
      if (start == end) {
        permutations.add(List.from(list));
        return;
      }

      for (int i = start; i <= end; i++) {
        ScheduleClass temp = list[start];
        list[start] = list[i];
        list[i] = temp;

        permute(list, start + 1, end);

        temp = list[start];
        list[start] = list[i];
        list[i] = temp;
      }
    }

    permute(elements, 0, elements.length - 1);
    return permutations;
  }

  static List<ScheduleClass> buildScheduleOption(
      List<ScheduleClass> allClasses) {
    Map<String, int> subjects = {};
    for (ScheduleClass option in allClasses) {
      if (!subjects.containsKey(option.subject)) {
        subjects[option.subject] = 0;
      }
    }

    List<ScheduleClass> option = [];

    Map<String, int> subjectsToFill = {...subjects};
    for (ScheduleClass scheduleClass in allClasses) {
      bool isOverlapped = false;
      if (subjectsToFill[scheduleClass.subject] == 1) {
        continue;
      }
      for (ScheduleClass optionClass in option) {
        isOverlapped = optionClass.checkOverlaping(scheduleClass);
        if (isOverlapped) {
          break;
        }
      }
      if (!isOverlapped) {
        subjectsToFill[scheduleClass.subject] = 1;
        option.add(scheduleClass);
      }
    }
    return option;
  }

  static void generateSchedule() {
    List<ScheduleClass> classes = [
      ScheduleClass(
        score: 10,
        subject: 'Lineal',
        identifier: '1',
        schedule: {
          'Mo': [DateTime(0, 0, 0, 7, 30), DateTime(0, 0, 0, 9)],
          'We': [DateTime(0, 0, 0, 7, 30), DateTime(0, 0, 0, 9)],
        },
      ),
      ScheduleClass(
        score: 8,
        subject: 'Lineal',
        identifier: '13',
        schedule: {
          'Mo': [DateTime(0, 0, 0, 11), DateTime(0, 0, 0, 13)],
          'We': [DateTime(0, 0, 0, 11), DateTime(0, 0, 0, 13)],
        },
      ),
      ScheduleClass(
        score: 10,
        subject: 'Integral',
        identifier: '18',
        schedule: {
          'We': [DateTime(0, 0, 0, 11), DateTime(0, 0, 0, 13)],
          'Fr': [DateTime(0, 0, 0, 11), DateTime(0, 0, 0, 13)],
        },
      ),
      ScheduleClass(
        score: 8,
        subject: 'Integral',
        identifier: '18',
        schedule: {
          'Tu': [DateTime(0, 0, 0, 15), DateTime(0, 0, 0, 17)],
          'Th': [DateTime(0, 0, 0, 15), DateTime(0, 0, 0, 17)],
        },
      ),
      ScheduleClass(
        score: 10,
        subject: 'Meca',
        identifier: '12',
        schedule: {
          'Mo': [DateTime(0, 0, 0, 13), DateTime(0, 0, 0, 15)],
          'We': [DateTime(0, 0, 0, 13), DateTime(0, 0, 0, 15)],
          'Fr': [DateTime(0, 0, 0, 13), DateTime(0, 0, 0, 15)],
        },
      ),
      ScheduleClass(
        score: 8,
        subject: 'Meca',
        identifier: '10',
        schedule: {
          'Tu': [DateTime(0, 0, 0, 11), DateTime(0, 0, 0, 13)],
          'We': [DateTime(0, 0, 0, 11), DateTime(0, 0, 0, 13)],
          'Th': [DateTime(0, 0, 0, 11), DateTime(0, 0, 0, 13)],
        },
      ),
    ];

    List<ScheduleOption> schedulesOptions = [];

    print('Generating permutations...');
    final classesPermutations = generatePermutations(classes);

    print('Generating schedule options... ');
    for (var permutation in classesPermutations) {
      final rawSchedule = buildScheduleOption(permutation);
      int totalScore = 0;
      for (var j = 0; j < rawSchedule.length; j++) {
        final ScheduleClass scheduleClass = rawSchedule[j];
        totalScore += scheduleClass.score;
      }
      ScheduleOption scheduleOption = ScheduleOption(
        schedule: rawSchedule,
        score: totalScore,
      );
      bool alreadyAdded = false;
      final currentSet = scheduleOption.generateSignatureSet();
      for (ScheduleOption option in schedulesOptions) {
        Set<String> targetSet = option.generateSignatureSet();
        Set<String> difference1Set = currentSet.difference(targetSet);
        Set<String> difference2Set = targetSet.difference(currentSet);
        if (difference1Set.isEmpty && difference2Set.isEmpty) {
          alreadyAdded = true;
        }
      }
      if (!alreadyAdded) {
        schedulesOptions.add(scheduleOption);
      }
    }

    print('Sorting schedule options by score...');
    schedulesOptions.sort(
        (ScheduleOption a, ScheduleOption b) => b.score.compareTo(a.score));

    print('\nYour schedule options are:');
    for (var i = 0; i < schedulesOptions.length; i++) {
      final scheduleOption = schedulesOptions[i];
      print('\nOption ${i + 1} - score ${scheduleOption.score}');

      int j = 1;
      for (ScheduleClass scheduleClass in scheduleOption.schedule ?? []) {
        print('Class $j: $scheduleClass');
        j++;
      }
    }
  }
}
