import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/constants/constants.dart';
import 'package:flutter_custom_calendar/controller.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          focusColor: Colors.teal),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CalendarController controller;
  CalendarViewWidget calendar;
  HashSet<DateTime> _selectedDate = new HashSet();
  HashSet<DateModel> _selectedModels = new HashSet();
  @override
  void initState() {
    _selectedDate.add(DateTime.now());
    controller = new CalendarController(
        minYear: 2019,
        minYearMonth: 1,
        maxYear: 2021,
        maxYearMonth: 12,
        showMode: CalendarConstants.MODE_SHOW_MONTH_AND_WEEK,
        selectedDateTimeList: _selectedDate,
        selectMode: CalendarSelectedMode.singleSelect)
      ..addOnCalendarSelectListener((dateModel) {
        _selectedModels.add(dateModel);
        setState(() {
          _selectDate = _selectedModels.toString();
        });
      })
      ..addOnCalendarUnSelectListener((dateModel) {
        if (_selectedModels.contains(dateModel)) {
          _selectedModels.remove(dateModel);
        }
        setState(() {
          _selectDate = '';
        });
      });
    calendar = new CalendarViewWidget(
      calendarController: controller,
      dayWidgetBuilder: (DateModel model) {
        double wd = (MediaQuery.of(context).size.width - 20) / 7;
        bool _isSelected = model.isSelected;
        return ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(wd / 2)),
          child: Container(
            color: _isSelected ? Theme.of(context).focusColor : Colors.white,
            alignment: Alignment.center,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  model.day.toString(),
                  style: TextStyle(
                      color: model.isCurrentMonth
                          ? (_isSelected == false
                              ? (model.isWeekend
                                  ? Colors.black38
                                  : Colors.black87)
                              : Colors.white)
                          : Colors.black38),
                ),
//              Text(model.lunarDay.toString()),
              ],
            ),
          ),
        );
      },
    );
    super.initState();
  }

  String _selectDate = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: CupertinoScrollbar(
        child: CustomScrollView(
          slivers: <Widget>[
            _topButtons(),
            SliverToBoxAdapter(
              child: calendar,
            ),
            SliverToBoxAdapter(
              child: Container(
                child: Text(
                  ' $_selectDate ',
                  style: TextStyle(color: Theme.of(context).focusColor),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _topButtons() {
    return SliverToBoxAdapter(
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: <Widget>[
          Text('请选择mode'),
          FlatButton(
            child: Text(
              'singleSelect',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              setState(() {
                controller.calendarConfiguration.selectMode =
                    CalendarSelectedMode.singleSelect;
              });
            },
            color: controller.calendarConfiguration.selectMode ==
                    CalendarSelectedMode.singleSelect
                ? Colors.teal
                : Colors.black38,
          ),
          FlatButton(
            child: Text(
              'multiSelect',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              setState(() {
                controller.calendarConfiguration.selectMode =
                    CalendarSelectedMode.multiSelect;
              });
            },
            color: controller.calendarConfiguration.selectMode ==
                    CalendarSelectedMode.multiSelect
                ? Colors.teal
                : Colors.black38,
          ),
          FlatButton(
            child: Text(
              'mutltiStartToEndSelect',
              style: TextStyle(color: Colors.white),
            ),
            onPressed: () {
              setState(() {
                controller.calendarConfiguration.selectMode =
                    CalendarSelectedMode.mutltiStartToEndSelect;
              });
            },
            color: controller.calendarConfiguration.selectMode ==
                    CalendarSelectedMode.mutltiStartToEndSelect
                ? Colors.teal
                : Colors.black38,
          )
        ],
      ),
    );
  }
}
