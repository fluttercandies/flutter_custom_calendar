import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

import 'flutter_custom_calendar.dart';

/**
 * 配置信息类
 */
class CalendarConfiguration {
  //默认是单选,可以配置为MODE_SINGLE_SELECT，MODE_MULTI_SELECT
  CalendarSelectedMode? selectMode;

  //仅展示月视图，仅展示周视图，支持月视图和周视图切换
  int showMode;

  //日历显示的最小年份和最大年份
  int minYear;
  int maxYear;

  //日历显示的最小年份的月份，最大年份的月份
  int minYearMonth;
  int maxYearMonth;

  //日历显示的当前的年份和月份
  int nowYear;
  int nowMonth;
  // 周视图需要
  late int nowDay;

  //可操作的范围设置,比如点击选择
  late int minSelectYear;
  late int minSelectMonth;
  late int minSelectDay;

  late int maxSelectYear;
  late int maxSelectMonth;
  late int maxSelectDay; //注意：不能超过对应月份的总天数

  DateModel? selectDateModel; //默认被选中的item，用于单选
  Set<DateModel>? defaultSelectedDateList; //默认被选中的日期set，用于多选
  int maxMultiSelectCount; //多选，最多选多少个
  Map<DateModel, Object> extraDataMap = new Map(); //自定义额外的数据

  /**
   * UI绘制方面的绘制
   */
  double? itemSize; //默认是屏幕宽度/7
  double? verticalSpacing; //日历item之间的竖直方向间距，默认10
  BoxDecoration? boxDecoration; //整体的背景设置
  EdgeInsetsGeometry? padding;
  EdgeInsetsGeometry? margin;

  //支持自定义绘制
  late DayWidgetBuilder dayWidgetBuilder; //创建日历item
  late WeekBarItemWidgetBuilder weekBarItemWidgetBuilder; //创建顶部的weekbar

  /**
   * 监听变化
   */
  //各种事件回调
  late OnMonthChange monthChange; //月份切换事件 （已弃用,交给multiMonthChanges来实现）
  late OnCalendarSelect calendarSelect; //点击选择事件
  late OnCalendarSelect unCalendarSelect; //点击选择事件
  late OnMultiSelectOutOfRange multiSelectOutOfRange; //多选超出指定范围
  late OnMultiSelectOutOfSize multiSelectOutOfSize; //多选超出限制个数

  ObserverList<OnMonthChange> monthChangeListeners =
      ObserverList<OnMonthChange>(); //保存多个月份监听的事件
  ObserverList<OnWeekChange> weekChangeListeners =
      ObserverList<OnWeekChange>(); //周视图切换

  /**
   * 下面的信息不是配置的，是根据配置信息进行计算出来的
   */
  List<DateModel> monthList; //月份list
  List<DateModel> weekList; //星期list
  PageController? monthController; //月份的controller
  PageController? weekController; //星期的controller
  DateModel? minSelectDate;
  DateModel? maxSelectDate;

  /// 首日偏移量 first day offset
  /// first day = (first day of month or week) + offset
  final int offset;

  CalendarConfiguration(
      { this.selectMode,
      required this.minYear,
      required this.maxYear,
        required this.minYearMonth,
        required this.maxYearMonth,
        required this.nowYear,
        required this.nowMonth,
        required this.minSelectYear,
        required this.minSelectMonth,
        required this.minSelectDay,
        required this.maxSelectYear,
        required this.maxSelectMonth,
        required this.maxSelectDay,
         this.defaultSelectedDateList,
        required this.selectDateModel,
        required this.maxMultiSelectCount,
        required this.extraDataMap,
         this.monthController,
         this.weekController,
         this.verticalSpacing,
         this.itemSize,
        required this.showMode,
         this.padding,
         this.margin,
      this.offset = 0,
        this.monthList=const [],
        this.weekList=const []});

  @override
  String toString() {
    return 'CalendarConfiguration{selectMode: $selectMode, minYear: $minYear, maxYear: $maxYear, minYearMonth: $minYearMonth, maxYearMonth: $maxYearMonth, nowYear: $nowYear, nowMonth: $nowMonth, minSelectYear: $minSelectYear, minSelectMonth: $minSelectMonth, minSelectDay: $minSelectDay, maxSelectYear: $maxSelectYear, maxSelectMonth: $maxSelectMonth, maxSelectDay: $maxSelectDay, defaultSelectedDateList: $defaultSelectedDateList, maxMultiSelectCount: $maxMultiSelectCount, extraDataMap: $extraDataMap, monthList: $monthList, weekList: $weekList, monthController: $monthController, weekController: $weekController}';
  }
}
