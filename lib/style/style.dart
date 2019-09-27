import 'package:flutter/material.dart';

//顶部7天的文案
TextStyle topWeekTextStyle = new TextStyle(fontSize: 12);

//当前月份的日期的文字
TextStyle currentMonthTextStyle =
    new TextStyle(color: Colors.black, fontSize: 16);

//下一个月或者上一个月的日期的文字
TextStyle preOrNextMonthTextStyle =
    new TextStyle(color: Colors.grey, fontSize: 18);

//农历的字体
TextStyle lunarTextStyle = new TextStyle(color: Colors.grey, fontSize: 12);

//不是当前月份的日期的文字
TextStyle notCurrentMonthTextStyle =
    new TextStyle(color: Colors.grey, fontSize: 16);

TextStyle currentDayTextStyle = new TextStyle(color: Colors.red, fontSize: 16);
