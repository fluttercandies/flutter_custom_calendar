import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/utils/date_util.dart';

/**
 * 周视图，只显示本周的日子
 */
class WeekView extends StatefulWidget {
  @override
  _WeekViewState createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
  @override
  Widget build(BuildContext context) {
//    DateTime dateTime = DateTime.now();
//
//    print(dateTime);
//
//    print(dateTime.subtract(Duration(days: 1)));
//
//    var berlinWallFell = new DateTime(1989, DateTime.november, 9);
//    var dDay = new DateTime(1944, DateTime.june, 6);
//    Duration difference = berlinWallFell.difference(dDay);
//    print(difference.inDays);

    print(DateUtil.initCalendarForMonthView(
        2019, 12, DateTime.now(), DateTime.sunday));

    return Container();
  }
}
