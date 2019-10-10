
## FlutterCalendarWidget

Flutter上的一个日历控件，可以定制成自己想要的样子。

## 介绍
之前写了一个Flutter日历的开源库，最近增加了一些功能，并且对代码进行了一下重构。（之前的代码写得真的是****，没搞状态框架，还各种嵌套代码）

## 示例

日历支持web预览：[点击此处进入预览](https://lxd312569496.github.io/flutter_custom_calendar/#/)

<img src="https://user-gold-cdn.xitu.io/2019/10/9/16db05f93d816799?w=828&h=1792&f=png&s=81540" width="280" height="620">
<img src="https://user-gold-cdn.xitu.io/2019/10/9/16db05fa9949b0af?w=828&h=1792&f=png&s=124266" width="280" height="620">

<img src="https://user-gold-cdn.xitu.io/2019/10/9/16db060ca77ecad2?w=828&h=1792&f=png&s=126261" width="280" height="620">

<img src="https://user-gold-cdn.xitu.io/2019/10/9/16db061203661eca?w=828&h=1792&f=png&s=157230" width="280" height="620">
<img src="https://user-gold-cdn.xitu.io/2019/10/9/16db0614e44b6e0d?w=828&h=1792&f=png&s=145423" width="280" height="620">
<img src="https://user-gold-cdn.xitu.io/2019/10/9/16db0619af4c854a?w=828&h=1792&f=png&s=129203" width="280" height="620">
<img src="https://user-gold-cdn.xitu.io/2019/10/9/16db061ef0ed35dd?w=828&h=1792&f=png&s=81260" width="280" height="620">


## 主要功能
* 支持公历，农历，节气，传统节日，常用节假日
* 日期范围设置，默认支持的最大日期范围为1971.01-2055.12
* 禁用日期范围设置，比如想实现某范围的日期内可以点击，范围外的日期置灰
* 支持单选、多选模式，提供多选超过限制个数的回调和多选超过指定范围的回调。
* 跳转到指定日期，默认支持动画切换
* 自定义日历Item，支持组合widget的方式和利用canvas绘制的方式
* 自定义顶部的WeekBar
* 根据实际场景，可以给Item添加自定义的额外数据，实现各种额外的功能。比如实现进度条风格的日历，实现日历的各种标记
* 支持周视图的展示
* 支持月份视图和星期视图的展示与切换联动

## 近期修改
### [1.0.0] - 2019/10/10
* 重构日历的代码,进行性能优化
* 创建configuration类，将配置的信息放到这里
* 引入provider状态管理,避免深层嵌套传递信息 
* 实现周视图，并实现周视图和月视图之间的联动
* DateModel增加isCurrentMonth，用于绘制月视图可以屏蔽一些非当前月份的日子，前面几天或者后面几天的isCurrentMonth是为false的。

### [0.0.1] - 2019/5/19.

* 支持公历，农历，节气，传统节日，常用节假日
* 日期范围设置，默认支持的最大日期范围为1971.01-2055.12
* 禁用日期范围设置，比如想实现某范围的日期内可以点击，范围外的日期置灰
* 支持单选、多选模式，提供多选超过限制个数的回调和多选超过指定范围的回调。
* 跳转到指定日期，默认支持动画切换
* 自定义日历Item，支持组合widget的方式和利用canvas绘制的方式
* 自定义顶部的WeekBar
* 可以给Item添加自定义的额外数据，实现各种额外的功能。比如实现进度条风格的日历

## 使用

在pubspec.yaml添加依赖:
```
flutter_custom_calendar:
    git:
      url: https://github.com/LXD312569496/flutter_custom_calendar.git
```
引入flutter_custom_calendar,就可以使用CalendarViewWidget，配置CalendarController就可以了。
```
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';

CalendarViewWidget({@required this.calendarController, this.boxDecoration});
```

* boxDecoration用来配置整体的背景
* 利用CalendarController来配置一些数据，并且可以通过CalendarController进行一些操作或者事件监听，比如滚动到下一个月，获取当前被选中的Item等等。

## 配置CalendarController

下面是CalendarController中一些支持自定义配置的属性。不配置的话，会有对应的默认值。（配置现在都是在controller这里进行配置的，内部会将配置的数据抽成Configuration类）

配置的含义主要包括了3个方面的配置。
* 一个是显示日历所需要的相关数据，
* 一个是显示日历的自定义UI的相关配置，
* 一个是对日历的监听事件进行配置。

```
      //构造函数
      CalendarController(
      {int selectMode = Constants.MODE_SINGLE_SELECT,
       int showMode = Constants.MODE_SHOW_ONLY_MONTH,
      bool expandStatus = true,
      DayWidgetBuilder dayWidgetBuilder = defaultCustomDayWidget,
      WeekBarItemWidgetBuilder weekBarItemWidgetBuilder = defaultWeekBarWidget,
      int minYear = 1971,
      int maxYear = 2055,
      int minYearMonth = 1,
      int maxYearMonth = 12,
      int nowYear = -1,
      int nowMonth = -1,
      int minSelectYear = 1971,
      int minSelectMonth = 1,
      int minSelectDay = 1,
      int maxSelectYear = 2055,
      int maxSelectMonth = 12,
      int maxSelectDay = 30,
      Set<DateTime> selectedDateTimeList = EMPTY_SET,
      DateModel selectDateModel,
      int maxMultiSelectCount = 9999,
      double verticalSpacing = 10,
      bool enableExpand = true,
      Map<DateModel, Object> extraDataMap = EMPTY_MAP})

```

### 数据方面的配置

属性 | 含义 | 默认值 
:-: | :-: | :-: 
selectMode | 选择模式,表示单选或者多选 | 默认是单选<br>static const int MODE_SINGLE_SELECT = 1;<br>static const int MODE_MULTI_SELECT = 2;
showMode|展示模式| 默认是只展示月视图<br>static const int MODE_SHOW_ONLY_MONTH=1;//仅支持月视图<br>static const int MODE_SHOW_ONLY_WEEK=2;//仅支持星期视图<br>static const int MODE_SHOW_WEEK_AND_MONTH=3;//支持月和星期视图切换
minYear | 日历显示的最小年份| 1971 
maxYear | 日历显示的最大年份| 2055 
minYearMonth | 日历显示的最小年份的月份| 1 
maxYearMonth | 日历显示的最大年份的月份| 12 
nowYear | 日历显示的当前的年份| -1 
nowMonth | 日历显示的当前的月份| -1 
minSelectYear | 可以选择的最小年份| 1971 
minSelectMonth | 可以选择的最小年份的月份| 1 
minSelectDay | 可以选择的最小月份的日子| 1 
maxSelectYear | 可以选择的最大年份| 2055 
maxSelectMonth | 可以选择的最大年份的月份| 12 
maxSelectDay | 可以选择的最大月份的日子| 30，注意：不能超过对应月份的总天数 
selectedDateList | 被选中的日期,用于多选| 默认为空Set, Set<DateModel> selectedDateList = new Set()
selectDateModel | 当前选择项,用于单选| 默认为空 
maxMultiSelectCount | 多选，最多选多少个| hhh 
extraDataMap | 自定义额外的数据| 默认为空Map，Map<DateTime, Object> extraDataMap = new Map()


### UI绘制相关的配置

属性 | 含义 | 默认值 
:-: | :-: | :-: 
weekBarItemWidgetBuilder | 创建顶部的weekbar | 默认样式
dayWidgetBuilder | 创建日历item | 默认样式
verticalSpacing|日历item之间的竖直方向间距|默认10
boxDecoration |整体的背景设置|
itemSize| 每个item的边长|默认是屏幕宽度/7|


### 事件监听的配置

方法 | 含义 | 默认值 
:-: | :-: | :-: 
void addMonthChangeListener(OnMonthChange listener) | 月份切换事件 | 
void addOnCalendarSelectListener(OnCalendarSelect listener) | 点击选择事件 | 
void addOnMultiSelectOutOfRangeListener(OnMultiSelectOutOfRange listener) | 多选超出指定范围 | 
void addOnMultiSelectOutOfSizeListener(OnMultiSelectOutOfSize listener) | 多选超出限制个数 | 
void addExpandChangeListener(ValueChanged<bool> expandChange)|监听日历的展开收缩状态|

##  利用controller来控制日历的切换，支持配置动画

方法 | 含义 | 默认值 
:-: | :-: | :-: 
Future<bool> previousPage()|滑动到上一个页面，会自动根据当前的展开状态，滑动到上一个月或者上一个星期。如果已经在第一个页面，没有上一个页面，就会返回false，其他情况返回true| 
Future<bool> nextPage()|滑动到下一个页面，会自动根据当前的展开状态，滑动到下一个月或者下一个星期。如果已经在最后一个页面，没有下一个页面，就会返回false，其他情况返回true|
void moveToCalendar(int year, int month, int day, {bool needAnimation = false,Duration duration = const Duration(milliseconds: 500),Curve curve = Curves.ease}) | 到指定日期 | 
void moveToNextYear()|切换到下一年|
void moveToPreviousYear()|切换到上一年|    
void moveToNextMonth()|切换到下一个月份|
void moveToPreviousMonth()|切换到上一个月份|
void toggleExpandStatus()|切换展开状态|


## 利用controller来获取日历的一些数据信息

方法 | 含义 | 默认值 
:-: | :-: | :-: 
DateTime getCurrentMonth()|获取当前的月份|
Set<DateModel> getMultiSelectCalendar()|获取被选中的日期,多选|
DateModel getSingleSelectCalendar()|获取被选中的日期，单选|


## 如何自定义UI

包括自定义WeekBar、自定义日历Item，默认使用的都是DefaultXXXWidget。

只要继承对应的Base类，实现相应的方法，然后只需要在配置Controller的时候，实现相应的Builder方法就可以了。
```
//支持自定义绘制
DayWidgetBuilder dayWidgetBuilder; //创建日历item
WeekBarItemWidgetBuilder weekBarItemWidgetBuilder; //创建顶部的weekbar
```
### 自定义WeekBar
继承BaseWeekBar，重写getWeekBarItem(index)方法就可以。随便你怎么实现，只需要返回一个Widget就可以了。
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
### 自定义日历Item：
提供两种方法，一种是利用组合widget的方式来创建，一种是利用Canvas来自定义绘制Item。最后只需要在CalendarController的构造参数中进行配置就可以了。
* 继承BaseCombineDayWidget，重写getNormalWidget(DateModel dateModel)
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


* 继承BaseCustomDayWidget，重写drawNormal和drawSelected的两个方法就可以了，利用canvas自己绘制Item。

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

#### 自定义每个item的进度条数据

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

#### 自定义各种标记
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



## DateModel实体类
日历所用的日期的实体类DateModel，有下面这些属性。可以在自定义绘制DayWidget的时候，根据相应的属性，进行判断后，绘制相应的UI。

属性|含义|类型|默认值
:-: | :-: | :-: |:-:
year|年份|int|
month|月份|int|
day|日期|int|默认为1
lunarYear|农历年份|int|
lunarMonth|农历月份|int|
lunarDay|农历日期|int|
lunarString|农历字符串|String|
solarTerm|24节气|String|
gregorianFestival|gregorianFestival|String|
traditionFestival|传统农历节日|String|
isCurrentDay|是否是今天|bool|false
isLeapYear|是否是闰年|bool|false
isWeekend|是否是周末|bool|false
isInRange|是否在范围内,比如可以实现在某个范围外，设置置灰的功能|bool|false
isSelected|是否被选中，用来实现一些标记或者选择功能|bool|false
extraData|自定义的额外数据|Object|默认为空


方法|含义|
:-: | :-: |
DateTime getDateTime()|将DateModel转化成DateTime
DateModel fromDateTime(DateTime dateTime)|根据DateTime创建对应的model，并初始化农历和传统节日等信息
bool operator ==(Object other)|重写==方法，可以判断两个dateModel是否是同一天