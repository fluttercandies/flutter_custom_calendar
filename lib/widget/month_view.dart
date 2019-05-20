import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/constants/constants.dart';
import 'package:flutter_custom_calendar/controller.dart';
import 'package:flutter_custom_calendar/model/date_model.dart';
import 'package:flutter_custom_calendar/utils/date_util.dart';

/**
 * 月视图，显示整个月的日子
 */
class MonthView extends StatefulWidget {
  OnCalendarSelect onCalendarSelectListener;

  Set<DateModel> selectedDateList; //被选中的日期

  DateModel selectDateModel; //当前选择项,用于单选

  DayWidgetBuilder dayWidgetBuilder;

  OnMultiSelectOutOfRange multiSelectOutOfRange; //多选超出指定范围
  OnMultiSelectOutOfSize multiSelectOutOfSize; //多选超出限制个数

  int year;
  int month;
  int day;

  DateModel minSelectDate;
  DateModel maxSelectDate;

  int selectMode;
  int maxMultiSelectCount;

  Map<DateTime, Object> extraDataMap; //自定义额外的数据

  MonthView(
      {@required this.year,
      @required this.month,
      this.day,
      this.onCalendarSelectListener,
      this.dayWidgetBuilder,
      this.selectedDateList,
      this.selectDateModel,
      this.minSelectDate,
      this.maxSelectDate,
      this.selectMode,
      this.multiSelectOutOfSize,
      this.multiSelectOutOfRange,
      this.maxMultiSelectCount,
      this.extraDataMap});

  @override
  _MonthViewState createState() => _MonthViewState();
}

class _MonthViewState extends State<MonthView> {
  List<DateModel> items;

  int lineCount;

  double itemHeight;
  double totalHeight;
  double mainSpacing = 10;

  int year;
  int month;

  DateModel selectDateModel; //当前选择项,用于单选

  @override
  void initState() {
    super.initState();

    year = widget.year;
    month = widget.month;

    items = DateUtil.initCalendarForMonthView(
        year, month, DateTime.now(), DateTime.sunday,
        minSelectDate: widget.minSelectDate,
        maxSelectDate: widget.maxSelectDate,
        extraDataMap: widget.extraDataMap);

    lineCount = DateUtil.getMonthViewLineCount(year, month);

    selectDateModel = widget.selectDateModel;
  }

  @override
  Widget build(BuildContext context) {
    itemHeight = MediaQuery.of(context).size.width / 7;
    totalHeight = itemHeight * lineCount + mainSpacing * (lineCount - 1);

    return GestureDetector(
        onVerticalDragStart: (DragStartDetails detail) {
          print("onHorizontalDragStart:$detail");
        },
        child: Container(height: totalHeight, child: getView()));
  }

  Widget getView() {
    return new GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7, mainAxisSpacing: 10),
        itemCount: 7 * lineCount,
        itemBuilder: (context, index) {
          DateModel dateModel = items[index];
          //判断是否被选择
          if (widget.selectMode == Constants.MODE_MULTI_SELECT) {
            if (widget.selectedDateList.contains(dateModel)) {
              dateModel.isSelected = true;
            } else {
              dateModel.isSelected = false;
            }
          } else {
            if (selectDateModel == dateModel) {
              dateModel.isSelected = true;
            } else {
              dateModel.isSelected = false;
            }
          }

          return GestureDetector(
            onTap: () {
              //范围外不可点击
              if (!dateModel.isInRange) {
                //多选回调
                if (widget.selectMode == Constants.MODE_MULTI_SELECT) {
                  widget.multiSelectOutOfRange();
                }
                return;
              }

              if (widget.selectMode == Constants.MODE_MULTI_SELECT) {
                //多选，判断是否超过限制，超过范围
                if (widget.selectedDateList.length ==
                    widget.maxMultiSelectCount) {
                  widget.multiSelectOutOfSize();
                  return;
                }

                //多选也可以弄这些单选的代码
                selectDateModel = dateModel;
                widget.selectDateModel = dateModel;
                widget.onCalendarSelectListener(dateModel);
                setState(() {
                  if (widget.selectedDateList.contains(dateModel)) {
                    widget.selectedDateList.remove(dateModel);
                  } else {
                    widget.selectedDateList.add(dateModel);
                  }
                });
              } else {
                selectDateModel = dateModel;
                widget.selectDateModel = dateModel;
                widget.onCalendarSelectListener(dateModel);
                setState(() {});
              }
            },
            child: widget.dayWidgetBuilder(dateModel),
          );
        });
  }
}
