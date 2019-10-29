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
    Key key,
    @required this.year,
    @required this.month,
    this.day,
    this.configuration,
  }) : super(key: key);

  @override
  _MonthViewState createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView>
    with AutomaticKeepAliveClientMixin {
  List<DateModel> items = List();

  int lineCount;

//  double itemHeight;
//  double totalHeight;
//  double mainSpacing = 10;

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
      getItems();
      CacheData.getInstance().monthListCache[firstDayOfMonth] = items;
    }

    lineCount = DateUtil.getMonthViewLineCount(widget.year, widget.month);
  }

  getItems() async {
    items = await compute(initCalendarForMonthView, {
      'year': widget.year,
      'month': widget.month,
      'minSelectDate': minSelectDate,
      'maxSelectDate': maxSelectDate,
      'extraDataMap': extraDataMap
    });
    setState(() {});
  }

  static Future<List<DateModel>> initCalendarForMonthView(Map map) async {
    return DateUtil.initCalendarForMonthView(
        map['year'], map['month'], DateTime.now(), DateTime.sunday,
        minSelectDate: map['minSelectDate'],
        maxSelectDate: map['maxSelectDate'],
        extraDataMap: map['extraDataMap']);
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    LogUtil.log(TAG: this.runtimeType, message: "_MonthViewState build");

    CalendarProvider calendarProvider =
        Provider.of<CalendarProvider>(context, listen: false);
    CalendarConfiguration configuration =
        calendarProvider.calendarConfiguration;

    return new GridView.builder(
        addAutomaticKeepAlives: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, mainAxisSpacing: configuration.verticalSpacing),
        itemCount: items.isEmpty ? 0 : 7 * lineCount,
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

  /**
   * 提供方法给外部，可以调用这个方法进行刷新item
   */
  void refreshItem() {
    /**
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

  @override
  Widget build(BuildContext context) {
//    LogUtil.log(TAG: this.runtimeType, message: "ItemContainerState build");
    calendarProvider = Provider.of<CalendarProvider>(context, listen: false);
    configuration = calendarProvider.calendarConfiguration;

    return GestureDetector(
      //点击整个item都会触发事件
      behavior: HitTestBehavior.opaque,
      onTap: () {
        LogUtil.log(
            TAG: this.runtimeType,
            message: "GestureDetector onTap: $dateModel}");

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
    );
  }

  @override
  void deactivate() {
//    LogUtil.log(
//        TAG: this.runtimeType, message: "ItemContainerState deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
//    LogUtil.log(TAG: this.runtimeType, message: "ItemContainerState dispose");
    super.dispose();
  }

  @override
  void didUpdateWidget(ItemContainer oldWidget) {
//    LogUtil.log(
//        TAG: this.runtimeType, message: "ItemContainerState didUpdateWidget");
    super.didUpdateWidget(oldWidget);
  }
}
