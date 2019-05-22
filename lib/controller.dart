import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/widget/default_combine_day_view.dart';
import 'package:flutter_custom_calendar/widget/default_custom_day_view.dart';
import 'package:flutter_custom_calendar/model/date_model.dart';
import 'package:flutter_custom_calendar/widget/default_week_bar.dart';
import 'package:flutter_custom_calendar/constants/constants.dart';

/**
 * 利用controller来控制视图
 */

class CalendarController {
  static const Set<DateTime> EMPTY_SET = {};
  static const Map<DateTime, Object> EMPTY_MAP = {};

  //默认是单选,可以配置为MODE_SINGLE_SELECT，MODE_MULTI_SELECT
  int selectMode;

  //日历显示的最小年份和最大年份
  int minYear;
  int maxYear;

  //日历显示的最小年份的月份，最大年份的月份
  int minYearMonth;
  int maxYearMonth;

  //日历显示的当前的年份和月份
  int nowYear;
  int nowMonth;

  //可操作的范围设置,比如点击选择
  int minSelectYear;
  int minSelectMonth;
  int minSelectDay;

  int maxSelectYear;
  int maxSelectMonth;
  int maxSelectDay; //注意：不能超过对应月份的总天数

  Set<DateModel> selectedDateList = new Set(); //被选中的日期,用于多选
  DateModel selectDateModel; //当前选择项,用于单选
  int maxMultiSelectCount; //多选，最多选多少个
  Map<DateTime, Object> extraDataMap = new Map(); //自定义额外的数据

  //各种事件回调
  OnMonthChange monthChange; //月份切换事件
  OnCalendarSelect calendarSelect; //点击选择事件
  OnMultiSelectOutOfRange multiSelectOutOfRange; //多选超出指定范围
  OnMultiSelectOutOfSize multiSelectOutOfSize; //多选超出限制个数

  //支持自定义绘制
  DayWidgetBuilder dayWidgetBuilder; //创建日历item
  WeekBarItemWidgetBuilder weekBarItemWidgetBuilder; //创建顶部的weekbar

  /**
   * 下面的信息不是配置的
   */
  List<DateModel> monthList = new List(); //月份list
  PageController pageController;

  CalendarController(
      {int selectMode = Constants.MODE_SINGLE_SELECT,
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
      Map<DateTime, Object> extraDataMap = EMPTY_MAP}) {
    this.selectMode = selectMode;
    this.minYear = minYear;
    this.maxYear = maxYear;
    this.minYearMonth = minYearMonth;
    this.maxYearMonth = maxYearMonth;
    this.nowYear = nowYear;
    this.nowMonth = nowMonth;
    this.minSelectYear = minSelectYear;
    this.minSelectMonth = minSelectMonth;
    this.minSelectDay = minSelectDay;
    this.maxSelectYear = maxSelectYear;
    this.maxSelectMonth = maxSelectMonth;
    this.maxSelectDay = maxSelectDay;
    this.selectDateModel = selectDateModel;
    this.dayWidgetBuilder = dayWidgetBuilder;
    this.weekBarItemWidgetBuilder = weekBarItemWidgetBuilder;
    this.maxMultiSelectCount = maxMultiSelectCount;
    this.extraDataMap = extraDataMap;

    this.selectedDateList = Set();
    if (selectedDateTimeList != null && selectedDateTimeList.isNotEmpty) {
      this.selectedDateList.addAll(selectedDateTimeList.map((dateTime) {
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
    this.pageController = new PageController(initialPage: initialPage);
  }

  //月份切换监听
  void addMonthChangeListener(OnMonthChange listener) {
    this.monthChange = listener;
  }

  //点击选择监听
  void addOnCalendarSelectListener(OnCalendarSelect listener) {
    this.calendarSelect = listener;
  }

  //多选超出指定范围
  void addOnMultiSelectOutOfRangeListener(OnMultiSelectOutOfRange listener) {
    this.multiSelectOutOfRange = listener;
  }

  //多选超出限制个数
  void addOnMultiSelectOutOfSizeListener(OnMultiSelectOutOfSize listener) {
    this.multiSelectOutOfSize = listener;
  }

  //跳转到指定日期
  void moveToCalendar(int year, int month, int day,
      {bool needAnimation = false,
      Duration duration = const Duration(milliseconds: 500),
      Curve curve = Curves.ease}) {
    DateModel dateModel = DateModel.fromDateTime(DateTime(year, month, 1));
    //计算目标索引
    int targetPage = monthList.indexOf(dateModel);
    if (targetPage == -1) {
      return;
    }
    if (needAnimation) {
      pageController.animateToPage(targetPage,
          duration: duration, curve: curve);
    } else {
      pageController.jumpToPage(targetPage);
    }
  }

  //切换到下一年
  void moveToNextYear(
      {bool needAnimation = false,
      Duration duration = const Duration(milliseconds: 500),
      Curve curve = Curves.ease}) {
    DateTime targetDateTime =
        monthList[pageController.page.toInt() + 12].getDateTime();
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
        monthList[pageController.page.toInt() - 12].getDateTime();
    moveToCalendar(
        targetDateTime.year, targetDateTime.month, targetDateTime.day,
        needAnimation: needAnimation, duration: duration, curve: curve);
  }

  //切换到下一个月份,
  void moveToNextMonth(
      {bool needAnimation = false,
      Duration duration = const Duration(milliseconds: 500),
      Curve curve = Curves.ease}) {
    DateTime targetDateTime =
        monthList[pageController.page.toInt() + 1].getDateTime();
    moveToCalendar(
        targetDateTime.year, targetDateTime.month, targetDateTime.day,
        needAnimation: needAnimation, duration: duration, curve: curve);
  }

  //切换到上一个月份
  void moveToPreviousMonth(
      {bool needAnimation = false,
      Duration duration = const Duration(milliseconds: 500),
      Curve curve = Curves.ease}) {
    DateTime targetDateTime =
        monthList[pageController.page.toInt() - 1].getDateTime();
    moveToCalendar(
        targetDateTime.year, targetDateTime.month, targetDateTime.day,
        needAnimation: needAnimation, duration: duration, curve: curve);
  }

  // 获取当前的月份
  DateModel getCurrentMonth() {
    return monthList[pageController.page.toInt()];
  }

  //获取被选中的日期,多选
  Set<DateModel> getMultiSelectCalendar() {
    if (selectedDateList.isEmpty) {
      return null;
    }
    return selectedDateList;
  }

  //获取被选中的日期，单选
  DateModel getSingleSelectCalendar() {
    if (selectDateModel == null) {
      return null;
    }
    return selectDateModel;
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
