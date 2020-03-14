import 'package:flutter_custom_calendar/utils/date_util.dart';
import 'package:flutter_custom_calendar/utils/lunar_util.dart';

/**
 * 日期的实体类
 */
class DateModel {
  int year;
  int month;
  int day = 1;

  List<int> lunar = List(3);

//  List<int> get lunar {
//    if (lunar?.isNotEmpty == false) {
//      return lunar;
//    }
////    return LunarUtil.solarToLunar(year, month, day);
//  }

  //农历字符串
  String get lunarString {
    if (solarTerm.isNotEmpty) {
      return solarTerm;
    } else if (gregorianFestival.isNotEmpty) {
      return gregorianFestival;
    } else if (traditionFestival.isNotEmpty) {
      return traditionFestival;
    } else {
      return LunarUtil.numToChinese(lunar[1], lunar[2], lunar[3]);
    }
  }

  //24节气
  String get solarTerm => LunarUtil.getSolarTerm(year, month, day);

  //公历节日
  String get gregorianFestival {
    String result = LunarUtil.gregorianFestival(month, day);
    if (result?.isNotEmpty == true) {
      return result;
    }
    return LunarUtil.getSpecialFestival(year, month, day);
  }

//传统农历节日
  String get traditionFestival =>
      LunarUtil.getTraditionFestival(lunarYear, lunarMonth, lunarDay);

  bool isCurrentMonth; //是否是当前月份

  Object extraData; //自定义的额外数据

  bool isInRange = false; //是否在范围内,比如可以实现在某个范围外，设置置灰的功能
  bool isSelected; //是否被选中，用来实现一些标记或者选择功能
  bool isCanClick =
      true; //todo:是否可点击：设置范围外的日历不可点击，或者可以通过自定义拦截点击事件来设置true或者false
  //是否是周末
  bool get isWeekend => DateUtil.isWeekend(getDateTime());

  //是否是闰年
  bool get isLeapYear => DateUtil.isLeapYear(year);

  //是否是今天
  bool get isCurrentDay => DateUtil.isCurrentDay(year, month, day);

  int get lunarYear => lunar[0];

  int get lunarMonth => lunar[1];

  int get lunarDay => lunar[2];

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
    List<int> lunar =
        LunarUtil.solarToLunar(dateModel.year, dateModel.month, dateModel.day);
    dateModel.lunar = lunar;

//    将数据的初始化放到各个get方法里面进行操作，类似懒加载,不然很浪费
//    LunarUtil.setupLunarCalendar(dateModel);
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

  //是否是同一天
  bool isSameWith(DateModel dateModel) {
    return year == dateModel.year &&
        month == dateModel.month &&
        day == dateModel.day;
  }

  //是否在某天之后
  bool isAfter(DateModel dateModel) {
    return this.getDateTime().isAfter(dateModel.getDateTime());
  }

  //是否在某天之前
  bool isBefore(DateModel dateModel) {
    return this.getDateTime().isBefore(dateModel.getDateTime());
  }
}

class X {
  var _y;

  get y => null == _y ? initY() : _y;

  initY() {
    //do some computation
    _y = "result";
  }
}
