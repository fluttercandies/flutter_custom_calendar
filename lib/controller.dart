import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/calendar_provider.dart';
import 'package:flutter_custom_calendar/configuration.dart';
import 'package:flutter_custom_calendar/utils/LogUtil.dart';
import 'package:flutter_custom_calendar/utils/date_util.dart';
import 'package:flutter_custom_calendar/widget/default_combine_day_view.dart';
import 'package:flutter_custom_calendar/widget/default_custom_day_view.dart';
import 'package:flutter_custom_calendar/model/date_model.dart';
import 'package:flutter_custom_calendar/widget/default_week_bar.dart';
import 'package:flutter_custom_calendar/constants/constants.dart';
import 'package:provider/provider.dart';

/**
 * 利用controller来控制视图
 */

class CalendarController {
  static const Set<DateTime> EMPTY_SET = {};
  static const Map<DateTime, Object> EMPTY_MAP = {};
  static const Duration DEFAULT_DURATION = const Duration(milliseconds: 500);

  CalendarConfiguration calendarConfiguration;

  CalendarProvider calendarProvider = CalendarProvider();

  /**
   * 下面的信息不是配置的
   */
  List<DateModel> monthList = new List(); //月份list
  List<DateModel> weekList = new List(); //星期list
  PageController monthController; //月份的controller
  PageController weekController; //星期的controller

