import 'package:flutter/material.dart';
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

  final DateModel minSelectDate;
  final DateModel maxSelectDate;

  final Map<DateModel, Object> extraDataMap; //自定义额外的数据

  const MonthView({
    @required this.year,
    @required this.month,
    this.day,
    this.minSelectDate,
    this.maxSelectDate,
    this.extraDataMap,
  });

  @override
  _MonthViewState createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  List<DateModel> items;

  int lineCount;

  double itemHeight;
  double totalHeight;
  double mainSpacing = 10;

  @override
  void initState() {
    super.initState();

    items = DateUtil.initCalendarForMonthView(
        widget.year, widget.month, DateTime.now(), DateTime.sunday,
        minSelectDate: widget.minSelectDate,
        maxSelectDate: widget.maxSelectDate,
        extraDataMap: widget.extraDataMap);

    lineCount = DateUtil.getMonthViewLineCount(widget.year, widget.month);
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.log(TAG: this.runtimeType, message: "_MonthViewState build");
    itemHeight = MediaQuery.of(context).size.width / 7;
    totalHeight = itemHeight * lineCount + mainSpacing * (lineCount - 1);

    return Container(height: totalHeight, child: getView());
  }

  Widget getView() {
    return Consumer<CalendarProvider>(
        builder: (context, calendarProvider, child) {
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

                  configuration.calendarSelect(dateModel);
                  if (calendarProvider.selectedDateList.contains(dateModel)) {
                    calendarProvider.selectedDateList.remove(dateModel);
                  } else {
                    calendarProvider.selectedDateList.add(dateModel);
                  }

                  //多选也可以弄这些单选的代码
                  calendarProvider.selectDateModel = dateModel;
                } else {
                  calendarProvider.selectDateModel = dateModel;
                  configuration.calendarSelect(dateModel);
                }
              },
              child: configuration.dayWidgetBuilder(dateModel),
            );
          });
    });
  }
}
