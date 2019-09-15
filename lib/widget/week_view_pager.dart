import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/calendar_provider.dart';
import 'package:flutter_custom_calendar/configuration.dart';
import 'package:flutter_custom_calendar/controller.dart';
import 'package:flutter_custom_calendar/model/date_model.dart';
import 'package:flutter_custom_calendar/widget/week_view.dart';
import 'package:provider/provider.dart';

class WeekViewPager extends StatefulWidget {
  WeekViewPager();

  @override
  _WeekViewPagerState createState() => _WeekViewPagerState();
}

class _WeekViewPagerState extends State<WeekViewPager> {
  int lastMonth; //保存上一个月份，不然不知道月份发生了变化
  CalendarProvider calendarProvider;

  @override
  void initState() {
    print("WeekViewPager initState");

    calendarProvider = Provider.of<CalendarProvider>(context, listen: false);

    lastMonth = calendarProvider.lastClickDateModel.month;
    //计算当前周视图的index
    DateModel dateModel = calendarProvider.lastClickDateModel;
    List<DateModel> weekList = calendarProvider.calendarConfiguration.weekList;
    int index = 0;

    for (int i = 0; i < weekList.length; i++) {
      DateModel firstDayOfWeek = weekList[i];
      DateModel lastDayOfWeek = DateModel.fromDateTime(
          firstDayOfWeek.getDateTime().add(Duration(days: 7)));

      if ((dateModel.isSameWith(weekList[i]) ||
              dateModel.isAfter(weekList[i])) &&
          dateModel.isBefore(lastDayOfWeek)) {
        index = i;
        break;
      }
    }
//    print("weekList:$weekList");
//    print("当前周:index:$index");
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      calendarProvider.calendarConfiguration.weekController.jumpToPage(index);
    });
  }

  @override
  void dispose() {
    print("WeekViewPager dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //    获取到当前的CalendarProvider对象,设置listen为false，不需要刷新
    CalendarProvider calendarProvider =
        Provider.of<CalendarProvider>(context, listen: false);
    CalendarConfiguration configuration =
        calendarProvider.calendarConfiguration;

    return Container(
      child: PageView.builder(
        onPageChanged: (position) {
//          周视图的变化
          DateModel firstDayOfWeek = configuration.weekList[position];
          int currentMonth = firstDayOfWeek.month;
          if (lastMonth != currentMonth) {
            configuration.monthChange(
                firstDayOfWeek.year, firstDayOfWeek.month);
          }
//          DateModel dateModel = configuration.weekList[position];
//          configuration.monthChange(dateModel.year, dateModel.month);
        },
        controller: configuration.weekController,
        itemBuilder: (context, index) {
          DateModel dateModel = configuration.weekList[index];
          return new WeekView(
            year: dateModel.year,
            month: dateModel.month,
            firstDayOfWeek: dateModel,
            minSelectDate: DateModel.fromDateTime(DateTime(
                configuration.minSelectYear,
                configuration.minSelectMonth,
                configuration.minSelectDay)),
            maxSelectDate: DateModel.fromDateTime(DateTime(
                configuration.maxSelectYear,
                configuration.maxSelectMonth,
                configuration.maxSelectDay)),
            extraDataMap: configuration.extraDataMap,
          );
        },
        itemCount: configuration.weekList.length,
      ),
    );
  }
}
