import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/model/date_model.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';

import '../controller.dart';

/**
 * 通过canvas自定义item，只需实现相关的方法就可以
 */
abstract class BaseCustomDayWidget extends StatelessWidget {
  final DateModel dateModel;

  const BaseCustomDayWidget(
    this.dateModel,
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      child: new CustomPaint(
        painter:
            //根据isSelected标志获取对应的item
            dateModel.isSelected
                ? new CustomDayWidgetPainter(dateModel,
                    drawDayWidget: drawSelected)
                : new CustomDayWidgetPainter(dateModel,
                    drawDayWidget: drawNormal),
      ),
    );
  }

  void drawNormal(DateModel dateModel, Canvas canvas, Size size);

  void drawSelected(DateModel dateModel, Canvas canvas, Size size);
}

class CustomDayWidgetPainter extends CustomPainter {
  DateModel dateModel;

  DrawDayWidget drawDayWidget; //普通样式是必须的

  CustomDayWidgetPainter(this.dateModel, {this.drawDayWidget});

  Paint textPaint;

  @override
  void paint(Canvas canvas, Size size) {
    drawDayWidget(dateModel, canvas, size);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}

/**
 * 通过组合widget创建item，只需实现相关的方法就可以
 */
abstract class BaseCombineDayWidget extends StatelessWidget {
  final DateModel dateModel;

  BaseCombineDayWidget(this.dateModel);

  @override
  Widget build(BuildContext context) {
    return dateModel.isSelected
        ? getSelectedWidget(dateModel)
        : getNormalWidget(dateModel);
  }

  Widget getNormalWidget(DateModel dateModel);

  Widget getSelectedWidget(DateModel dateModel);
}
