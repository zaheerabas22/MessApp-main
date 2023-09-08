class AttendanceModel {
  int currentMonth;
  int currentYear;
  List<DayData> data;
  String uid;

  AttendanceModel({
    required this.currentMonth,
    required this.currentYear,
    required this.data,
    required this.uid,
  });

  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    List<DayData> dayDataList = [];
    final data = json['data'];
    for (var i = 1; i <= 31; i++) {
      if (data.containsKey(i.toString())) {
        final dayData = data[i.toString()];
        dayDataList.add(DayData(
          day: i,
          breakfast: dayData['breakfast'],
          lunch: dayData['lunch'],
        ));
      }
    }

    return AttendanceModel(
      currentMonth: json['current_month'],
      currentYear: json['current_year'],
      data: dayDataList,
      uid: json['uid'],
    );
  }
}

class DayData {
  int day;
  bool breakfast;
  bool lunch;

  DayData({
    required this.day,
    required this.breakfast,
    required this.lunch,
  });
}
