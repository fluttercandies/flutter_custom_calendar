import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/CalendarProvider.dart';
import 'package:flutter_custom_calendar/configuration.dart';
import 'package:flutter_custom_calendar/model/date_model.dart';
import 'package:flutter_custom_calendar/widget/month_view.dart';
import 'package:provider/provider.dart';

class MonthViewPager extends StatefulWidget {
  MonthViewPager();

  @override
  _MonthViewPagerState createState() => _MonthViewPagerState();
}

class _MonthViewPagerState extends State<MonthViewPager> {
  @override
  void initState() {}

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
          //月份的变化
          DateModel dateModel = configuration.monthList[position];
          configuration.monthChange(dateModel.year, dateModel.month);
        },
        controller: configuration.pageController,
        itemBuilder: (context, index) {
          DateModel dateModel = configuration.monthList[index];
          return new MonthView(
//            selectMode: configuration.selectMode,
            year: dateModel.year,
            month: dateModel.month,
//            selectDateModel: calendarProvider.selectDateModel,
//            selectedDateList: calendarProvider.selectedDateList,
//            onCalendarSelectListener: configuration.calendarSelect,
//            dayWidgetBuilder: configuration.dayWidgetBuilder,
            minSelectDate: DateModel.fromDateTime(DateTime(
                configuration.minSelectYear,
                configuration.minSelectMonth,
                configuration.minSelectDay)),
            maxSelectDate: DateModel.fromDateTime(DateTime(
                configuration.maxSelectYear,
                configuration.maxSelectMonth,
                configuration.maxSelectDay)),
//            maxMultiSelectCount: configuration.maxMultiSelectCount,
//            multiSelectOutOfRange: configuration.multiSelectOutOfRange,
//            multiSelectOutOfSize: configuration.multiSelectOutOfSize,
//            extraDataMap: configuration.extraDataMap,
          );
        },
        itemCount: configuration.monthList.length,
      ),
    );
  }
}
