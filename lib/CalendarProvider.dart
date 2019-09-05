import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/configuration.dart';
import 'package:flutter_custom_calendar/model/date_model.dart';

/**
 * 引入provider的状态管理，保存一些临时信息
 *
 * 目前的情况：只需要获取状态，不需要监听rebuild
 */
class CalendarProvider extends ChangeNotifier {
  Set<DateModel> selectedDateList = new Set(); //被选中的日期,用于多选
  DateModel _selectDateModel; //当前选中的日期，用于单选

  DateModel get selectDateModel => _selectDateModel;

  set selectDateModel(DateModel value) {
    _selectDateModel = value;
    print("notifyListeners:$value");
    notifyListeners();
  }

  //配置类也放这里吧，这样的话，所有子树，都可以拿到配置的信息
  CalendarConfiguration calendarConfiguration;

  void initData(
      {Set<DateModel> selectedDateList,
      DateModel selectDateModel,
      CalendarConfiguration calendarConfiguration}) {
    print("CalendarProvider init");
    if (selectedDateList != null) {
      this.selectedDateList.addAll(selectedDateList);
    }
    this.selectDateModel = selectDateModel;
    this.calendarConfiguration = calendarConfiguration;
  }

  //退出的时候，清除数据
  void clearData() {
    print("CalendarProvider clearData");
    selectedDateList.clear();
    selectDateModel = null;
  }
}
