
## FlutterCalendarWidget

A calendar widget in flutter,you can design what you want to show!

Language:English|[中文简体](README.md)

- [FlutterCalendarWidget](#fluttercalendarwidget)
  - [Overview](#overview)
  - [Online Demo](#online-demo)
  - [Example](#example)
- [Getting Started](#getting-started)
- [2.0 version](#20-version)
- [matters needing attention](#matters-needing-attention)
- [API Documentation](#api-documentation)

### Overview

* Support the Gregorian calendar, lunar calendar, solar terms, traditional festivals and common holidays
* Date range setting, the maximum date range supported by default is 1971.01-2055.12
* Disable date range settings. For example, you can click within a range of dates and gray the dates outside the range
* Support single selection and multiple selection modes, and provide multiple selection of callbacks exceeding the limit and multiple selection of callbacks exceeding the specified range.
* Jump to the specified date. Animation switching is supported by default
* Custom Calendar items, support the way of combining widgets and drawing with canvas
* Customize the weekbar at the top
* According to the actual scene, you can add custom additional data to the item to realize various additional functions. For example, to realize the calendar of progress bar style and various marks of calendar
* Support weekly view display, monthly view and weekly view display and switching linkage

### Online Demo

Calendar supports web Preview：[Click here for preview](https://lxd312569496.github.io/flutter_custom_calendar/#/)


### Example

<table>
<tbody>
<tr>
<td>
<img src="https://tva1.sinaimg.cn/large/006y8mN6ly1g8hjt66daxj30n01dsad5.jpg" width="280" height="620">
</td>

<td>
<img src="https://user-gold-cdn.xitu.io/2019/10/9/16db060ca77ecad2?w=828&h=1792&f=png&s=126261" width="280" height="620">
</td>
</tr>

<tr>
<td>
<img src="https://user-gold-cdn.xitu.io/2019/10/9/16db061203661eca?w=828&h=1792&f=png&s=157230" width="280" height="620">
</td>
<td>
<img src="https://user-gold-cdn.xitu.io/2019/10/9/16db0614e44b6e0d?w=828&h=1792&f=png&s=145423" width="280" height="620">
</td>
<td>
<img src="https://user-gold-cdn.xitu.io/2019/10/9/16db0619af4c854a?w=828&h=1792&f=png&s=129203" width="280" height="620">
</td>
</tr>

<tr>
<td>
<img src="https://user-gold-cdn.xitu.io/2019/10/9/16db061ef0ed35dd?w=828&h=1792&f=png&s=81260" width="280" height="620">
</td>
<td>
<img src="https://tva1.sinaimg.cn/large/006y8mN6ly1g8hji5yiqkj30u01sx0wy.jpg" width="280" height="620">
</td>
<td>
<img src="https://tva1.sinaimg.cn/large/006y8mN6ly1g8hjntithzj30u01sxtcl.jpg" width="280" height="620">
</td>
</tr>

</tbody>
</table>


## Getting Started

1.add dependencies into you project pubspec.yaml file:
```
flutter_custom_calendar:
    git:
      url: https://github.com/LXD312569496/flutter_custom_calendar.git
```

2.import flutter_custom_calendar lib
```
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
```

3.create CalendarViewWidget object，profile CalendarController
```
CalendarController controller= new CalendarController(
        minYear: 2018,
        minYearMonth: 1,
        maxYear: 2020,
        maxYearMonth: 12,
        showMode: CalendarConstants.MODE_SHOW_MONTH_AND_WEEK);
CalendarViewWidget calendar= CalendarViewWidget(
              calendarController: controller,
            ),
```

4.operate controller
```
controller.toggleExpandStatus();//Switch between month view and week view
```

```
controller.previousPage();//Action calendar switch to previous page
```

```
controller.nextPage();//Action calendar switch to next page

```


## 2.0 version
Major changes：
* The UI configuration related parameters are moved to the calendar view construction method (the old version is configured in the controller)
* Calendar supports padding and margin attributes, and item size calculation and modification.
* Realize the overall adaptive height of calendar
* The controller provides the method of changing extradatamap, which can dynamically modify the customized data extradatamap at any time.
* It supports the display of monthly view and weekly view, with weekly view as the priority, and mode "show" week "and" month "
* Supports verticalspacing and itemsize properties


## matters needing attention

* If you use the version before 2.0, you need to move the UI configuration related parameters to the calendar view construction method (the old version is configured in the controller).
* I haven't found any other problems for the time being. If you have any, please let me know.
* If you use this library to make a calendar, you can share the display results with me, and I will paste them on the document for display.



## API Documentation

[API Documentation](API.md)


