import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'dart:math';

/**
 * 进度条风格+单选
 */
class ProgressStylePage extends StatefulWidget {
  ProgressStylePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProgressStylePageState createState() => _ProgressStylePageState();
}

class _ProgressStylePageState extends State<ProgressStylePage> {
  ValueNotifier<String> text;
  ValueNotifier<String> selectText;

  CalendarController controller;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    DateTime temp = DateTime(now.year, now.month, now.day);

    Map<DateModel, int> progressMap = {
      DateModel.fromDateTime(temp.add(Duration(days: -1))): 0,
      DateModel.fromDateTime(temp.add(Duration(days: -2))): 20,
      DateModel.fromDateTime(temp.add(Duration(days: -3))): 40,
      DateModel.fromDateTime(temp.add(Duration(days: -4))): 60,
      DateModel.fromDateTime(temp.add(Duration(days: -5))): 80,
      DateModel.fromDateTime(temp.add(Duration(days: -6))): 100,
      DateModel.fromDateTime(temp.add(Duration(days: 1))): 0,
      DateModel.fromDateTime(temp.add(Duration(days: 2))): 20,
      DateModel.fromDateTime(temp.add(Duration(days: 3))): 40,
      DateModel.fromDateTime(temp.add(Duration(days: 4))): 60,
      DateModel.fromDateTime(temp.add(Duration(days: 5))): 80,
      DateModel.fromDateTime(temp.add(Duration(days: 6))): 100,
    };

    controller = new CalendarController(
      extraDataMap: progressMap,
    );

    controller.addMonthChangeListener(
      (year, month) {
        text.value = "$year年$month月";
      },
    );

    controller.addOnCalendarSelectListener((dateModel) {
      //刷新选择的时间
      selectText.value =
          "单选模式\n选中的时间:\n${controller.getSingleSelectCalendar()}";
    });

    text = new ValueNotifier("${DateTime.now().year}年${DateTime.now().month}月");

    selectText = new ValueNotifier(
        "单选模式\n选中的时间:\n${controller.getSingleSelectCalendar()}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: new Container(
        child: new Column(
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new IconButton(
                    icon: Icon(Icons.navigate_before),
                    onPressed: () {
                      controller.moveToPreviousMonth();
                    }),
                ValueListenableBuilder(
                    valueListenable: text,
                    builder: (context, value, child) {
                      return new Text(text.value);
                    }),
                new IconButton(
                    icon: Icon(Icons.navigate_next),
                    onPressed: () {
                      controller.moveToNextMonth();
                    }),
              ],
            ),
            CalendarViewWidget(
                calendarController: controller,
                weekBarItemWidgetBuilder: () {
                  return CustomStyleWeekBarItem();
                },
                dayWidgetBuilder: (dateModel) {
                  return ProgressStyleDayWidget(dateModel);
                }),
            ValueListenableBuilder(
                valueListenable: selectText,
                builder: (context, value, child) {
                  return new Text(selectText.value);
                }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class CustomStyleWeekBarItem extends BaseWeekBar {
  final List<String> weekList = ["一", "二", "三", "四", "五", "六", "日"];

  @override
  Widget getWeekBarItem(int index) {
    return new Container(
      child: new Center(
        child: new Text(weekList[index]),
      ),
    );
  }
}

class ProgressStyleDayWidget extends BaseCustomDayWidget {
  ProgressStyleDayWidget(DateModel dateModel) : super(dateModel);

  @override
  void drawNormal(DateModel dateModel, Canvas canvas, Size size) {
    bool isInRange = dateModel.isInRange;

    //进度条
    int progress = dateModel.extraData;
    if (progress != null && progress != 0) {
      double padding = 8;
      Paint paint = Paint()
        ..color = Colors.grey
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2;

      canvas.drawCircle(Offset(size.width / 2, size.height / 2),
          (size.width - padding) / 2, paint);

      paint.color = Colors.blue;

      double startAngle = -90 * pi / 180;
      double sweepAngle = pi / 180 * (360 * progress / 100);

      canvas.drawArc(
          Rect.fromCircle(
              center: Offset(size.width / 2, size.height / 2),
              radius: (size.width - padding) / 2),
          startAngle,
          sweepAngle,
          false,
          paint);
    }

    //顶部的文字
    TextPainter dayTextPainter = new TextPainter()
      ..text = TextSpan(
          text: dateModel.day.toString(),
          style: new TextStyle(
              color: !isInRange ? Colors.grey : Colors.black, fontSize: 16))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    dayTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    dayTextPainter.paint(canvas, Offset(0, 10));

    //下面的文字
    TextPainter lunarTextPainter = new TextPainter()
      ..text = new TextSpan(
          text: dateModel.lunarString,
          style: new TextStyle(
              color: !isInRange ? Colors.grey : Colors.grey, fontSize: 12))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    lunarTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    lunarTextPainter.paint(canvas, Offset(0, size.height / 2));
  }

  @override
  void drawSelected(DateModel dateModel, Canvas canvas, Size size) {
    //绘制背景
    Paint backGroundPaint = new Paint()
      ..color = Colors.blue
      ..strokeWidth = 2;
    double padding = 8;
    canvas.drawCircle(Offset(size.width / 2, size.height / 2),
        (size.width - padding) / 2, backGroundPaint);

    //顶部的文字
    TextPainter dayTextPainter = new TextPainter()
      ..text = TextSpan(
          text: dateModel.day.toString(),
          style: new TextStyle(color: Colors.white, fontSize: 16))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    dayTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    dayTextPainter.paint(canvas, Offset(0, 10));

    //下面的文字
    TextPainter lunarTextPainter = new TextPainter()
      ..text = new TextSpan(
          text: dateModel.lunarString,
          style: new TextStyle(color: Colors.white, fontSize: 12))
      ..textDirection = TextDirection.ltr
      ..textAlign = TextAlign.center;

    lunarTextPainter.layout(minWidth: size.width, maxWidth: size.width);
    lunarTextPainter.paint(canvas, Offset(0, size.height / 2));
  }
}
