import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/style/style.dart';

import 'base_day_view.dart';

/**
 * 默认的利用组合widget的方式构造item
 */
//class DefaultCombineDayWidget extends StatelessWidget {
//  DateModel dateModel;
//
//  DefaultCombineDayWidget(this.dateModel);
//
//  @override
//  Widget build(BuildContext context) {
//    return Container(
//      margin: EdgeInsets.only(top: 5, bottom: 5),
//      decoration: dateModel.isSelected
//          ? new BoxDecoration(color: Colors.red, shape: BoxShape.circle)
//          : null,
//      child: new Stack(
//        alignment: Alignment.center,
//        children: <Widget>[
//          new Column(
//            mainAxisSize: MainAxisSize.max,
//            crossAxisAlignment: CrossAxisAlignment.center,
//            children: <Widget>[
//              //公历
//              new Expanded(
//                child: Center(
//                  child: new Text(
//                    dateModel.day.toString(),
//                    style: currentMonthTextStyle,
//                  ),
//                ),
//              ),
//
//              //农历
//              new Expanded(
//                child: Center(
//                  child: new Text(
//                    "${dateModel.lunarString}",
//                    style: lunarTextStyle,
//                  ),
//                ),
//              ),
//            ],
//          )
//        ],
//      ),
//    );
//  }
//}

class DefaultCombineDayWidget extends BaseCombineDayWidget {
  DefaultCombineDayWidget(DateModel dateModel) : super(dateModel);

  @override
  Widget getNormalWidget(DateModel dateModel) {
    return Container(
      margin: EdgeInsets.all(8),
      child: new Stack(
        alignment: Alignment.center,
        children: <Widget>[
          new Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //公历
              new Expanded(
                child: Center(
                  child: new Text(
                    dateModel.day.toString(),
                    style: currentMonthTextStyle,
                  ),
                ),
              ),

              //农历
              new Expanded(
                child: Center(
                  child: new Text(
                    "${dateModel.lunarString}",
                    style: lunarTextStyle,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget getSelectedWidget(DateModel dateModel) {
    return Container(
      margin: EdgeInsets.all(8),
      foregroundDecoration:
          new BoxDecoration(border: Border.all(width: 2, color: Colors.blue)),
      child: new Stack(
        alignment: Alignment.center,
        children: <Widget>[
          new Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              //公历
              new Expanded(
                child: Center(
                  child: new Text(
                    dateModel.day.toString(),
                    style: currentMonthTextStyle,
                  ),
                ),
              ),

              //农历
              new Expanded(
                child: Center(
                  child: new Text(
                    "${dateModel.lunarString}",
                    style: lunarTextStyle,
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
