import 'dataClass.dart';

// min time and max time
// 0 hour to 24 hour
int minTime = 6;
int maxTime = 24;
//week data array
var scheduleData = List.generate(7, (index) {
  Week week = Week();
  week.index = index;
  return week;
});

void save(){

}
void road(){

}