
## 主要Api文档

- [主要Api文档](#%e4%b8%bb%e8%a6%81api%e6%96%87%e6%a1%a3)
  - [配置日历的UI](#%e9%85%8d%e7%bd%ae%e6%97%a5%e5%8e%86%e7%9a%84ui)
    - [参数说明](#%e5%8f%82%e6%95%b0%e8%af%b4%e6%98%8e)
  - [配置Controller](#%e9%85%8d%e7%bd%aecontroller)
    - [通用参数说明](#%e9%80%9a%e7%94%a8%e5%8f%82%e6%95%b0%e8%af%b4%e6%98%8e)
    - [给controller添加事件监听](#%e7%bb%99controller%e6%b7%bb%e5%8a%a0%e4%ba%8b%e4%bb%b6%e7%9b%91%e5%90%ac)
    - [利用controller来控制日历的切换，支持配置动画](#%e5%88%a9%e7%94%a8controller%e6%9d%a5%e6%8e%a7%e5%88%b6%e6%97%a5%e5%8e%86%e7%9a%84%e5%88%87%e6%8d%a2%e6%94%af%e6%8c%81%e9%85%8d%e7%bd%ae%e5%8a%a8%e7%94%bb)
    - [利用controller来获取当前日历的状态和数据](#%e5%88%a9%e7%94%a8controller%e6%9d%a5%e8%8e%b7%e5%8f%96%e5%bd%93%e5%89%8d%e6%97%a5%e5%8e%86%e7%9a%84%e7%8a%b6%e6%80%81%e5%92%8c%e6%95%b0%e6%8d%ae)
  - [如何自定义UI](#%e5%a6%82%e4%bd%95%e8%87%aa%e5%ae%9a%e4%b9%89ui)
    - [自定义WeekBar](#%e8%87%aa%e5%ae%9a%e4%b9%89weekbar)
    - [自定义日历Item：](#%e8%87%aa%e5%ae%9a%e4%b9%89%e6%97%a5%e5%8e%86item)
  - [根据实际场景，自定义额外的数据extraData](#%e6%a0%b9%e6%8d%ae%e5%ae%9e%e9%99%85%e5%9c%ba%e6%99%af%e8%87%aa%e5%ae%9a%e4%b9%89%e9%a2%9d%e5%a4%96%e7%9a%84%e6%95%b0%e6%8d%aeextradata)
    - [实现进度条样式的日历](#%e5%ae%9e%e7%8e%b0%e8%bf%9b%e5%ba%a6%e6%9d%a1%e6%a0%b7%e5%bc%8f%e7%9a%84%e6%97%a5%e5%8e%86)
    - [实现自定义各种标记的日历](#%e5%ae%9e%e7%8e%b0%e8%87%aa%e5%ae%9a%e4%b9%89%e5%90%84%e7%a7%8d%e6%a0%87%e8%ae%b0%e7%9a%84%e6%97%a5%e5%8e%86)
    - [手动修改自定义的数据](#%e6%89%8b%e5%8a%a8%e4%bf%ae%e6%94%b9%e8%87%aa%e5%ae%9a%e4%b9%89%e7%9a%84%e6%95%b0%e6%8d%ae)
  - [DateModel实体类](#datemodel%e5%ae%9e%e4%bd%93%e7%b1%bb)

### 配置日历的UI

日历UI相关的配置是在CalendarViewWidget的构造函数里面进行配置就行了。
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
#### 参数说明

|           属性           |            含义            |                  默认值                  |
| :----------------------: | :------------------------: | :--------------------------------------: |
| weekBarItemWidgetBuilder |     创建顶部的weekbar      |                 默认样式                 |
|     dayWidgetBuilder     |        创建日历item        |                 默认样式                 |
|     verticalSpacing      | 日历item之间的竖直方向间距 |                  默认10                  |
|      boxDecoration       |       整体的背景设置       |                 默认为空                 |
|         itemSize         |       每个item的边长       | 手机默认是屏幕宽度/7，网页默认屏幕高度/7 |
|         padding          |       日历的padding        |          默认为EdgeInsets.zero           |
|          margin          |       日历的padding        |          默认为EdgeInsets.zero           |



### 配置Controller
两个作用：
一个是显示日历所需要的相关数据，是在controller里面进行配置的。
一个是可以利用controller添加事件监听，使用controller进行操作日历


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
      int offset = 0})
```

#### 通用参数说明

|        属性         |           含义            |                                                                                                                                             默认值                                                                                                                                              |
| :-----------------: | :-----------------------: | :---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------: |
|     selectMode      | 选择模式,表示单选或者多选 |                                                                                                默认是单选<br>static const int MODE_SINGLE_SELECT = 1;<br>static const int MODE_MULTI_SELECT = 2;                                                                                                |
|      showMode       |         展示模式          | 默认是只展示月视图<br>static const int MODE_SHOW_ONLY_MONTH=1;//仅支持月视图<br>static const int MODE_SHOW_ONLY_WEEK=2;//仅支持星期视图<br>static const int MODE_SHOW_WEEK_AND_MONTH=3;//支持两种视图，先显示周视图<br>static const int MODE_SHOW_MONTH_AND_WEEK=4;//支持两种视图，先显示月视图 |
|       minYear       |    日历显示的最小年份     |                                                                                                                                              1971                                                                                                                                               |
|       maxYear       |    日历显示的最大年份     |                                                                                                                                              2055                                                                                                                                               |
|    minYearMonth     | 日历显示的最小年份的月份  |                                                                                                                                                1                                                                                                                                                |
|    maxYearMonth     | 日历显示的最大年份的月份  |                                                                                                                                               12                                                                                                                                                |
|       nowYear       |   日历显示的当前的年份    |                                                                                                                                               -1                                                                                                                                                |
|      nowMonth       |   日历显示的当前的月份    |                                                                                                                                               -1                                                                                                                                                |
|    minSelectYear    |    可以选择的最小年份     |                                                                                                                                              1971                                                                                                                                               |
|   minSelectMonth    | 可以选择的最小年份的月份  |                                                                                                                                                1                                                                                                                                                |
|    minSelectDay     | 可以选择的最小月份的日子  |                                                                                                                                                1                                                                                                                                                |
|    maxSelectYear    |    可以选择的最大年份     |                                                                                                                                              2055                                                                                                                                               |
|   maxSelectMonth    | 可以选择的最大年份的月份  |                                                                                                                                               12                                                                                                                                                |
|    maxSelectDay     | 可以选择的最大月份的日子  |                                                                                                                               30，注意：不能超过对应月份的总天数                                                                                                                                      |
|  selectedDateList   |   被选中的日期,用于多选   |                                                                                                                    默认为空Set, Set<DateModel> selectedDateList = new Set()                                                                                                                     |
|   selectDateModel   |    当前选择项,用于单选    |                                                                                                                                            默认为空                                                                                                                                             |
| maxMultiSelectCount |    多选，最多选多少个     |                                                                                                                                               hhh                                                                                                                                               |
|    extraDataMap     |     自定义额外的数据      |                                                                                                                   默认为空Map，Map<DateTime, Object> extraDataMap = new Map()                                                                                                                   |
|    offset     |     首日偏移量      |                                                                                                                                                          0                                                                                                                                               |


#### 给controller添加事件监听

|                                   方法                                    |          含义          | 默认值 |
| :-----------------------------------------------------------------------: | :--------------------: | :----: |
|            void addMonthChangeListener(OnMonthChange listener)            |      月份切换事件      |
|        void addOnCalendarSelectListener(OnCalendarSelect listener)        |      点击选择事件      |
| void addOnMultiSelectOutOfRangeListener(OnMultiSelectOutOfRange listener) |    多选超出指定范围    |
|  void addOnMultiSelectOutOfSizeListener(OnMultiSelectOutOfSize listener)  |    多选超出限制个数    |
|       void addExpandChangeListener(ValueChanged<bool> expandChange)       | 监听日历的展开收缩状态 |

#### 利用controller来控制日历的切换，支持配置动画

|                                                                              方法                                                                               |                                                                       含义                                                                        | 默认值 |
| :-------------------------------------------------------------------------------------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------------------------------------------------------------------: | :----: |
|                                                                   Future<bool> previousPage()                                                                   |  滑动到上一个页面，会自动根据当前的展开状态，滑动到上一个月或者上一个星期。如果已经在第一个页面，没有上一个页面，就会返回false，其他情况返回true  |
|                                                                     Future<bool> nextPage()                                                                     | 滑动到下一个页面，会自动根据当前的展开状态，滑动到下一个月或者下一个星期。如果已经在最后一个页面，没有下一个页面，就会返回false，其他情况返回true |
| void moveToCalendar(int year, int month, int day, {bool needAnimation = false,Duration duration = const Duration(milliseconds: 500),Curve curve = Curves.ease}) |                                                                    到指定日期                                                                     |
|                                                                      void moveToNextYear()                                                                      |                                                                   切换到下一年                                                                    |
|                                                                    void moveToPreviousYear()                                                                    |                                                                   切换到上一年                                                                    |
|                                                                     void moveToNextMonth()                                                                      |                                                                 切换到下一个月份                                                                  |
|                                                                   void moveToPreviousMonth()                                                                    |                                                                 切换到上一个月份                                                                  |
|                                                                    void toggleExpandStatus()                                                                    |                                                                   切换展开状态                                                                    |
|                                                       void changeExtraData(Map<DateModel, Object> newMap)                                                       |                                                          修改自定义的额外数据并刷新日历                                                           |


#### 利用controller来获取当前日历的状态和数据

|                  方法                   |          含义          | 默认值 |
| :-------------------------------------: | :--------------------: | :----: |
|       DateTime getCurrentMonth()        |     获取当前的月份     |
| Set<DateModel> getMultiSelectCalendar() | 获取被选中的日期,多选  |
|   DateModel getSingleSelectCalendar()   | 获取被选中的日期，单选 |



### 如何自定义UI

包括自定义WeekBar、自定义日历Item，默认使用的都是DefaultXXXWidget。

只要继承对应的Base类，实现相应的方法，然后只需要在配置Controller的时候，实现相应的Builder方法就可以了。
```
//支持自定义绘制
DayWidgetBuilder dayWidgetBuilder; //创建日历item
WeekBarItemWidgetBuilder weekBarItemWidgetBuilder; //创建顶部的weekbar
```
#### 自定义WeekBar
第一种做法，继承BaseWeekBar，重写getWeekBarItem(index)方法就可以。随便你怎么实现，只需要返回一个Widget就可以了。
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
第二种做法，你也可以直接重写build方法，进行更加的自定义绘制。

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


#### 自定义日历Item：
提供两种方法，一种是利用组合widget的方式来创建，一种是利用Canvas来自定义绘制Item。最后只需要在CalendarController的构造参数中进行配置就可以了。
* 利用组合widget的方式来创建：继承BaseCombineDayWidget，重写getNormalWidget(DateModel dateModel)
和getSelectedWidget(DateModel dateModel)就可以了，返回对应的widget就行。
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


* 利用Canvas来自定义绘制，继承BaseCustomDayWidget，重写drawNormal和drawSelected的两个方法就可以了，利用canvas自己绘制Item。

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

### 根据实际场景，自定义额外的数据extraData

#### 实现进度条样式的日历

我们可以自定义每个item的进度条数据，保存到map中，最后赋值给controller的extraDataMap。
```
    //外部处理每个dateModel所对应的进度
    Map<DateModel, int> progressMap = {
      DateModel.fromDateTime(temp.add(Duration(days: 1))): 0,
      DateModel.fromDateTime(temp.add(Duration(days: 2))): 20,
      DateModel.fromDateTime(temp.add(Duration(days: 3))): 40,
      DateModel.fromDateTime(temp.add(Duration(days: 4))): 60,
      DateModel.fromDateTime(temp.add(Duration(days: 5))): 80,
      DateModel.fromDateTime(temp.add(Duration(days: 6))): 100,
    };
    //创建CalendarController对象的时候，将extraDataMap赋值就行了
    new CalendarController(
        extraDataMap: progressMap)
    //绘制DayWidget的时候，可以直接从dateModel的extraData对象中拿到想要的数据
    int progress = dateModel.extraData;
```

#### 实现自定义各种标记的日历
```
 //外部处理每个dateModel所对应的标记
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
    //创建CalendarController对象的时候，将extraDataMap赋值就行了
    new CalendarController(
        extraDataMap: customExtraData)
    //绘制DayWidget的时候，可以直接从dateModel的extraData对象中拿到想要的数据
   String data = dateModel.extraData;
```

#### 手动修改自定义的数据
当自定义的数据发生变化的时候，可以使用controller的changeExtraData(Map<DateModel, Object> newMap)方法，
日历会自动刷新，根据新的额外数据进行绘制。
```
  //可以动态修改extraDataMap
  void changeExtraData(Map<DateModel, Object> newMap) {
    this.calendarConfiguration.extraDataMap = newMap;
    this.calendarProvider.generation.value++;
  }
```

### DateModel实体类
日历所用的日期的实体类DateModel，有下面这些属性。可以在自定义绘制DayWidget的时候，根据相应的属性，进行判断后，绘制相应的UI。

|       属性        |                         含义                          |  类型  |  默认值  |
| :---------------: | :---------------------------------------------------: | :----: | :------: |
|       year        |                         年份                          |  int   |
|       month       |                         月份                          |  int   |
|        day        |                         日期                          |  int   | 默认为1  |
|     lunarYear     |                       农历年份                        |  int   |
|    lunarMonth     |                       农历月份                        |  int   |
|     lunarDay      |                       农历日期                        |  int   |
|    lunarString    |                      农历字符串                       | String |
|     solarTerm     |                        24节气                         | String |
| gregorianFestival |                   gregorianFestival                   | String |
| traditionFestival |                     传统农历节日                      | String |
|   isCurrentDay    |                      是否是今天                       |  bool  |  false   |
|    isLeapYear     |                      是否是闰年                       |  bool  |  false   |
|     isWeekend     |                      是否是周末                       |  bool  |  false   |
|     isInRange     | 是否在范围内,比如可以实现在某个范围外，设置置灰的功能 |  bool  |  false   |
|    isSelected     |       是否被选中，用来实现一些标记或者选择功能        |  bool  |  false   |
|     extraData     |                   自定义的额外数据                    | Object | 默认为空 |
|  isCurrentMonth   |                    是否是当前月份                     |  bool  |


|                   方法                    |                           含义                            |
| :---------------------------------------: | :-------------------------------------------------------: |
|          DateTime getDateTime()           |                 将DateModel转化成DateTime                 |
| DateModel fromDateTime(DateTime dateTime) | 根据DateTime创建对应的model，并初始化农历和传统节日等信息 |
|      bool operator ==(Object other)       |       重写==方法，可以判断两个dateModel是否是同一天       |