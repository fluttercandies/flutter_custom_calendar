import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/cache_data.dart';
import 'package:flutter_custom_calendar/calendar_provider.dart';
import 'package:flutter_custom_calendar/configuration.dart';
import 'package:flutter_custom_calendar/constants/constants.dart';
import 'package:flutter_custom_calendar/model/date_model.dart';
import 'package:flutter_custom_calendar/utils/LogUtil.dart';
import 'package:flutter_custom_calendar/utils/date_util.dart';
import 'package:provider/provider.dart';

/**
 * 月视图，显示整个月的日子
 */
class MonthView extends StatefulWidget {
  final int year;
  final int month;
  final int day;

  final CalendarConfiguration configuration;

  const MonthView({
    @required this.year,
    @required this.month,
    this.day,
    this.configuration,
  });

  @override
  _MonthViewState createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView>
    with AutomaticKeepAliveClientMixin {
  List<DateModel> items;

  int lineCount;

  double itemHeight;
  double totalHeight;
  double mainSpacing = 10;

  DateModel minSelectDate;
  DateModel maxSelectDate;
  Map<DateModel, Object> extraDataMap; //自定义额外的数据

  @override
  void initState() {
    super.initState();

    minSelectDate = DateModel.fromDateTime(DateTime(
        widget.configuration.minSelectYear,
        widget.configuration.minSelectMonth,
        widget.configuration.minSelectDay));
    maxSelectDate = DateModel.fromDateTime(DateTime(
        widget.configuration.maxSelectYear,
        widget.configuration.maxSelectMonth,
        widget.configuration.maxSelectDay));
    extraDataMap = widget.configuration.extraDataMap;

    DateModel firstDayOfMonth =
        DateModel.fromDateTime(DateTime(widget.year, widget.month, 1));
    if (CacheData.getInstance().monthListCache[firstDayOfMonth]?.isNotEmpty ==
        true) {
      LogUtil.log(TAG: this.runtimeType, message: "缓存中有数据");
      items = CacheData.getInstance().monthListCache[firstDayOfMonth];
    } else {
      LogUtil.log(TAG: this.runtimeType, message: "缓存中无数据");
      items = DateUtil.initCalendarForMonthView(
          widget.year, widget.month, DateTime.now(), DateTime.sunday,
          minSelectDate: minSelectDate,
          maxSelectDate: maxSelectDate,
          extraDataMap: extraDataMap);
      CacheData.getInstance().monthListCache[firstDayOfMonth] = items;
    }

    lineCount = DateUtil.getMonthViewLineCount(widget.year, widget.month);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    LogUtil.log(TAG: this.runtimeType, message: "_MonthViewState build");
    itemHeight = MediaQuery.of(context).size.width / 7;
    totalHeight = itemHeight * lineCount + mainSpacing * (lineCount - 1);

    return Container(height: totalHeight, child: getView());
  }

  Widget getView() {
    CalendarProvider calendarProvider =
        Provider.of<CalendarProvider>(context, listen: false);
    CalendarConfiguration configuration =
        calendarProvider.calendarConfiguration;

    return new GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, mainAxisSpacing: 10),
        itemCount: 7 * lineCount,
        itemBuilder: (context, index) {
          DateModel dateModel = items[index];
          //判断是否被选择
          if (configuration.selectMode == Constants.MODE_MULTI_SELECT) {
            if (calendarProvider.selectedDateList.contains(dateModel)) {
              dateModel.isSelected = true;
            } else {
              dateModel.isSelected = false;
            }
          } else {
            if (calendarProvider.selectDateModel == dateModel) {
              dateModel.isSelected = true;
            } else {
              dateModel.isSelected = false;
            }
          }

          return ItemContainer(
            dateModel: dateModel,
//            configuration: configuration,
//            calendarProvider: calendarProvider,
          );
        });
  }

  @override
  bool get wantKeepAlive => true;
}

/**
 * 多选模式，包装item，这样的话，就只需要刷新当前点击的item就行了，不需要刷新整个页面
 */
class ItemContainer extends StatefulWidget {
  final DateModel dateModel;

//  CalendarConfiguration configuration;
//  CalendarProvider calendarProvider;

  const ItemContainer({
    Key key,
    this.dateModel,
  }) : super(key: key);

  @override
  ItemContainerState createState() => ItemContainerState();
}

class ItemContainerState extends State<ItemContainer> {
  DateModel dateModel;
  CalendarConfiguration configuration;
  CalendarProvider calendarProvider;

  ValueNotifier<bool> isSelected;

  @override
  void initState() {
    super.initState();
    dateModel = widget.dateModel;
    isSelected = ValueNotifier(dateModel.isSelected);
  }

  @override
  Widget build(BuildContext context) {
//    LogUtil.log(TAG: this.runtimeType,message: "ItemContainerState build");
    calendarProvider = Provider.of<CalendarProvider>(context, listen: false);
    configuration = calendarProvider.calendarConfiguration;

    return GestureDetector(
      //点击整个item都会触发事件
      behavior: HitTestBehavior.opaque,
      onTap: () {
        LogUtil.log(
            TAG: this.runtimeType,
            message: "GestureDetector onTap: $dateModel}");

        if(!dateModel.isInSetDaysRange){
          //多选回调
          if (configuration.selectMode == CalendarConstants.MODE_MULTI_SELECT) {
            configuration.multiSelectOutOfRange();
          }
          return;
        }
        
        //范围外不可点击
        if (!dateModel.isInRange) {
          //多选回调
          if (configuration.selectMode == Constants.MODE_MULTI_SELECT) {
            configuration.multiSelectOutOfRange();
          }
          return;
        }

        calendarProvider.lastClickDateModel = dateModel;

        if (configuration.selectMode == Constants.MODE_MULTI_SELECT) {
          //多选，判断是否超过限制，超过范围
          if (calendarProvider.selectedDateList.length ==
              configuration.maxMultiSelectCount) {
            configuration.multiSelectOutOfSize();
            return;
          }

          if (calendarProvider.selectedDateList.contains(dateModel)) {
            calendarProvider.selectedDateList.remove(dateModel);
          } else {
            calendarProvider.selectedDateList.add(dateModel);
          }
          configuration.calendarSelect(dateModel);

          //多选也可以弄这些单选的代码
          calendarProvider.selectDateModel = dateModel;
        } else {
          calendarProvider.selectDateModel = dateModel;
          configuration.calendarSelect(dateModel);

          //单选需要刷新上一个item
          calendarProvider.lastClickItemState?.refreshItem();
          calendarProvider.lastClickItemState = this;
        }

        refreshItem();
      },
      child: configuration.dayWidgetBuilder(dateModel),
//        child: ValueListenableBuilder(
//            valueListenable: isSelected,
//            builder: (BuildContext context, bool value, Widget child) {
//              return configuration.dayWidgetBuilder(dateModel);
//            }),
    );
  }

  /**
   * 刷新item
   */
  void refreshItem() {
    /**
     *
        Exception caught by gesture
        The following assertion was thrown while handling a gesture:
        setState() called after dispose()
     */
    if (mounted) {
      setState(() {
        dateModel.isSelected = !dateModel.isSelected;
//        isSelected.value = !isSelected.value;
      });
    }
  }
}
