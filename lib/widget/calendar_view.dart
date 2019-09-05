import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_custom_calendar/CalendarProvider.dart';
import 'package:flutter_custom_calendar/configuration.dart';
import 'package:flutter_custom_calendar/constants/constants.dart';
import 'package:flutter_custom_calendar/controller.dart';
import 'package:flutter_custom_calendar/model/date_model.dart';
import 'package:flutter_custom_calendar/widget/month_view_pager.dart';
import 'package:flutter_custom_calendar/widget/week_view_pager.dart';
import 'package:provider/provider.dart';

/**
 * 暂时默认是周一开始的
 */

//由于旧的代码关系。。所以现在需要抽出一个StatefulWidget放在StatelessWidget里面
class CalendarViewWidget extends StatefulWidget {
  //整体的背景设置
  BoxDecoration boxDecoration;

  //控制器
  CalendarController calendarController;

  CalendarViewWidget(
      {Key key, @required this.calendarController, this.boxDecoration})
      : super(key: key);

  @override
  _CalendarViewWidgetState createState() => _CalendarViewWidgetState();
}

class _CalendarViewWidgetState extends State<CalendarViewWidget> {
  @override
  void initState() {
    widget.calendarController.calendarProvider.initData(
        calendarConfiguration: widget.calendarController.calendarConfiguration);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CalendarProvider>.value(
      value: widget.calendarController.calendarProvider,
      child: Container(
          //外部可以自定义背景设置
          decoration: widget.boxDecoration,
          child: const CalendarContainer()),
    );
  }
}

class CalendarContainer extends StatefulWidget {
  const CalendarContainer();

  @override
  CalendarContainerState createState() => CalendarContainerState();
}

class CalendarContainerState extends State<CalendarContainer>
    with SingleTickerProviderStateMixin {
  double itemHeight;
  double totalHeight;

  bool expand = true;

  @override
  void initState() {
//    widget.calendarController.expandChanged.addListener(() {
//      print("_CalendarViewWidgetState:$expand");
//      setState(() {
//        expand = !expand;
//      });
//    });
//
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("CalendarContainerState build");
    //暂时先这样写死,提前计算布局的高度,不然会出现问题:a horizontal viewport was given an unlimited amount of I/flutter ( 6759): vertical space in which to expand.
    itemHeight = MediaQuery.of(context).size.width / 7;
    totalHeight = itemHeight * 6 + 10 * (6 - 1);
    return Container(
      child: new Column(
        children: <Widget>[
          /**
           * 利用const，避免每次setState都会刷新到这顶部的view
           */
//          widget.calendarController.weekBarItemWidgetBuilder(),
          AnimatedContainer(
              duration: Duration(milliseconds: 500),
              height: expand ? totalHeight : itemHeight,
              child:
//              expand ?
                  Container(
                height: totalHeight,
                child: MonthViewPager(
//                        selectMode: widget.calendarController.selectMode,
//                        monthChange: (int year, int month) {
//                          widget.calendarController.monthChange(year, month);
//                        },
//                        calendarSelect: (dateModel) {
//                          widget.calendarController.selectDateModel = dateModel;
//                          widget.calendarController.calendarSelect(dateModel);
//                        },
//                        monthList: widget.calendarController.monthList,
//                        pageController: widget.calendarController.pageController,
//                        selectedDateList:
//                            widget.calendarController.selectedDateList,
//                        selectDateModel:
//                            widget.calendarController.selectDateModel,
//                        dayWidgetBuilder:
//                            widget.calendarController.dayWidgetBuilder,
//                        minSelectDate: DateModel()
//                          ..year = widget.calendarController.minSelectYear
//                          ..month = widget.calendarController.minSelectMonth
//                          ..day = widget.calendarController.minSelectDay,
//                        maxSelectDate: DateModel()
//                          ..year = widget.calendarController.maxSelectYear
//                          ..month = widget.calendarController.maxSelectMonth
//                          ..day = widget.calendarController.maxSelectDay,
//                        maxMultiSelectCount:
//                            widget.calendarController.maxMultiSelectCount,
//                  multiSelectOutOfRange:
//                      widget.calendarController.multiSelectOutOfRange,
//                  multiSelectOutOfSize:
//                      widget.calendarController.multiSelectOutOfSize,
//                        extraDataMap: widget.calendarController.extraDataMap,
                    ),
              )
//                  : Container(
//                      height: itemHeight,
//                      child: WeekViewPager(
//                        selectMode: widget.calendarController.selectMode,
//                        monthChange: (int year, int month) {
//                          widget.calendarController.monthChange(year, month);
//                        },
//                        calendarSelect: (dateModel) {
//                          widget.calendarController.selectDateModel = dateModel;
//                          widget.calendarController.calendarSelect(dateModel);
//                        },
//                        weekList: widget.calendarController.weekList,
//                        pageController: widget.calendarController.pageController,
//                        selectedDateList:
//                            widget.calendarController.selectedDateList,
//                        selectDateModel:
//                            widget.calendarController.selectDateModel,
//                        dayWidgetBuilder:
//                            widget.calendarController.dayWidgetBuilder,
//                        minSelectDate: DateModel()
//                          ..year = widget.calendarController.minSelectYear
//                          ..month = widget.calendarController.minSelectMonth
//                          ..day = widget.calendarController.minSelectDay,
//                        maxSelectDate: DateModel()
//                          ..year = widget.calendarController.maxSelectYear
//                          ..month = widget.calendarController.maxSelectMonth
//                          ..day = widget.calendarController.maxSelectDay,
//                        maxMultiSelectCount:
//                            widget.calendarController.maxMultiSelectCount,
//                        multiSelectOutOfRange:
//                            widget.calendarController.multiSelectOutOfRange,
//                        multiSelectOutOfSize:
//                            widget.calendarController.multiSelectOutOfSize,
//                        extraDataMap: widget.calendarController.extraDataMap,
//                      ),
//                    ),
              ),
        ],
      ),
    );
  }
}
