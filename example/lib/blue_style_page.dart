import 'package:flutter/material.dart';
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';


class BlueStylePage extends StatefulWidget {
  BlueStylePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _BlueStylePageState createState() => _BlueStylePageState();
}

class _BlueStylePageState extends State<BlueStylePage> {
  ValueNotifier<String> text;
  ValueNotifier<String> selectText;

  CalendarController controller;

  Map<DateModel, String> customExtraData = {};

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
      weekBarItemWidgetBuilder: () {
        return CustomStyleWeekBarItem();
      },
      dayWidgetBuilder: (dateModel) {
        return CustomStyleDayWidget(dateModel);
      },
      calendarController: controller,
      boxDecoration: BoxDecoration(
        borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
        color: Colors.white,
      ),
      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
      margin: const EdgeInsets.only(
        left: 15,
        right: 15,
      ),
    );

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xff6219EC),
        ),
        backgroundColor: Color(0xff6219EC),
        body: new Container(
          child: new Column(
            children: <Widget>[
              SizedBox(
                height: 20,
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Container(
                    height: 100,
                    margin: const EdgeInsets.only(left: 15, right: 15),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20),
                          topRight: Radius.circular(20),
                        ),
                        color: Colors.white),
                    child: Row(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 30),
                          child: RichText(
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: "Februaly",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 30),
                                ),
                                TextSpan(
                                  text: " 2019",
                                  style: TextStyle(
                                      color: Colors.black, fontSize: 30),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  calendarWidget
                ],
              ),
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
  final List<String> weekList = ["mo", "tu", "we", "th", "fr", "sa", "su"];

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
              TextStyle(fontWeight: FontWeight.w700, color: Color(0xffC5BCDC)),
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
        borderRadius: BorderRadius.all(
          Radius.circular(5),
        ),
        color: Color(0xffFED32B),
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
}