  CalendarController(
      {int selectMode = Constants.MODE_SINGLE_SELECT,
      bool expandStatus = true,
      DayWidgetBuilder dayWidgetBuilder = defaultCustomDayWidget,
      WeekBarItemWidgetBuilder weekBarItemWidgetBuilder = defaultWeekBarWidget,
      int minYear = 1971,
      int maxYear = 2055,
      int minYearMonth = 1,
      int maxYearMonth = 12,
      int nowYear = -1,
      int nowMonth = -1,
      int minSelectYear = 1971,
      int minSelectMonth = 1,
      int minSelectDay = 1,
      int maxSelectYear = 2055,
      int maxSelectMonth = 12,
      int maxSelectDay = 30,
      Set<DateTime> selectedDateTimeList = EMPTY_SET,
      DateModel selectDateModel,
      int maxMultiSelectCount = 9999,
      double verticalSpacing = 10,
      Map<DateTime, Object> extraDataMap = EMPTY_MAP}) {
    LogUtil.log(TAG: this.runtimeType, message: "init CalendarConfiguration");
    calendarConfiguration = CalendarConfiguration(
        selectMode: selectMode,
        minYear: minYear,
        maxYear: maxYear,
        maxYearMonth: maxYearMonth,
        nowYear: nowYear,
        nowMonth: nowMonth,
        minSelectYear: minSelectYear,
        minSelectMonth: minSelectMonth,
        minYearMonth: minYearMonth,
        minSelectDay: minSelectDay,
        maxSelectYear: maxSelectYear,
        maxSelectMonth: maxSelectMonth,
        defaultExpandStatus: expandStatus,
        maxSelectDay: maxSelectDay,
        verticalSpacing: verticalSpacing);

    calendarConfiguration.dayWidgetBuilder = dayWidgetBuilder;
    calendarConfiguration.weekBarItemWidgetBuilder = weekBarItemWidgetBuilder;

    if (selectedDateTimeList != null && selectedDateTimeList.isNotEmpty) {
      calendarConfiguration.defaultSelectedDateList
          .addAll(selectedDateTimeList.map((dateTime) {
        return DateModel.fromDateTime(dateTime);
      }).toSet());
    }

    //初始化pageController,initialPage默认是当前时间对于的页面
    int initialPage;
    int nowMonthIndex = 0;
    monthList.clear();
    for (int i = minYear; i <= maxYear; i++) {
      for (int j = 1; j <= 12; j++) {
        if (i == minYear && j < minYearMonth) {
          continue;
        }
        if (i == maxYear && j > maxYearMonth) {
          continue;
        }
        DateModel dateModel = new DateModel();
        dateModel.year = i;
        dateModel.month = j;

        //如果没有配置当前时间，设置成当前的时间
        if (nowYear == -1 || nowMonth == -1) {
          nowYear = DateTime.now().year;
          nowMonth = DateTime.now().month;
        }
        if (i == nowYear && j == nowMonth) {
          initialPage = nowMonthIndex;
        }
        monthList.add(dateModel);
        nowMonthIndex++;
      }
    }
    this.monthController = new PageController(initialPage: initialPage);
    LogUtil.log(
        TAG: this.runtimeType,
        message: "start:${DateModel.fromDateTime(DateTime(
          minYear,
          minYearMonth,
        ))},end:${DateModel.fromDateTime(DateTime(
          maxYear,
          maxYearMonth,
        ))}");
    LogUtil.log(
        TAG: this.runtimeType,
        message:
            "初始化月份视图的信息:一共有${monthList.length}个月，initialPage为${nowMonthIndex}");

    //计算一共多少周
    //计算方法：第一天是周几，最后一天是周几，中间的天数/7后加上2就是结果了
    int initialWeekPage = 0;
    int nowWeekIndex = 0;
    weekList.clear();

    DateTime firstDayOfMonth = DateTime(minYear, minYearMonth, 1);
    //计算第一个星期的第一天的日期
    DateTime firstWeekDate =
        firstDayOfMonth.add(Duration(days: -(firstDayOfMonth.weekday - 1)));

    DateTime lastDay = DateTime(maxYear, maxYearMonth,
        DateUtil.getMonthDaysCount(maxYear, maxYearMonth));
    for (DateTime dateTime = firstWeekDate;
        !dateTime.isAfter(lastDay);
        dateTime = dateTime.add(Duration(days: 7))) {
      DateModel dateModel = DateModel.fromDateTime(dateTime);
      weekList.add(dateModel);
    }
    this.weekController = new PageController();
    LogUtil.log(
        TAG: this.runtimeType,
        message:
            "初始化星期视图的信息:一共有${weekList.length}个星期，initialPage为${initialWeekPage}");

    calendarConfiguration.monthList = monthList;
    calendarConfiguration.weekList = weekList;
    calendarConfiguration.pageController = monthController;
    calendarConfiguration.weekController = weekController;
    calendarConfiguration.dayWidgetBuilder = dayWidgetBuilder;
    calendarConfiguration.weekBarItemWidgetBuilder = weekBarItemWidgetBuilder;
  }

  //月份切换监听
  void addMonthChangeListener(OnMonthChange listener) {
    this.calendarConfiguration.monthChange = listener;
  }

  //点击选择监听
  void addOnCalendarSelectListener(OnCalendarSelect listener) {
    this.calendarConfiguration.calendarSelect = listener;
  }

  //多选超出指定范围
  void addOnMultiSelectOutOfRangeListener(OnMultiSelectOutOfRange listener) {
    this.calendarConfiguration.multiSelectOutOfRange = listener;
  }

  //多选超出限制个数
  void addOnMultiSelectOutOfSizeListener(OnMultiSelectOutOfSize listener) {
    this.calendarConfiguration.multiSelectOutOfSize = listener;
  }

  //切换展开状态
  void toggleExpandStatus() {
    calendarProvider.expandStatus.value = !calendarProvider.expandStatus.value;
    LogUtil.log(
        TAG: this.runtimeType,
        message: "toggleExpandStatus：${calendarProvider.expandStatus.value}");
  }

  //监听展开变化
  void addExpandChangeListener(ValueChanged<bool> expandChange) {
    calendarProvider.expandStatus.addListener(() {
      expandChange(calendarProvider.expandStatus.value);
    });
  }

  /**
   * 月份或者星期的上一页
   */
  Future<bool> previousPage() async {
    if (calendarProvider.expandStatus.value == true) {
      //月视图
      int currentIndex = monthController.page.toInt();
      if (currentIndex == 0) {
        return false;
      } else {
        monthController.previousPage(
            duration: DEFAULT_DURATION, curve: Curves.ease);
        return true;
      }
    } else {
      //周视图
      int currentIndex = weekController.page.toInt();
      if (currentIndex == 0) {
        return false;
      } else {
        weekController.previousPage(
            duration: DEFAULT_DURATION, curve: Curves.ease);
        return true;
      }
    }
  }

  /**
   * 月份或者星期的下一页
   * true：成功
   * false:是最后一页
   */
  Future<bool> nextPage() async {
    if (calendarProvider.expandStatus.value == true) {
      //月视图
      int currentIndex = monthController.page.toInt();
      if (monthList.length - 1 == currentIndex) {
        return false;
      } else {
        monthController.nextPage(
            duration: DEFAULT_DURATION, curve: Curves.ease);
        return true;
      }
    } else {
      //周视图
      int currentIndex = weekController.page.toInt();
      if (weekList.length - 1 == currentIndex) {
        return false;
      } else {
        weekController.nextPage(duration: DEFAULT_DURATION, curve: Curves.ease);
        return true;
      }
    }
  }

  //跳转到指定日期
  void moveToCalendar(int year, int month, int day,
      {bool needAnimation = false,
      Duration duration = const Duration(milliseconds: 500),
      Curve curve = Curves.ease}) {
    if (calendarProvider.expandStatus.value == true) {
      DateModel dateModel = DateModel.fromDateTime(DateTime(year, month, 1));
      //计算目标索引
      int targetPage = monthList.indexOf(dateModel);
      if (targetPage == -1) {
        return;
      }
      if (monthController.hasClients == false) {
        return;
      }
      if (needAnimation) {
        monthController.animateToPage(targetPage,
            duration: duration, curve: curve);
      } else {
        monthController.jumpToPage(targetPage);
      }
    } else {
      DateModel dateModel = DateModel.fromDateTime(DateTime(year, month, 1));
      //计算目标索引
      int targetPage = 0;
      for (int i = 0; i < weekList.length - 1; i++) {
        DateModel first = weekList[i];
        DateModel next = weekList[i + 1];
        if (!first.isAfter(dateModel) && next.isAfter(dateModel)) {
          targetPage = i;
          return;
        }
      }
      if (weekController.hasClients == false) {
        return;
      }
      if (needAnimation) {
        weekController.animateToPage(targetPage,
            duration: duration, curve: curve);
      } else {
        weekController.jumpToPage(targetPage);
      }
    }
  }

  //切换到下一年
  void moveToNextYear(
      {bool needAnimation = false,
      Duration duration = const Duration(milliseconds: 500),
      Curve curve = Curves.ease}) {
    DateTime targetDateTime =
        monthList[monthController.page.toInt() + 12].getDateTime();
    moveToCalendar(
        targetDateTime.year, targetDateTime.month, targetDateTime.day,
        needAnimation: needAnimation, duration: duration, curve: curve);
  }

  //切换到上一年
  void moveToPreviousYear(
      {bool needAnimation = false,
      Duration duration = const Duration(milliseconds: 500),
      Curve curve = Curves.ease}) {
    DateTime targetDateTime =
        monthList[monthController.page.toInt() - 12].getDateTime();
    moveToCalendar(
        targetDateTime.year, targetDateTime.month, targetDateTime.day,
        needAnimation: needAnimation, duration: duration, curve: curve);
  }

  //切换到下一个月份,
  void moveToNextMonth(
      {bool needAnimation = false,
      Duration duration = const Duration(milliseconds: 500),
      Curve curve = Curves.ease}) {
    //    如果当前显示的是周视图的话，需要计算出第一个月的index后，调用weekController
    if (calendarProvider.expandStatus.value == false) {
      int currentMonth = weekList[weekController.page.toInt()].month;
      for (int i = weekController.page.toInt(); i < weekList.length; i++) {
        if (weekList[i].month != currentMonth) {
          weekController.jumpToPage(i);
          break;
        }
      }
      return;
    }

    if ((monthController.page.toInt() + 1) >= monthList.length) {
      LogUtil.log(TAG: this.runtimeType, message: "moveToNextMonth：当前是最后一个月份");
      return;
    }
    DateTime targetDateTime =
        monthList[monthController.page.toInt() + 1].getDateTime();
    moveToCalendar(
        targetDateTime.year, targetDateTime.month, targetDateTime.day,
        needAnimation: needAnimation, duration: duration, curve: curve);
  }

  //切换到上一个月份
  void moveToPreviousMonth(
      {bool needAnimation = false,
      Duration duration = const Duration(milliseconds: 500),
      Curve curve = Curves.ease}) {
    //    如果当前显示的是周视图的话，需要计算出第一个月的index后，调用weekController
    if (calendarProvider.expandStatus.value == false) {
      int currentMonth = weekList[weekController.page.toInt()].month;
      for (int i = weekController.page.toInt(); i >= 0; i--) {
        if (weekList[i].month != currentMonth &&
            weekList[i].isAfter(DateModel.fromDateTime(DateTime(
                calendarConfiguration.minYear,
                calendarConfiguration.minYearMonth)))) {
          weekController.jumpToPage(i);
          break;
        }
      }
      return;
    }

    if ((monthController.page.toInt()) == 0) {
      LogUtil.log(
          TAG: this.runtimeType, message: "moveToPreviousMonth：当前是第一个月份");
      return;
    }
    DateTime targetDateTime =
        monthList[monthController.page.toInt() - 1].getDateTime();
    moveToCalendar(
        targetDateTime.year, targetDateTime.month, targetDateTime.day,
        needAnimation: needAnimation, duration: duration, curve: curve);
  }

  // 获取当前的月份
  DateModel getCurrentMonth() {
    return monthList[monthController.page.toInt()];
  }

  //获取被选中的日期,多选
  Set<DateModel> getMultiSelectCalendar() {
    return calendarProvider.selectedDateList;
  }

  //获取被选中的日期，单选
  DateModel getSingleSelectCalendar() {
    return calendarProvider.selectDateModel;
  }
}

