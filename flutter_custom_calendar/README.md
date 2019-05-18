FlutterCalendarWidget

Flutter上的一个日历控件，可以定制成自己想要的样子。
<img src="https://user-gold-cdn.xitu.io/2019/5/18/16acb76a959b93b3?w=828&h=1792&f=jpeg&s=92910">
<img src="https://user-gold-cdn.xitu.io/2019/5/18/16acb793e4dbd2f2?w=828&h=1792&f=jpeg&s=102231">
<img src="https://user-gold-cdn.xitu.io/2019/5/18/16acb79f153ab321?w=828&h=1792&f=jpeg&s=1288910">
<img src="https://user-gold-cdn.xitu.io/2019/5/18/16acb7a35d41361c?w=828&h=1792&f=jpeg&s=10674210">


## 主要功能
* 支持公历，农历，节气，传统节日，常用节假日
* 日期范围设置，默认支持的最大日期范围为1971.01-2055.12
* 禁用日期范围设置，比如想实现某范围的日期内可以点击，范围外的日期置灰
* 支持单选、多选模式，提供多选超过限制个数的回调和多选超过指定范围的回调。
* 跳转到指定日期，默认支持动画切换
* 自定义日历Item，支持组合widget的方式和利用canvas绘制的方式
* 自定义顶部的WeekBar
* 可以给Item添加自定义的额外数据，实现各种额外的功能。比如实现进度条风格的日历

## 使用
引入flutter_custom_calendar,就可以使用CalendarViewWidget，配置CalendarController就可以了。
```
CalendarViewWidget({@required this.calendarController, this.boxDecoration});
```
* boxDecoration用来配置整体的背景
* 利用CalendarController来配置一些数据，并且可以通过CalendarController进行一些操作或者事件监听，比如滚动到下一个月，获取当前被选中的Item等等。

下面是CalendarController中一些支持自定义配置的属性。不配置的话，会有对应的默认值。
```
//默认是单选,可以配置为MODE_SINGLE_SELECT，MODE_MULTI_SELECT
int selectMode;

//日历显示的最小年份和最大年份
int minYear;
int maxYear;

//日历显示的最小年份的月份，最大年份的月份
int minYearMonth;
int maxYearMonth;

//日历显示的当前的年份和月份
int nowYear;
int nowMonth;

//可操作的范围设置,比如点击选择
int minSelectYear;
int minSelectMonth;
int minSelectDay;

int maxSelectYear;
int maxSelectMonth;
int maxSelectDay; //注意：不能超过对应月份的总天数

Set<DateModel> selectedDateList = new Set(); //被选中的日期,用于多选
DateModel selectDateModel; //当前选择项,用于单选
int maxMultiSelectCount; //多选，最多选多少个
Map<DateTime, Object> extraDataMap = new Map(); //自定义额外的数据

//各种事件回调
OnMonthChange monthChange; //月份切换事件
OnCalendarSelect calendarSelect; //点击选择事件
OnMultiSelectOutOfRange multiSelectOutOfRange; //多选超出指定范围
OnMultiSelectOutOfSize multiSelectOutOfSize; //多选超出限制个数

//支持自定义绘制
DayWidgetBuilder dayWidgetBuilder; //创建日历item
WeekBarItemWidgetBuilder weekBarItemWidgetBuilder; //创建顶部的weekbar
```

### 利用controller添加监听事件
比如月份切换事件、点击选择事件。
```
//月份切换监听
void addMonthChangeListener(OnMonthChange listener) {
  this.monthChange = listener;
}
//点击选择监听
void addOnCalendarSelectListener(OnCalendarSelect listener) {
  this.calendarSelect = listener;
}
//多选超出指定范围
void addOnMultiSelectOutOfRangeListener(OnMultiSelectOutOfRange listener) {
  this.multiSelectOutOfRange = listener;
}
//多选超出限制个数
void addOnMultiSelectOutOfSizeListener(OnMultiSelectOutOfSize listener) {
  this.multiSelectOutOfSize = listener;
}
```

###  利用controller来控制日历的切换，支持配置动画

```
//跳转到指定日期
void moveToCalendar(int year, int month, int day,
    {bool needAnimation = false,
    Duration duration = const Duration(milliseconds: 500),
    Curve curve = Curves.ease});
//切换到下一年
void moveToNextYear();
//切换到上一年
void moveToPreviousYear();
//切换到下一个月份,
void moveToNextMonth();
//切换到上一个月份
void moveToPreviousMonth();
```

### 利用controller来获取日历的一些数据信息
```
// 获取当前的月份
DateTime getCurrentMonth();
//获取被选中的日期,多选
Set<DateModel> getMultiSelectCalendar();
//获取被选中的日期，单选
DateModel getSingleSelectCalendar();
```

### 自定义UI

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
### DateModel实体类
日历所用的日期的实体类DateModel，有下面这些属性。
```
/**
 * 日期的实体类
 */
class DateModel {
  int year;
  int month;
  int day = 1;
  int lunarYear;
  int lunarMonth;
  int lunarDay;
  String lunarString; //农历字符串
  String solarTerm; //24节气
  String gregorianFestival; //公历节日
  String traditionFestival; //传统农历节日
  bool isCurrentDay; //是否是今天
  bool isLeapYear; //是否是闰年
  bool isWeekend; //是否是周末
  int leapMonth; //是否是闰月
  Object extraData; //自定义的额外数据
  bool isInRange = false; //是否在范围内,比如可以实现在某个范围外，设置置灰的功能
  bool isSelected; //是否被选中，用来实现一些标记或者选择功能
  @override
  String toString() {
    return 'DateModel{year: $year, month: $month, day: $day}';
  } //如果是闰月，则返回闰月

  //转化成DateTime格式
  DateTime getDateTime() {
    return new DateTime(year, month, day);
  }
  //根据DateTime创建对应的model，并初始化农历和传统节日等信息
  static DateModel fromDateTime(DateTime dateTime) {
    DateModel dateModel = new DateModel()
      ..year = dateTime.year
      ..month = dateTime.month
      ..day = dateTime.day;
    LunarUtil.setupLunarCalendar(dateModel);
    return dateModel;
  }
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DateModel &&
          runtimeType == other.runtimeType &&
          year == other.year &&
          month == other.month &&
          day == other.day;
  @override
  int get hashCode => year.hashCode ^ month.hashCode ^ day.hashCode;
}
```

## TODO LIST
* 优化代码实现
* 支持屏蔽指定的某些天
* 继续写几个不同风格的Demo
* 支持周视图
* 支持动画切换周视图和月视图
