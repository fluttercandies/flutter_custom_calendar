import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/configuration.dart';
import 'package:flutter_custom_calendar/model/date_model.dart';
import 'package:flutter_custom_calendar/utils/LogUtil.dart';

/**
 * 引入provider的状态管理，保存一些临时信息
 *
 * 目前的情况：只需要获取状态，不需要监听rebuild
 */
class CalendarProvider extends ChangeNotifier {
  Set<DateModel> selectedDateList = new Set(); //被选中的日期,用于多选
  DateModel _selectDateModel; //当前选中的日期，用于单选
  DateModel lastClickDateModel; //保存最后点击的一个日期，用于周视图与月视图之间的切换和同步

  DateModel get selectDateModel => _selectDateModel;

  set selectDateModel(DateModel value) {
    _selectDateModel = value;
    LogUtil.log(
        TAG: this.runtimeType,
        message: "selectDateModel change:${selectDateModel}");
    notifyListeners();
  }

  ValueNotifier<bool> expandStatus = ValueNotifier(true); //当前展开状态

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
        : DateModel.fromDateTime(DateTime.now());
  }

  //退出的时候，清除数据
  void clearData() {
    LogUtil.log(TAG: this.runtimeType, message: "CalendarProvider clearData");
    selectedDateList.clear();
    selectDateModel = null;
  }
}
