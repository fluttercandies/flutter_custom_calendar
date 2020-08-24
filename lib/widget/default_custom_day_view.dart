import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/style/style.dart';

import 'base_day_view.dart';

/**
 * 这里定义成一个StatelessWidget，状态是外部的父控件传进来参数控制就行，自己不弄state类
 */

class DefaultCustomDayWidget extends BaseCustomDayWidget {
  const DefaultCustomDayWidget(DateModel dateModel) : super(dateModel);

  @override
  void drawNormal(DateModel dateModel, Canvas canvas, Size size) {
    defaultDrawNormal(dateModel, canvas, size);
  }

  @override
  void drawSelected(DateModel dateModel, Canvas canvas, Size size) {
    defaultDrawSelected(dateModel, canvas, size);
  }
}

//class DefaultCustomDayWidget extends StatelessWidget {
//  DateModel dateModel;
//
//  DefaultCustomDayWidget(this.dateModel);
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      child: new CustomPaint(
//        painter: CustomDayWidgetPainter(
//          dateModel,
//        ),
//      ),
//    );
//  }
//}
//
//class CustomDayWidgetPainter extends CustomPainter {
//  DateModel dateModel;
//
//  drawNormal normalDraw; //普通样式是必须的
//  drawSelected selectedDraw;
//
//  CustomDayWidgetPainter(this.dateModel,
//      {this.normalDraw = defaultDrawNormal,
//      this.selectedDraw = defaultDrawSelected});
//
//  Paint textPaint;
//
//  @override
//  void paint(Canvas canvas, Size size) {
////    print("paint:$size");
//    if (dateModel.isSelected) {
//      selectedDraw(dateModel, canvas, size);
//    } else {
//      normalDraw(dateModel, canvas, size);
//    }
//  }
//
//  @override
//  bool shouldRepaint(CustomPainter oldDelegate) {
//    return true;
//  }
//}

/**
 * 默认的样式
 */
void defaultDrawNormal(DateModel dateModel, Canvas canvas, Size size) {
  //顶部的文字
  TextPainter dayTextPainter = new TextPainter()
    ..text = TextSpan(
        text: dateModel.day.toString(),
        style: dateModel.isCurrentDay
            ? currentDayTextStyle
            : currentMonthTextStyle)
    ..textDirection = TextDirection.ltr
    ..textAlign = TextAlign.center;

  dayTextPainter.layout(minWidth: size.width, maxWidth: size.width);
  dayTextPainter.paint(canvas, Offset(0, 10));

  //下面的文字
  TextPainter lunarTextPainter = new TextPainter()
    ..text = new TextSpan(text: dateModel.lunarString, style: lunarTextStyle)
    ..textDirection = TextDirection.ltr
    ..textAlign = TextAlign.center;

  lunarTextPainter.layout(minWidth: size.width, maxWidth: size.width);
  lunarTextPainter.paint(canvas, Offset(0, size.height / 2));
}

/**
 * 被选中的样式
 */
void defaultDrawSelected(DateModel dateModel, Canvas canvas, Size size) {
  //绘制背景
  Paint backGroundPaint = new Paint()
    ..color = Colors.blue
    ..style = PaintingStyle.stroke
    ..strokeWidth = 2;
  double padding = 8;
  canvas.drawRect(
      Rect.fromPoints(Offset(padding, padding),
          Offset(size.width - padding, size.height - padding)),
      backGroundPaint);

  //顶部的文字
  TextPainter dayTextPainter = new TextPainter()
    ..text =
        TextSpan(text: dateModel.day.toString(), style: currentMonthTextStyle)
    ..textDirection = TextDirection.ltr
    ..textAlign = TextAlign.center;

  dayTextPainter.layout(minWidth: size.width, maxWidth: size.width);
  dayTextPainter.paint(canvas, Offset(0, 10));

  //下面的文字
  TextPainter lunarTextPainter = new TextPainter()
    ..text = new TextSpan(text: dateModel.lunarString, style: lunarTextStyle)
    ..textDirection = TextDirection.ltr
    ..textAlign = TextAlign.center;

  lunarTextPainter.layout(minWidth: size.width, maxWidth: size.width);
  lunarTextPainter.paint(canvas, Offset(0, size.height / 2));
}
