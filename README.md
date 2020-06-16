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


