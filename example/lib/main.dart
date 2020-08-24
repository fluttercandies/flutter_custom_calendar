import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/constants/constants.dart';
import 'package:flutter_custom_calendar/controller.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/utils/LogUtil.dart';

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

  GlobalKey<CalendarContainerState> _globalKey = new GlobalKey();
  @override
  void initState() {
    _selectedDate.add(DateTime.now());
    controller = new CalendarController(
        minYear: 2019,
        minYearMonth: 1,
        maxYear: 2021,
        maxYearMonth: 12,
        showMode: CalendarConstants.MODE_SHOW_WEEK_AND_MONTH,
        selectedDateTimeList: _selectedDate,
        selectMode: CalendarSelectedMode.singleSelect)
      ..addOnCalendarSelectListener((dateModel) {
        _selectedModels.add(dateModel);
        setState(() {
          _selectDate = _selectedModels.toString();
        });
      })
      ..addOnCalendarUnSelectListener((dateModel) {
        LogUtil.log(TAG: '_selectedModels', message: _selectedModels.toString());
        LogUtil.log(TAG: 'dateModel', message: dateModel.toString());
        if (_selectedModels.contains(dateModel)) {
          _selectedModels.remove(dateModel);
        }
        setState(() {
          _selectDate = '';
        });
      });
    calendar = new CalendarViewWidget(
      key: _globalKey,
      calendarController: controller,
      dayWidgetBuilder: (DateModel model) {
        double wd = (MediaQuery.of(context).size.width - 20) / 7;
        bool _isSelected = model.isSelected;
        if (_isSelected &&
            CalendarSelectedMode.singleSelect ==
                controller.calendarConfiguration.selectMode) {
          _selectDate = model.toString();
        }
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
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      controller.addExpandChangeListener((value) {
        /// 添加改变 月视图和 周视图的监听
        _isMonthSelected = value;
        setState(() {});
      });
    });

    super.initState();
  }

  bool _isMonthSelected = false;

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
            _topMonths(),
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
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              FlatButton(
                child: Text(
                  '单选',
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
                  '多选',
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
                  '多选 选择开始和结束',
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
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _topMonths() {
    return SliverToBoxAdapter(
      child: Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: <Widget>[
          Text('月视图和周视图'),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: <Widget>[
              FlatButton(
                child: Text(
                  '月视图',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    controller.weekAndMonthViewChange(
                        CalendarConstants.MODE_SHOW_ONLY_WEEK);
                  });
                },
                color: _isMonthSelected ? Colors.teal : Colors.black38,
              ),
              FlatButton(
                child: Text(
                  '周视图',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  setState(() {
                    controller.weekAndMonthViewChange(
                        CalendarConstants.MODE_SHOW_ONLY_MONTH);
                  });
                },
                color: _isMonthSelected == false ? Colors.teal : Colors.black38,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
