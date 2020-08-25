import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/calendar_provider.dart';
import 'package:flutter_custom_calendar/constants/constants.dart';
import 'package:flutter_custom_calendar/controller.dart';
import 'package:flutter_custom_calendar/utils/LogUtil.dart';
import 'package:flutter_custom_calendar/utils/date_util.dart';
import 'package:flutter_custom_calendar/widget/month_view_pager.dart';
import 'package:flutter_custom_calendar/widget/week_view_pager.dart';
import 'package:provider/provider.dart';

/**
 * 暂时默认是周一开始的
 */

//由于旧的代码关系。。所以现在需要抽出一个StatefulWidget放在StatelessWidget里面
class CalendarViewWidget extends StatefulWidget {
  //整体的背景设置
  final BoxDecoration boxDecoration;

  //日历的padding和margin
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  //默认是屏幕宽度/7
  final double itemSize;

  //日历item之间的竖直方向间距，默认10
  final double verticalSpacing;

  //自定义日历item
  final DayWidgetBuilder dayWidgetBuilder;
  final WeekBarItemWidgetBuilder weekBarItemWidgetBuilder;

  //控制器
  final CalendarController calendarController;

  CalendarViewWidget(
      {Key key,
        this.dayWidgetBuilder = defaultCustomDayWidget,
        this.weekBarItemWidgetBuilder = defaultWeekBarWidget,
        @required this.calendarController,
        this.boxDecoration,
        this.padding = EdgeInsets.zero,
        this.margin = EdgeInsets.zero,
        this.verticalSpacing = 10,
        this.itemSize})
      : super(key: key);

  @override
  _CalendarViewWidgetState createState() => _CalendarViewWidgetState();
}

class _CalendarViewWidgetState extends State<CalendarViewWidget> {
  @override
  void initState() {
    //初始化一些数据，一些跟状态有关的要放到provider中
    widget.calendarController.calendarProvider.initData(
        calendarConfiguration: widget.calendarController.calendarConfiguration,
        padding: widget.padding,
        margin: widget.margin,
        itemSize: widget.itemSize,
        verticalSpacing: widget.verticalSpacing,
        dayWidgetBuilder: widget.dayWidgetBuilder,
        weekBarItemWidgetBuilder: widget.weekBarItemWidgetBuilder);

    super.initState();
  }

  @override
  void dispose() {
//    widget.calendarController.clearData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<CalendarProvider>.value(
      value: widget.calendarController.calendarProvider,
      child: Container(
        //外部可以自定义背景设置
          decoration: widget.boxDecoration,
          padding: widget.padding,
          margin: widget.margin,
          //使用const，保证外界的setState不会刷新日历这个widget
          child: CalendarContainer(widget.calendarController)),
    );
  }
}

class CalendarContainer extends StatefulWidget {
  final CalendarController calendarController;

  const CalendarContainer(this.calendarController);

  @override
  CalendarContainerState createState() => CalendarContainerState();
}

class CalendarContainerState extends State<CalendarContainer>
    with SingleTickerProviderStateMixin {
  double itemHeight;
  double totalHeight;

  bool expand;

  CalendarProvider calendarProvider;

  List<Widget> widgets = [];

  int index = 0;

  @override
  void initState() {
    super.initState();
    calendarProvider = Provider.of<CalendarProvider>(context, listen: false);
    expand = calendarProvider.expandStatus.value;

    if (calendarProvider.calendarConfiguration.showMode ==
        CalendarConstants.MODE_SHOW_ONLY_WEEK) {
      widgets.add(const WeekViewPager());
    } else if (calendarProvider.calendarConfiguration.showMode ==
        CalendarConstants.MODE_SHOW_WEEK_AND_MONTH) {
      widgets.add(const MonthViewPager());
      widgets.add(const WeekViewPager());
      index = 1;
    } else if (calendarProvider.calendarConfiguration.showMode ==
        CalendarConstants.MODE_SHOW_MONTH_AND_WEEK) {
      widgets.add(const MonthViewPager());
      widgets.add(const WeekViewPager());
      index = 0;
    } else {
      //默认是只显示月视图
      widgets.add(const MonthViewPager());
    }
    expand = calendarProvider.expandStatus.value;

    //如果需要视图切换的话，才需要添加监听，不然不需要监听变化
    if (calendarProvider.calendarConfiguration.showMode ==
        CalendarConstants.MODE_SHOW_WEEK_AND_MONTH ||
        calendarProvider.calendarConfiguration.showMode ==
            CalendarConstants.MODE_SHOW_MONTH_AND_WEEK) {
      calendarProvider.expandStatus.addListener(() {
        setState(() {
          print(
              "calendarProvider.expandStatus.value:${calendarProvider.expandStatus.value}");
          expand = calendarProvider.expandStatus.value;
          if (expand) {
            index = 0;
            //周视图切换到月视图，需要计算下初始化的高度
            int lineCount = DateUtil.getMonthViewLineCount(
                calendarProvider.calendarConfiguration.nowYear,
                calendarProvider.calendarConfiguration.nowMonth,
                calendarProvider.calendarConfiguration.offset);
            totalHeight = calendarProvider.calendarConfiguration.itemSize * (lineCount) + calendarProvider.calendarConfiguration.verticalSpacing * (lineCount - 1);
            calendarProvider.calendarConfiguration.monthController.jumpToPage(calendarProvider.monthPageIndex);
          } else {
            index = 1;
            //月视图切换到周视图
            calendarProvider.calendarConfiguration.weekController.jumpToPage(calendarProvider.weekPageIndex);
          }
        });
      });
    } else {
      index = 0;
    }

    widget.calendarController.addMonthChangeListener((year, month) {
      if (widget.calendarController.calendarProvider.calendarConfiguration
          .showMode !=
          CalendarConstants.MODE_SHOW_ONLY_WEEK) {
        //月份切换的时候，如果高度发生变化的话，需要setState使高度整体自适应
        int lineCount = DateUtil.getMonthViewLineCount(year, month, widget.calendarController.calendarConfiguration.offset);
        double newHeight = itemHeight * (lineCount) +
            calendarProvider.calendarConfiguration.verticalSpacing *
                (lineCount - 1);
        LogUtil.log(
            TAG: this.runtimeType,
            message: "totalHeight:$totalHeight,newHeight:$newHeight");
        if (totalHeight.toInt() != newHeight.toInt()) {
          LogUtil.log(TAG: this.runtimeType, message: "月份视图高度发生变化");
          setState(() {
            totalHeight = newHeight;
          });
        }
      }
    });

    itemHeight = calendarProvider.calendarConfiguration.itemSize;
    totalHeight = calendarProvider.totalHeight;
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    LogUtil.log(TAG: this.runtimeType, message: "CalendarContainerState build");
    return Container(
      width: itemHeight * 7,
      child: new Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          /**
           * 利用const，避免每次setState都会刷新到这顶部的view
           */
          calendarProvider.calendarConfiguration.weekBarItemWidgetBuilder(),
          AnimatedContainer(
              duration: Duration(milliseconds: 500),
              height: expand ? totalHeight : itemHeight,
              child: IndexedStack(
                index: index,
                children: widgets,
              )),
        ],
      ),
    );
  }
}