/**
 * 默认的weekBar
 */
Widget defaultWeekBarWidget() {
  return DefaultWeekBar();
}

/**
 * 使用canvas绘制item
 */
Widget defaultCustomDayWidget(DateModel dateModel) {
  return DefaultCustomDayWidget(
    dateModel,
  );
}

/**
 * 使用组合widget的方式构造item
 */
Widget defaultCombineDayWidget(DateModel dateModel) {
  return new DefaultCombineDayWidget(
    dateModel,
  );
}

/**
 * 判断是否在范围内，不在范围内的话，可以置灰
 */
bool defaultInRange(DateModel dateModel) {
  return true;
}

/**
 * 月份切换事件
 */
typedef void OnMonthChange(int year, int month);

/**
 * 日期选择事件
 */
typedef void OnCalendarSelect(DateModel dateModel);

/**
 * 多选超出指定范围
 */
typedef void OnMultiSelectOutOfRange();

/**
 * 多选超出限制个数
 */
typedef void OnMultiSelectOutOfSize();

/**
 * 可以创建自定义样式的item
 */
typedef Widget DayWidgetBuilder(DateModel dateModel);

/**
 * 是否可以点击，外部来进行判断，默认都可以点击
 */
typedef bool CanClick(DateModel dateModel);

/**
 * 可以自定义绘制每个Item，这种扩展性好一点，以后可以提供给外部进行自定义绘制
 */
typedef void DrawDayWidget(DateModel dateModel, Canvas canvas, Size size);

/**
 * 自定义顶部weekBar
 */
typedef Widget WeekBarItemWidgetBuilder();
