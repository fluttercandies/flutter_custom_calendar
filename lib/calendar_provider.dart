import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/cache_data.dart';
import 'package:flutter_custom_calendar/configuration.dart';
import 'package:flutter_custom_calendar/constants/constants.dart';
import 'package:flutter_custom_calendar/model/date_model.dart';
import 'package:flutter_custom_calendar/utils/LogUtil.dart';
import 'package:flutter_custom_calendar/utils/date_util.dart';
import 'package:flutter_custom_calendar/widget/month_view.dart';

/**
 * 引入provider的状态管理，保存一些临时信息
 *
 * 目前的情况：只需要获取状态，不需要监听rebuild
 */
class CalendarProvider extends ChangeNotifier {
  double _totalHeight; //当前月视图的整体高度
  Set<DateModel> selectedDateList = new Set(); //被选中的日期,用于多选
  DateModel _selectDateModel; //当前选中的日期，用于单选
  ItemContainerState lastClickItemState;
  DateModel _lastClickDateModel;

  double get totalHeight => _totalHeight;

  set totalHeight(double value) {
    _totalHeight = value;
  }

  changeTotalHeight(double value) {
    _totalHeight = value;
    notifyListeners();
  }

  DateModel get lastClickDateModel =>
      _lastClickDateModel; //保存最后点击的一个日期，用于周视图与月视图之间的切换和同步

  set lastClickDateModel(DateModel value) {
    _lastClickDateModel = value;
    print("lastClickDateModel:$lastClickDateModel");
  }

  DateModel get selectDateModel => _selectDateModel;

  set selectDateModel(DateModel value) {
    _selectDateModel = value;
    LogUtil.log(
        TAG: this.runtimeType,
        message: "selectDateModel change:${selectDateModel}");
//    notifyListeners();
  }

  //根据lastClickDateModel，去计算需要展示的星期视图的初始index
  int get weekPageIndex {
    //计算当前星期视图的index
    DateModel dateModel = lastClickDateModel;
    DateTime firstWeek = calendarConfiguration.weekList[0].getDateTime();
    int index = 0;
    for (int i = 0; i < calendarConfiguration.weekList.length; i++) {
      DateTime nextWeek = firstWeek.add(Duration(days: 7));
      if (dateModel.getDateTime().isBefore(nextWeek)) {
        index = i;
        break;
      } else {
        firstWeek = nextWeek;
        index++;
      }
    }

    print("lastClickDateModel:$lastClickDateModel,weekPageIndex:$index");
    return index;
  }

  //根据lastClickDateModel，去计算需要展示的月视图的index
  int get monthPageIndex {
    //计算当前月视图的index
    DateModel dateModel = lastClickDateModel;
    int index = 0;
    for (int i = 0; i < calendarConfiguration.monthList.length - 1; i++) {
      DateTime preMonth = calendarConfiguration.monthList[i].getDateTime();
      DateTime nextMonth = calendarConfiguration.monthList[i + 1].getDateTime();
      if (!dateModel.getDateTime().isBefore(preMonth) &&
          !dateModel.getDateTime().isAfter(nextMonth)) {
        index = i;
        break;
      } else {
        index++;
      }
    }

    print("lastClickDateModel:$lastClickDateModel,monthPageIndex:$index");
    return index + 1;
  }

  ValueNotifier<bool> expandStatus; //当前展开状态

  //配置类也放这里吧，这样的话，所有子树，都可以拿到配置的信息
  CalendarConfiguration calendarConfiguration;

  void initData(
      {Set<DateModel> selectedDateList,
      DateModel selectDateModel,
      CalendarConfiguration calendarConfiguration}) {
    LogUtil.log(TAG: this.runtimeType, message: "CalendarProvider initData");
    if (selectedDateList != null) {
      this.selectedDateList.addAll(selectedDateList);
    }
    this.selectDateModel = selectDateModel;
    this.calendarConfiguration = calendarConfiguration;
    //lastClickDateModel，默认是选中的item，如果为空的话，默认是当前的时间
    this.lastClickDateModel = selectDateModel != null
        ? selectDateModel
        : DateModel.fromDateTime(DateTime.now())
      ..day = 15;
    if (calendarConfiguration.showMode == Constants.MODE_SHOW_ONLY_WEEK ||
        calendarConfiguration.showMode == Constants.MODE_SHOW_WEEK_AND_MONTH) {
      expandStatus = ValueNotifier(false);
    } else {
      expandStatus = ValueNotifier(true);
    }
  }

  //退出的时候，清除数据
  void clearData() {
    LogUtil.log(TAG: this.runtimeType, message: "CalendarProvider clearData");
    CacheData.getInstance().clearData();
    selectedDateList.clear();
    selectDateModel = null;
    calendarConfiguration = null;
  }
}
