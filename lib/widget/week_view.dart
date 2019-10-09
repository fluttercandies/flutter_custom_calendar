import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/calendar_provider.dart';
import 'package:flutter_custom_calendar/configuration.dart';
import 'package:flutter_custom_calendar/constants/constants.dart';
import 'package:flutter_custom_calendar/controller.dart';
import 'package:flutter_custom_calendar/model/date_model.dart';
import 'package:flutter_custom_calendar/utils/date_util.dart';
import 'package:flutter_custom_calendar/widget/month_view.dart';
import 'package:provider/provider.dart';

/**
 * 周视图，只显示本周的日子
 */
class WeekView extends StatefulWidget {
  final int year;
  final int month;
  final DateModel firstDayOfWeek;
  final CalendarConfiguration configuration;

  const WeekView(
      {@required this.year,
      @required this.month,
      this.firstDayOfWeek,
      this.configuration});

  @override
  _WeekViewState createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
  List<DateModel> items;

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

    items = DateUtil.initCalendarForWeekView(
        widget.year, widget.month, widget.firstDayOfWeek.getDateTime(), 0,
        minSelectDate: minSelectDate,
        maxSelectDate: maxSelectDate,
        extraDataMap: extraDataMap);
  }

  @override
  Widget build(BuildContext context) {
    CalendarProvider calendarProvider =
        Provider.of<CalendarProvider>(context, listen: false);

    CalendarConfiguration configuration =
        calendarProvider.calendarConfiguration;
    print(
        "WeekView Consumer:calendarProvider.selectDateModel:${calendarProvider.selectDateModel}");
    return new GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, mainAxisSpacing: 10),
        itemCount: 7,
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
}
