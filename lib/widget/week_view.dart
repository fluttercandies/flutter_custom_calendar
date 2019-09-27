import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/calendar_provider.dart';
import 'package:flutter_custom_calendar/configuration.dart';
import 'package:flutter_custom_calendar/constants/constants.dart';
import 'package:flutter_custom_calendar/controller.dart';
import 'package:flutter_custom_calendar/model/date_model.dart';
import 'package:flutter_custom_calendar/utils/date_util.dart';
import 'package:provider/provider.dart';

/**
 * 周视图，只显示本周的日子
 */
class WeekView extends StatefulWidget {
  final int year;
  final int month;
  final DateModel firstDayOfWeek;

  final DateModel minSelectDate;
  final DateModel maxSelectDate;

  final Map<DateModel, Object> extraDataMap; //自定义额外的数据

  const WeekView(
      {@required this.year,
      @required this.month,
      this.firstDayOfWeek,
      this.minSelectDate,
      this.maxSelectDate,
      this.extraDataMap});

  @override
  _WeekViewState createState() => _WeekViewState();
}

class _WeekViewState extends State<WeekView> {
  List<DateModel> items;

  @override
  void initState() {
    super.initState();
    items = DateUtil.initCalendarForWeekView(
        widget.year, widget.month, widget.firstDayOfWeek.getDateTime(), 0,
        minSelectDate: widget.minSelectDate,
        maxSelectDate: widget.maxSelectDate,
        extraDataMap: widget.extraDataMap);
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CalendarProvider>(
        builder: (context, calendarProvider, child) {
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

            return GestureDetector(
              onTap: () {
                //范围外不可点击
                print("GestureDetector onTap：$dateModel");
                print("!dateModel.isInRange:${!dateModel.isInRange}");
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

                  //多选也可以弄这些单选的代码
                  calendarProvider.selectDateModel = dateModel;
                  configuration.calendarSelect(dateModel);
//                  setState(() {
                  if (calendarProvider.selectedDateList.contains(dateModel)) {
                    calendarProvider.selectedDateList.remove(dateModel);
                  } else {
                    calendarProvider.selectedDateList.add(dateModel);
                  }
//                  });
                } else {
                  calendarProvider.selectDateModel = dateModel;
                  configuration.calendarSelect(dateModel);
//                  setState(() {});
                }
              },
              child: configuration.dayWidgetBuilder(dateModel),
            );
          });
    });
  }
}
