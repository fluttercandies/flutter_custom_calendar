import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/base_day_view.dart';
import 'package:flutter_custom_calendar/base_week_bar.dart';
import 'package:flutter_custom_calendar/calendar_view.dart';
import 'package:flutter_custom_calendar/controller.dart';
import 'package:flutter_custom_calendar/model/date_model.dart';
import 'dart:math';

class ProgressStylePage extends StatefulWidget {
  ProgressStylePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _ProgressStylePageState createState() => _ProgressStylePageState();
}

class _ProgressStylePageState extends State<ProgressStylePage> {
  String text;

  CalendarController controller;

  @override
  void initState() {
    text = "${DateTime.now().year}年${DateTime.now().month}月";

    DateTime now = DateTime.now();
    DateTime temp = DateTime(now.year, now.month, now.day);

    Map<DateTime, int> progressMap = {
      temp.add(Duration(days: 1)): 0,
      temp.add(Duration(days: 2)): 20,
      temp.add(Duration(days: 3)): 40,
      temp.add(Duration(days: 4)): 60,
      temp.add(Duration(days: 5)): 80,
      temp.add(Duration(days: 6)): 100,
    };

    controller = new CalendarController(
        extraDataMap: progressMap,
        weekBarItemWidgetBuilder: () {
          return CustomStyleWeekBarItem();
        },
        dayWidgetBuilder: (dateModel) {
          return ProgressStyleDayWidget(dateModel);
        });

    controller.addMonthChangeListener(
      (year, month) {
        setState(() {
          text = "$year年$month月";
        });
      },
    );

    controller.addOnCalendarSelectListener((dateModel) {
      //刷新选择的时间
      setState(() {});
    });

    controller.addOnMultiSelectOutOfSizeListener(() {
      print("超出限制个数");
    });
    controller.addOnMultiSelectOutOfRangeListener(() {
      print("超出范围限制");
    });
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
                new Text(text),
                new IconButton(
                    icon: Icon(Icons.navigate_next),
                    onPressed: () {
                      controller.moveToNextMonth();
                    }),
              ],
            ),
            CalendarViewWidget(
              calendarController: controller,
            ),
            new Text(
                "单选模式\n选中的时间:\n${controller.getSingleSelectCalendar().toString()}"),
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
  List<String> weekList = ["一", "二", "三", "四", "五", "六", "日"];

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
