
## Main API documents

- [Main API documents](#%e4%b8%bb%e8%a6%81api%e6%96%87%e6%a1%a3)
  - [Configure calendar UI](#%e9%85%8d%e7%bd%ae%e6%97%a5%e5%8e%86%e7%9a%84ui)
    - [Parameter description](#%e5%8f%82%e6%95%b0%e8%af%b4%e6%98%8e)
  - [Configure controller](#%e9%85%8d%e7%bd%aecontroller)
    - [Parameter description](#%e9%80%9a%e7%94%a8%e5%8f%82%e6%95%b0%e8%af%b4%e6%98%8e)
    - [Add event listening to controller](#%e7%bb%99controller%e6%b7%bb%e5%8a%a0%e4%ba%8b%e4%bb%b6%e7%9b%91%e5%90%ac)
    - [Using controller to control the switching of calendar and support the configuration of animation](#%e5%88%a9%e7%94%a8controller%e6%9d%a5%e6%8e%a7%e5%88%b6%e6%97%a5%e5%8e%86%e7%9a%84%e5%88%87%e6%8d%a2%e6%94%af%e6%8c%81%e9%85%8d%e7%bd%ae%e5%8a%a8%e7%94%bb)
    - [Using controller to get the status and data of current calendar](#%e5%88%a9%e7%94%a8controller%e6%9d%a5%e8%8e%b7%e5%8f%96%e5%bd%93%e5%89%8d%e6%97%a5%e5%8e%86%e7%9a%84%e7%8a%b6%e6%80%81%e5%92%8c%e6%95%b0%e6%8d%ae)
  - [How to customize UI](#%e5%a6%82%e4%bd%95%e8%87%aa%e5%ae%9a%e4%b9%89ui)
    - [Customize weekbar](#%e8%87%aa%e5%ae%9a%e4%b9%89weekbar)
    - [Custom calendar item](#%e8%87%aa%e5%ae%9a%e4%b9%89%e6%97%a5%e5%8e%86item)
  - [Customize extra data extradata according to the actual scenario](#%e6%a0%b9%e6%8d%ae%e5%ae%9e%e9%99%85%e5%9c%ba%e6%99%af%e8%87%aa%e5%ae%9a%e4%b9%89%e9%a2%9d%e5%a4%96%e7%9a%84%e6%95%b0%e6%8d%aeextradata)
    - [Calendar with progress bar style](#%e5%ae%9e%e7%8e%b0%e8%bf%9b%e5%ba%a6%e6%9d%a1%e6%a0%b7%e5%bc%8f%e7%9a%84%e6%97%a5%e5%8e%86)
    - [Implement custom calendars for various tags](#%e5%ae%9e%e7%8e%b0%e8%87%aa%e5%ae%9a%e4%b9%89%e5%90%84%e7%a7%8d%e6%a0%87%e8%ae%b0%e7%9a%84%e6%97%a5%e5%8e%86)
    - [Modify customized data manually](#%e6%89%8b%e5%8a%a8%e4%bf%ae%e6%94%b9%e8%87%aa%e5%ae%9a%e4%b9%89%e7%9a%84%e6%95%b0%e6%8d%ae)
  - [DateModel Entry](#datemodel%e5%ae%9e%e4%bd%93%e7%b1%bb)

### Configure calendar UI

The configuration of calendar UI is done in the constructor of calendarviewwidget.
```
  CalendarViewWidget(
      {Key key,
      this.dayWidgetBuilder = defaultCustomDayWidget,
      this.weekBarItemWidgetBuilder = defaultWeekBarWidget,
      @required this.calendarController,
      this.boxDecoration,
      this.padding = EdgeInsets.zero,
      this.margin = EdgeInsets.zero,
      this.verticalSpacing = 10,
      this.itemSize})
      : super(key: key);
```
#### Parameter description

|           Attribute      |            Meaning         |             Default value                  |
| :----------------------: | :------------------------: | :--------------------------------------: |
| weekBarItemWidgetBuilder |     Create the weekbar at the top      |                 Default style                 |
|     dayWidgetBuilder     |        Create calendar item        |                 Default style                 |
|     verticalSpacing      | Vertical spacing between calendar items |                  Default is 10                  |
|      boxDecoration       |       calendar background setting       |                 Default is null                 |
|         itemSize         |       Size of each item       | The default screen width of mobile phone / 7, and the default screen height of web page / 7 |
|         padding          |       Calendar padding        |          EdgeInsets.zero           |
|          margin          |       Calendar padding        |          EdgeInsets.zero           |



### Configure controller
Two action：
One is to display the related data required by the calendar, which is configured in the controller.
One is to use the controller to add event monitoring and use the controller to operate the calendar.

```
 //构造函数
 CalendarController(
      {int selectMode = CalendarConstants.MODE_SINGLE_SELECT,
      int showMode = CalendarConstants.MODE_SHOW_ONLY_MONTH,
      int minYear = 1971,
      int maxYear = 2055,
      int minYearMonth = 1,
      int maxYearMonth = 12,
      int nowYear,
      int nowMonth,
      int minSelectYear = 1971,
      int minSelectMonth = 1,
      int minSelectDay = 1,
      int maxSelectYear = 2055,
      int maxSelectMonth = 12,
      int maxSelectDay = 30,
      Set<DateTime> selectedDateTimeList = EMPTY_SET,
      DateModel selectDateModel,
      int maxMultiSelectCount = 9999,
      Map<DateModel, Object> extraDataMap = EMPTY_MAP,
      int offset})
```

#### General parameter description

|        Attribute         |           Meaning            |                                                                                                                                             Default value                                                                                                                                              |
| :-----------------: | :-----------------------: | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
|     selectMode      | Selection mode, indicating single selection or multiple selection |                                                                                                default is single select<br>static const int MODE_SINGLE_SELECT = 1;<br>static const int MODE_MULTI_SELECT = 2;                                                                                                |
|      showMode       |         Display mode          | 默认是只展示月视图<br>static const int MODE_SHOW_ONLY_MONTH=1;//仅支持月视图<br>static const int MODE_SHOW_ONLY_WEEK=2;//仅支持星期视图<br>static const int MODE_SHOW_WEEK_AND_MONTH=3;//支持两种视图，先显示周视图<br>static const int MODE_SHOW_MONTH_AND_WEEK=4;//支持两种视图，先显示月视图 |
|       minYear       |    Minimum year for calendar display     |                                                                                                                                              1971                                                                                                                                               |
|       maxYear       |    Maximum year displayed in calendar     |                                                                                                                                              2055                                                                                                                                               |
|    minYearMonth     | The month of the smallest year displayed by the calendar  |                                                                                                                                                1                                                                                                                                                |
|    maxYearMonth     | The month of the largest year displayed by the calendar  |                                                                                                                                               12                                                                                                                                                |
|       nowYear       |   Current year displayed by calendar    |                                                                                                                                               -1                                                                                                                                                |
|      nowMonth       |   Current month displayed by calendar    |                                                                                                                                               -1                                                                                                                                                |
|    minSelectYear    |    Minimum year that can be selected     |                                                                                                                                              1971                                                                                                                                               |
|   minSelectMonth    | Month of the smallest year that can be selected  |                                                                                                                                                1                                                                                                                                                |
|    minSelectDay     | The day of the smallest month you can choose  |                                                                                                                                                1                                                                                                                                                |
|    maxSelectYear    |    Maximum year that can be selected     |                                                                                                                                              2055                                                                                                                                               |
|   maxSelectMonth    | Month of the largest year you can choose  |                                                                                                                                               12                                                                                                                                                |
|    maxSelectDay     | The day of the largest month you can choose  |                                                                                                                               30，注意：不能超过对应月份的总天数                                                                                                                                |
|  selectedDateList   |   Selected date for multiple selections   |                                                                                                                    默认为空Set, Set<DateModel> selectedDateList = new Set()                                                                                                                     |
|   selectDateModel   |    Current selection, for radio selection    |                                                                                                                                            默认为空                                                                                                                                             |
| maxMultiSelectCount |    Multiple choice, how many at most     |                                                                                                                                               hhh                                                                                                                                               |
|    extraDataMap     |     Customize additional data      |                                                                                                                   默认为空Map，Map<DateTime, Object> extraDataMap = new Map()                                                                                                                   |
|    offset           |   The offset of first day     |                                                                                                                                                           0                                                                                                                  |


#### Add event listening to controller

|                                   Method                                    |          Meaning          | Default value  |
| :-----------------------------------------------------------------------: | :--------------------: | :----: |
|            void addMonthChangeListener(OnMonthChange listener)            |      Month switching event      |
|        void addOnCalendarSelectListener(OnCalendarSelect listener)        |      Click to select an event      |
| void addOnMultiSelectOutOfRangeListener(OnMultiSelectOutOfRange listener) |    Multiple selection out of the specified range    |
|  void addOnMultiSelectOutOfSizeListener(OnMultiSelectOutOfSize listener)  |    Multiple selection exceeds the limit    |
|       void addExpandChangeListener(ValueChanged<bool> expandChange)       | Monitor the expansion and contraction status of calendar |

#### Using controller to control the switching of calendar and support the configuration of animation

|                                                                              Method                                                                               |                                                                       Meaning                                                                        | Default value |
| :-------------------------------------------------------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------------------------------------: | :----: |
|                                                                   Future<bool> previousPage()                                                                   |  Sliding to the previous page will automatically slide to the previous month or week according to the current deployment status. If it is already on the first page and there is no previous page, it will return false, otherwise it will return true  |
|                                                                     Future<bool> nextPage()                                                                     | Sliding to the next page will automatically move to the next month or week according to the current deployment status. If it is already on the last page and there is no next page, it will return false, otherwise it will return true |
| void moveToCalendar(int year, int month, int day, {bool needAnimation = false,Duration duration = const Duration(milliseconds: 500),Curve curve = Curves.ease}) |                                                                    To specified date                                                                     |
|                                                                      void moveToNextYear()                                                                      |                                                                   Switch to next year                                                                    |
|                                                                    void moveToPreviousYear()                                                                    |                                                                   Switch to previous year                                                                    |
|                                                                     void moveToNextMonth()                                                                      |                                                                 Switch to the next month                                                                  |
|                                                                   void moveToPreviousMonth()                                                                    |                                                                 Switch to previous month                                                                  |
|                                                                    void toggleExpandStatus()                                                                    |                                                                   Toggle deployment state                                                                    |
|                                                       void changeExtraData(Map<DateModel, Object> newMap)                                                       |                                                          Modify custom extra data and refresh calendar                                                           |


#### Using controller to get the status and data of current calendar

|                  Method                   |          Meaning          | Default Value |
| :-------------------------------------: | :--------------------: | :----: |
|       DateTime getCurrentMonth()        |     Get the current month     |
| Set<DateModel> getMultiSelectCalendar() | Get selected date,multiple choices  |
|   DateModel getSingleSelectCalendar()   | Get selected date,single choiice |



### How to customize UI

Including custom weekbar and custom calendar item. Defaultxxwidget is used by default.

As long as we inherit the corresponding base class and implement the corresponding methods, then we only need to implement the corresponding builder methods when configuring the controller.

```
//支持自定义绘制
DayWidgetBuilder dayWidgetBuilder; //create calendar item
WeekBarItemWidgetBuilder weekBarItemWidgetBuilder; //create weekbar
```
#### Customize weekbar

The first way is to inherit baseweekbar and override getweekbaritem (index) method. Whatever you do, just return a widget.

```
class DefaultWeekBar extends BaseWeekBar {
  const DefaultWeekBar({Key key}) : super(key: key);
  @override
  Widget getWeekBarItem(int index) {
    /**
    * 自定义Widget
    */
    return new Container(
      height: 40,
      alignment: Alignment.center,
      child: new Text(
        Constants.WEEK_LIST[index],
        style: topWeekTextStyle,
      ),
    );
  }
}
```
In the second way, you can directly rewrite the build method for more custom drawing.

```
class CustomStyleWeekBarItem extends BaseWeekBar {
  List<String> weekList = ["mo", "tu", "we", "th", "fr", "sa", "su"];

  //可以直接重写build方法，weekbar底部添加下划线
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
```


#### Custom calendar item：
There are two methods, one is to create by combining widgets, and the other is to draw items by using canvas. Finally, you only need to configure in the construction parameters of the calendarcontroller。

* Create by combining widgets: inherit basecombinedaywidget, rewrite getnormalwidget (datemodel datemodel) and getselectedwidget (datemodel datemodel), and return the corresponding widget.

```
class DefaultCombineDayWidget extends BaseCombineDayWidget {
  DefaultCombineDayWidget(DateModel dateModel) : super(dateModel);

  @override
  Widget getNormalWidget(DateModel dateModel) {
     //实现默认状态下的UI
  }

  @override
  Widget getSelectedWidget(DateModel dateModel) {
    //绘制被选中的UI
  }
}
```


* Use canvas to define drawing, inherit basecustomdaywidget, rewrite drawnormal and drawselected, and draw item by yourself.

```
class DefaultCustomDayWidget extends BaseCustomDayWidget {
  DefaultCustomDayWidget(DateModel dateModel) : super(dateModel);
  @override
  void drawNormal(DateModel dateModel, Canvas canvas, Size size) {
    //实现默认状态下的UI
    defaultDrawNormal(dateModel, canvas, size);
  }
  @override
  void drawSelected(DateModel dateModel, Canvas canvas, Size size) {
    //绘制被选中的UI
    defaultDrawSelected(dateModel, canvas, size);
  }
}
```

### Customize extra data extradata according to the actual scenario

#### Calendar with progress bar style

We can customize the progress bar data of each item, save it in the map, and finally assign it to the extradatamap of the controller
```
     //Externally process the tag corresponding to each datemodel
    Map<DateModel, int> progressMap = {
      DateModel.fromDateTime(temp.add(Duration(days: 1))): 0,
      DateModel.fromDateTime(temp.add(Duration(days: 2))): 20,
      DateModel.fromDateTime(temp.add(Duration(days: 3))): 40,
      DateModel.fromDateTime(temp.add(Duration(days: 4))): 60,
      DateModel.fromDateTime(temp.add(Duration(days: 5))): 80,
      DateModel.fromDateTime(temp.add(Duration(days: 6))): 100,
    };
    //When creating the calendarcontroller object, assign the extradatamap
    new CalendarController(
        extraDataMap: progressMap)
    //When drawing daywidget, you can get the desired data directly from the extradata object of datemodel
    int progress = dateModel.extraData;
```

#### Implement custom calendars for various tags
```
 //Externally process the tag corresponding to each datemodel
 Map<DateModel, String> customExtraData = {
    DateModel.fromDateTime(DateTime.now().add(Duration(days: -1))): "假",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: -2))): "游",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: -3))): "事",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: -4))): "班",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: -5))): "假",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: -6))): "游",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: 2))): "游",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: 3))): "事",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: 4))): "班",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: 5))): "假",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: 6))): "游",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: 7))): "事",
    DateModel.fromDateTime(DateTime.now().add(Duration(days: 8))): "班",
  };
    //When creating the calendarcontroller object, assign the extradatamap
    new CalendarController(
        extraDataMap: customExtraData)
    //When drawing daywidget, you can get the desired data directly from the extradata object of datemodel
   String data = dateModel.extraData;
```

#### Modify customized data manually

When the customized data changes, you can use the controller's change extradata (map < datemodel, Object > NewMap) method,The calendar will refresh automatically and draw based on the new additional data

```
  //可以动态修改extraDataMap
  void changeExtraData(Map<DateModel, Object> newMap) {
    this.calendarConfiguration.extraDataMap = newMap;
    this.calendarProvider.generation.value++;
  }
```

### DateModel Entry
The entity class datemodel of the date used by the calendar has the following properties. You can draw the corresponding UI after judging according to the corresponding properties when you customize the daywidget.

|       Attribute        |                         Meaning                          |  Type  |  Default Value  |
| :---------------: | :---------------------------------------------------: | :----: | :------: |
|       year        |                         年份                          |  int   |
|       month       |                         月份                          |  int   |
|        day        |                         日期                          |  int   | 默认为1  |
|     lunarYear     |                       农历年份                        |  int   |
|    lunarMonth     |                       农历月份                        |  int   |
|     lunarDay      |                       农历日期                        |  int   |
|    lunarString    |                      农历字符串                       | String |
|     solarTerm     |                        24 solar terms               | String |
| gregorianFestival |                   gregorianFestival                   | String |
| traditionFestival |                     传统农历节日                      | String |
|   isCurrentDay    |                      是否是今天                       |  bool  |  false   |
|    isLeapYear     |                      是否是闰年                       |  bool  |  false   |
|     isWeekend     |                      是否是周末                       |  bool  |  false   |
|     isInRange     | Whether it is in the range, for example, it can set the gray function outside a range |  bool  |  false   |
|    isSelected     |       Is it selected to implement some marking or selection functions        |  bool  |  false   |
|     extraData     |                   Custom extra data                    | Object | 默认为空 |
|  isCurrentMonth   |                    是否是当前月份                     |  bool  |


|                   Method                    |                           Meaning                            |
| :---------------------------------------: | :-------------------------------------------------------: |
|          DateTime getDateTime()           |                 Convert datemodel to datetime                 |
| DateModel fromDateTime(DateTime dateTime) | Create corresponding model according to datetime, and initialize information such as lunar calendar and traditional festivals |
|      bool operator ==(Object other)       |       Override the = = method to determine whether two datemodels are the same day       |