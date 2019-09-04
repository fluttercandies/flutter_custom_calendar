import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/controller.dart';
import 'package:flutter_custom_calendar/model/date_model.dart';
import 'package:flutter_custom_calendar/widget/week_view.dart';

class WeekViewPager extends StatefulWidget {
  final OnMonthChange monthChange;

  final OnCalendarSelect calendarSelect;
  final DayWidgetBuilder dayWidgetBuilder;
  OnMultiSelectOutOfRange multiSelectOutOfRange; //多选超出指定范围
  OnMultiSelectOutOfSize multiSelectOutOfSize; //多选超出限制个数

  Set<DateModel> selectedDateList; //被选中的日期,用于多选
  DateModel selectDateModel; //当前选择项,用于单选

  final List<DateModel> weekList;
  PageController pageController;

  DateModel minSelectDate;
  DateModel maxSelectDate;

  int selectMode;
  int maxMultiSelectCount;

  Map<DateTime, Object> extraDataMap; //自定义额外的数据

  WeekViewPager(
      {this.monthChange,
      this.calendarSelect,
      this.weekList,
      this.pageController,
      this.selectedDateList,
      this.selectDateModel,
      this.dayWidgetBuilder,
      this.minSelectDate,
      this.maxSelectDate,
      this.selectMode,
      this.maxMultiSelectCount,
      this.multiSelectOutOfRange,
      this.multiSelectOutOfSize,
      this.extraDataMap});

  @override
  _WeekViewPagerState createState() => _WeekViewPagerState();
}

class _WeekViewPagerState extends State<WeekViewPager> {

  int lastMonth;//上一个月份

  @override
  void initState() {
//      lastMonth=
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PageView.builder(
        onPageChanged: (position) {
          //月份的变化
          DateModel dateModel = widget.weekList[position];
          widget.monthChange(dateModel.year, dateModel.month);
        },
        controller: widget.pageController,
        itemBuilder: (context, index) {
          DateModel dateModel = widget.weekList[index];
          return new WeekView(
            selectMode: widget.selectMode,
            year: dateModel.year,
            month: dateModel.month,
            selectDateModel: widget.selectDateModel,
            selectedDateList: widget.selectedDateList,
            onCalendarSelectListener: widget.calendarSelect,
            dayWidgetBuilder: widget.dayWidgetBuilder,
            minSelectDate: widget.minSelectDate,
            maxSelectDate: widget.maxSelectDate,
            maxMultiSelectCount: widget.maxMultiSelectCount,
            multiSelectOutOfRange: widget.multiSelectOutOfRange,
            multiSelectOutOfSize: widget.multiSelectOutOfSize,
            extraDataMap: widget.extraDataMap,
          );
        },
        itemCount: widget.weekList.length,
      ),
    );
  }
}
