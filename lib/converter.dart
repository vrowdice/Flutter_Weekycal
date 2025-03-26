import 'dataClass.dart';

//month string to month index
String convertWeekIntToStr(int argIndex) {
  switch (argIndex) {
    case 0:
      return 'SUN';
    case 1:
      return 'MON';
    case 2:
      return 'TUE';
    case 3:
      return 'WED';
    case 4:
      return 'THU';
    case 5:
      return 'FRI';
    case 6:
      return 'SAT';
    default:
      return '';
  }
}

String generateScheduleId(ScheduleData schedule) {
  // inherence ID generate
  return '${schedule.startTime}_${schedule.endTime}_${schedule.name}';
}