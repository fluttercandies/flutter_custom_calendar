import 'package:flutter_custom_calendar/utils/lunar_util.dart';

/**
 * 日期的实体类
 */
class DateModel {
  int year;
  int month;
  int day = 1;

  int lunarYear;
  int lunarMonth;
  int lunarDay;

  String lunarString; //农历字符串
  String solarTerm; //24节气
  String gregorianFestival; //公历节日
  String traditionFestival; //传统农历节日

  bool isCurrentDay; //是否是今天
  bool isLeapYear; //是否是闰年
  bool isWeekend; //是否是周末
  int leapMonth; //是否是闰月

  Object extraData; //自定义的额外数据

  bool isInRange = false; //是否在范围内,比如可以实现在某个范围外，设置置灰的功能
  bool isSelected; //是否被选中，用来实现一些标记或者选择功能
  bool isCanClick = true; //todo:是否可点击：设置范围外的日历不可点击，或者可以通过自定义拦截点击事件来设置true或者false

  @override
  String toString() {
    return 'DateModel{year: $year, month: $month, day: $day}';
  } //如果是闰月，则返回闰月

  //转化成DateTime格式
  DateTime getDateTime() {
    return new DateTime(year, month, day);
  }

  //根据DateTime创建对应的model，并初始化农历和传统节日等信息
  static DateModel fromDateTime(DateTime dateTime) {
    DateModel dateModel = new DateModel()
      ..year = dateTime.year
      ..month = dateTime.month
      ..day = dateTime.day;
    LunarUtil.setupLunarCalendar(dateModel);
    return dateModel;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateModel &&
          runtimeType == other.runtimeType &&
          year == other.year &&
          month == other.month &&
          day == other.day;

  @override
  int get hashCode => year.hashCode ^ month.hashCode ^ day.hashCode;
}
