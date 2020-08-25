import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/cache_data.dart';
import 'package:flutter_custom_calendar/configuration.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
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
  Map<DateModel, Object> extraDataMap; //自定义额外的数据

  @override
  void initState() {
    super.initState();
    extraDataMap = widget.configuration.extraDataMap;
    DateModel firstDayOfMonth =
        DateModel.fromDateTime(DateTime(widget.year, widget.month, 1));
    if (CacheData.getInstance().monthListCache[firstDayOfMonth]?.isNotEmpty ==
        true) {
      LogUtil.log(TAG: this.runtimeType, message: "缓存中有数据");
      items = CacheData.getInstance().monthListCache[firstDayOfMonth];
    } else {
      LogUtil.log(TAG: this.runtimeType, message: "缓存中无数据");
      getItems().then((_) {
        CacheData.getInstance().monthListCache[firstDayOfMonth] = items;
      });
    }

    lineCount = DateUtil.getMonthViewLineCount(
        widget.year, widget.month, widget.configuration.offset);

    //第一帧后,添加监听，generation发生变化后，需要刷新整个日历
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      Provider.of<CalendarProvider>(context, listen: false)
          .generation
          .addListener(() async {
        extraDataMap = widget.configuration.extraDataMap;
        await getItems();
      });
    });
  }

  Future getItems() async {
    items = await compute(initCalendarForMonthView, {
      'year': widget.year,
      'month': widget.month,
      'minSelectDate': widget.configuration.minSelectDate,
      'maxSelectDate': widget.configuration.maxSelectDate,
      'extraDataMap': extraDataMap,
      'offset': widget.configuration.offset
    });
    setState(() {});
  }

  static Future<List<DateModel>> initCalendarForMonthView(Map map) async {
    return DateUtil.initCalendarForMonthView(
        map['year'], map['month'], DateTime.now(), DateTime.sunday,
        minSelectDate: map['minSelectDate'],
        maxSelectDate: map['maxSelectDate'],
        extraDataMap: map['extraDataMap'],
        offset: map['offset']);
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
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, mainAxisSpacing: configuration.verticalSpacing),
        itemCount: items.isEmpty ? 0 : items.length,
        itemBuilder: (context, index) {
          DateModel dateModel = items[index];
          //判断是否被选择
          switch (configuration.selectMode) {

            /// 多选
            case CalendarSelectedMode.multiSelect:
              if (calendarProvider.selectedDateList.contains(dateModel)) {
                dateModel.isSelected = true;
              } else {
                dateModel.isSelected = false;
              }
              break;

            /// 选择开始和结束 中间的自动选择

            case CalendarSelectedMode.mutltiStartToEndSelect:
              if (calendarProvider.selectedDateList.contains(dateModel)) {
                dateModel.isSelected = true;
              } else {
                dateModel.isSelected = false;
              }
              break;

            /// 单选
            case CalendarSelectedMode.singleSelect:
              if (calendarProvider.selectDateModel == dateModel) {
                dateModel.isSelected = true;
              } else {
                dateModel.isSelected = false;
              }
              break;
          }

          return ItemContainer(
            dateModel: dateModel,
            key: ObjectKey(dateModel),
            clickCall: () {
              setState(() {});
//              if (configuration.selectMode ==
//                  CalendarSelectedMode.mutltiStartToEndSelect)

              /// 如果是选择开始和结束则进行刷新日历
            },
            //这里使用objectKey，保证可以刷新。原因1：跟flutter的刷新机制有关。原因2：statefulElement持有state。
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

  final GestureTapCallback clickCall;
  const ItemContainer({Key key, this.dateModel, this.clickCall})
      : super(key: key);

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
  void refreshItem(bool v) {
    /**
        Exception caught by gesture
        The following assertion was thrown while handling a gesture:
        setState() called after dispose()
     */
    v ??= false;
    if (mounted) {
      setState(() {
        dateModel.isSelected = v;
      });

      if (widget.clickCall != null) {
        widget.clickCall();
      }
    }
  }

  void _notifiCationUnCalendarSelect(DateModel element) {
    if (configuration.unCalendarSelect != null) {
      configuration.unCalendarSelect(element);
    }
  }

  void _notifiCationCalendarSelect(DateModel element) {
    if (configuration.calendarSelect != null) {
      configuration.calendarSelect(element);
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
          if (configuration.selectMode == CalendarSelectedMode.multiSelect) {
            configuration.multiSelectOutOfRange();
          }
          return;
        }
        print('244 周视图的变化: $dateModel');
        calendarProvider.lastClickDateModel = dateModel;

        switch (configuration.selectMode) {
          //简单多选
          case CalendarSelectedMode.multiSelect:
            if (calendarProvider.selectedDateList.contains(dateModel)) {
              calendarProvider.selectedDateList.remove(dateModel);
              _notifiCationUnCalendarSelect(dateModel);
            } else {
              //多选，判断是否超过限制，超过范围
              if (calendarProvider.selectedDateList.length ==
                  configuration.maxMultiSelectCount) {
                if (configuration.multiSelectOutOfSize != null) {
                  configuration.multiSelectOutOfSize();
                }
                return;
              }
              dateModel.isSelected = !dateModel.isSelected;
              calendarProvider.selectedDateList.add(dateModel);
            }

            //多选也可以弄这些单选的代码
            calendarProvider.selectDateModel = dateModel;
            break;

          /// 单选
          case CalendarSelectedMode.singleSelect:

            /// 加入已经选择了多个 则进行取消操作
            calendarProvider.selectedDateList.forEach((element) {
              element.isSelected = false;
              _notifiCationUnCalendarSelect(element);
            });
            calendarProvider.selectedDateList.clear();

            //单选需要刷新上一个item
            if (calendarProvider.lastClickItemState != this) {
              calendarProvider.lastClickItemState?.refreshItem(false);
              calendarProvider.lastClickItemState = this;
            }
            if(calendarProvider.selectedDateList.contains(dateModel)){
              // 如果已经选择就执行取消
              _notifiCationUnCalendarSelect(calendarProvider.selectDateModel);
              dateModel.isSelected = false;
              calendarProvider.selectedDateList.clear();
              calendarProvider.selectDateModel = null;
              _notifiCationUnCalendarSelect(dateModel);
            }else{
              _notifiCationUnCalendarSelect(calendarProvider.selectDateModel);
              dateModel.isSelected = true;
              calendarProvider.selectDateModel = dateModel;
              _notifiCationCalendarSelect(dateModel);
            }

            setState(() {});

            break;

          /// 选择范围
          case CalendarSelectedMode.mutltiStartToEndSelect:
            if (calendarProvider.selectedDateList.length == 0) {
              calendarProvider.selectedDateList.add(dateModel);
            } else if (calendarProvider.selectedDateList.length == 1) {
              DateModel d2 = calendarProvider.selectedDateList.first;
              if (calendarProvider.selectedDateList.contains(dateModel)) {
                /// 选择同一个第二次则进行取消
                dateModel.isSelected = false;
                _notifiCationUnCalendarSelect(dateModel);
                setState(() {});
                return;
              }
              DateTime t1, t2;
              if (d2.getDateTime().isAfter(dateModel.getDateTime())) {
                t2 = d2.getDateTime();
                t1 = dateModel.getDateTime();
              } else {
                t1 = d2.getDateTime();
                t2 = dateModel.getDateTime();
              }
              for (; t1.isBefore(t2);) {
                calendarProvider.selectedDateList
                    .add(DateModel.fromDateTime(t1));
                t1 = t1.add(Duration(days: 1));
              }
              calendarProvider.selectedDateList.add(DateModel.fromDateTime(t1));
            } else {
              /// 加入已经选择了多个 则进行取消操作
              calendarProvider.selectedDateList.forEach((element) {
                element.isSelected = false;
                _notifiCationUnCalendarSelect(element);
              });

              /// 清空删除的 数组
              calendarProvider.selectedDateList.clear();
              setState(() {});
            }

            break;
        }

        /// 所有数组操作完了 进行通知分发
        if (configuration.calendarSelect != null &&
            calendarProvider.selectedDateList.length > 0) {
          calendarProvider.selectedDateList.forEach((element) {
            _notifiCationCalendarSelect(element);
          });
        }

        refreshItem(!this.dateModel.isSelected);
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
