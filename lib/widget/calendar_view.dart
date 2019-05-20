import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/constants/constants.dart';
import 'package:flutter_custom_calendar/controller.dart';
import 'package:flutter_custom_calendar/model/date_model.dart';
import 'package:flutter_custom_calendar/widget/month_view_pager.dart';


/**
 * 暂时默认是周一开始的
 */
class CalendarViewWidget extends StatefulWidget {
  //整体的背景设置
  BoxDecoration boxDecoration;

  //控制器
  CalendarController calendarController;

  CalendarViewWidget({@required this.calendarController, this.boxDecoration});

  @override
  _CalendarViewWidgetState createState() => _CalendarViewWidgetState();
}

class _CalendarViewWidgetState extends State<CalendarViewWidget> {
  double itemHeight;
  double totalHeight;

  @override
  void initState() {}

  @override
  Widget build(BuildContext context) {
    //暂时先这样写死,提前计算布局的高度,不然会出现问题:a horizontal viewport was given an unlimited amount of I/flutter ( 6759): vertical space in which to expand.
    itemHeight = MediaQuery.of(context).size.width / 7;
    totalHeight = itemHeight * 6 + 10 * (6 - 1);
    return Container(
      //外部可以自定义背景设置
      decoration: widget.boxDecoration,
      child: new Column(
        children: <Widget>[
          /**
           * 利用const，避免每次setState都会刷新到这顶部的view
           */
          widget.calendarController.weekBarItemWidgetBuilder(),
          Container(
            height: totalHeight,
            child: MonthViewPager(
              selectMode: widget.calendarController.selectMode,
              monthChange: (int year, int month) {
                widget.calendarController.monthChange(year, month);
              },
              calendarSelect: (dateModel) {
                widget.calendarController.selectDateModel =dateModel;
                widget.calendarController.calendarSelect(dateModel);
              },
              monthList: widget.calendarController.monthList,
              pageController: widget.calendarController.pageController,
              selectedDateList: widget.calendarController.selectedDateList,
              selectDateModel: widget.calendarController.selectDateModel,
              dayWidgetBuilder: widget.calendarController.dayWidgetBuilder,
              minSelectDate: DateModel()
                ..year = widget.calendarController.minSelectYear
                ..month = widget.calendarController.minSelectMonth
                ..day = widget.calendarController.minSelectDay,
              maxSelectDate: DateModel()
                ..year = widget.calendarController.maxSelectYear
                ..month = widget.calendarController.maxSelectMonth
                ..day = widget.calendarController.maxSelectDay,
              maxMultiSelectCount:
                  widget.calendarController.maxMultiSelectCount,
              multiSelectOutOfRange:
                  widget.calendarController.multiSelectOutOfRange,
              multiSelectOutOfSize:
                  widget.calendarController.multiSelectOutOfSize,
              extraDataMap: widget.calendarController.extraDataMap,
            ),
          ),
        ],
      ),
    );
  }
}
