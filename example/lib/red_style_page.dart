import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';

class RedStylePage extends StatefulWidget {
  RedStylePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RedStylePageState createState() => _RedStylePageState();
}

class _RedStylePageState extends State<RedStylePage> {
  ValueNotifier<String> text;
  ValueNotifier<String> selectText;

  CalendarController controller;

  Map<DateModel, String> customExtraData = {};

  Color pinkColor = Color(0xffFF8291);

  @override
  void initState() {
    super.initState();

    controller = new CalendarController(
        showMode: CalendarConstants.MODE_SHOW_MONTH_AND_WEEK,
        extraDataMap: customExtraData);

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
    var calendarWidget = CalendarViewWidget(
      calendarController: controller,
      margin: EdgeInsets.only(top: 20),
      weekBarItemWidgetBuilder: () {
        return CustomStyleWeekBarItem();
      },
      dayWidgetBuilder: (dateModel) {
        return CustomStyleDayWidget(dateModel);
      },
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(),
        body: new Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: new Column(
            crossAxisAlignment:CrossAxisAlignment.stretch ,
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Stack(
                alignment: Alignment.center,
                children: <Widget>[
                  ValueListenableBuilder(
                      valueListenable: text,
                      builder: (context, value, child) {
                        return new Text(
                          "${text.value}",
                          style: TextStyle(
                              fontSize: 20,
                              color: Colors.black,
                              fontWeight: FontWeight.w700),
                        );
                      }),
                  Positioned(
                    left: 0,
                    child: Icon(
                      Icons.notifications,
                      color: pinkColor,
                    ),
                  ),
                  Positioned(
                    right: 40,
                    child: Icon(
                      Icons.search,
                      color: pinkColor,
                    ),
                  ),
                  Positioned(
                    right: 0,
                    child: Icon(
                      Icons.add,
                      color: pinkColor,
                    ),
                  ),
                ],
              ),
              calendarWidget,
              ValueListenableBuilder(
                  valueListenable: selectText,
                  builder: (context, value, child) {
                    return Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: new Text(selectText.value),
                    );
                  }),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.toggleExpandStatus();
          },
          tooltip: 'Increment',
          child: Icon(Icons.add),
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }
}

class CustomStyleWeekBarItem extends BaseWeekBar {
  final List<String> weekList = ["M", "T", "W", "T", "F", "S", "S"];

  //可以直接重写build方法
  @override
  Widget build(BuildContext context) {
    List<Widget> children = List();

    var items = getWeekDayWidget();
    children.add(Row(
      children: items,
    ));
    children.add(Divider(
      color: Colors.grey,
    ));
    return Column(
      children: children,
    );
  }

  @override
  Widget getWeekBarItem(int index) {
    return new Container(
      margin: EdgeInsets.only(top: 10, bottom: 10),
      child: new Center(
        child: new Text(
          weekList[index],
          style:
              TextStyle(fontWeight: FontWeight.w700, color: Color(0xffBBC0C6)),
        ),
      ),
    );
  }
}

class CustomStyleDayWidget extends BaseCombineDayWidget {
  CustomStyleDayWidget(DateModel dateModel) : super(dateModel);

  final TextStyle normalTextStyle =
      TextStyle(fontWeight: FontWeight.w700, color: Colors.black);

  final TextStyle noIsCurrentMonthTextStyle =
      TextStyle(fontWeight: FontWeight.w700, color: Colors.grey);

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
                    style: dateModel.isCurrentMonth
                        ? normalTextStyle
                        : noIsCurrentMonthTextStyle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget getSelectedWidget(DateModel dateModel) {
    return Container(
//      margin: EdgeInsets.all(8),
      decoration: new BoxDecoration(
        shape: BoxShape.circle,
        color: Color(0xffFF8291),
      ),
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
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
