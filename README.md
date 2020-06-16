## flutter_custom_calendar
> 本插件是基于[flutter_custom_calendar](https://github.com/fluttercandies/flutter_custom_calendar)做了稍微的修改进行上传的。

具体使用方法见[flutter_custom_calendar](https://github.com/ifgyong/flutter_custom_calendar)

新增一个选择`mode`

支持选择开始和结束，选择范围内的日期，使用方法

```
controller = new CalendarController(
    minYear: 2019,
    minYearMonth: 1,
    maxYear: 2021,
    maxYearMonth: 12,
    showMode: CalendarConstants.MODE_SHOW_MONTH_AND_WEEK,
    selectedDateTimeList: _selectedDate,
    selectMode: CalendarSelectedMode.mutltiStartToEndSelect)
  ..addOnCalendarSelectListener((dateModel) {
    _selectedModels.add(dateModel);
  })
  ..addOnCalendarUnSelectListener((dateModel) {
    if (_selectedModels.contains(dateModel)) {
      _selectedModels.remove(dateModel);
    }
  });

```
`CalendarSelectedMode.mutltiStartToEndSelect`这个选择模式会选择开始和结束中间的 默认选择的。


### 安装和使用

Use this package as a library
1. Depend on it
Add this to your package's pubspec.yaml file:

```
dependencies:
  flutter_custom_calendar: ^1.0.3
```

2. Install it
You can install packages from the command line:

with Flutter:

```
$ flutter pub get
```

Alternatively, your editor might support flutter pub get. Check the docs for your editor to learn more.

3. Import it
Now in your Dart code, you can use:

```
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
```


### 动画演示
![](https://github.com/ifgyong/flutter_custom_calendar/blob/master/img.gif)
### [查看API](https://github.com/ifgyong/flutter_custom_calendar/blob/master/API.md)

### [查看一个例子 如何使用](https://github.com/ifgyong/flutter_custom_calendar/blob/master/example/lib/main.dart)
