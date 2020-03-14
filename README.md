
## FlutterCalendarWidget

Flutter上的一个日历控件，可以定制成自己想要的样子。

Language: [English](README_en.md)|中文简体

- [FlutterCalendarWidget](#fluttercalendarwidget)
  - [概述](#%e6%a6%82%e8%bf%b0)
  - [在线Demo](#%e5%9c%a8%e7%ba%bfdemo)
  - [效果图](#%e6%95%88%e6%9e%9c%e5%9b%be)
- [使用](#%e4%bd%bf%e7%94%a8)
- [2.0版本](#20%e7%89%88%e6%9c%ac)
- [注意事项](#%e6%b3%a8%e6%84%8f%e4%ba%8b%e9%a1%b9)
- [主要API文档](#%e4%b8%bb%e8%a6%81api%e6%96%87%e6%a1%a3)

### 概述

* 支持公历，农历，节气，传统节日，常用节假日
* 日期范围设置，默认支持的最大日期范围为1971.01-2055.12
* 禁用日期范围设置，比如想实现某范围的日期内可以点击，范围外的日期置灰
* 支持单选、多选模式，提供多选超过限制个数的回调和多选超过指定范围的回调。
* 跳转到指定日期，默认支持动画切换
* 自定义日历Item，支持组合widget的方式和利用canvas绘制的方式
* 自定义顶部的WeekBar
* 根据实际场景，可以给Item添加自定义的额外数据，实现各种额外的功能。比如实现进度条风格的日历，实现日历的各种标记
* 支持周视图的展示,支持月份视图和星期视图的展示与切换联动

### 在线Demo

日历支持web预览：[点击此处进入预览](https://lxd312569496.github.io/flutter_custom_calendar/#/)


### 效果图

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


## 使用

1.在pubspec.yaml文件里面添加依赖:
```
flutter_custom_calendar:
    git:
      url: https://github.com/LXD312569496/flutter_custom_calendar.git
```

2.导入flutter_custom_calendar库
```
import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
```

3.创建CalendarViewWidget对象，配置CalendarController
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

* boxDecoration用来配置整体的背景
* 利用CalendarController来配置一些数据，并且可以通过CalendarController进行一些操作或者事件监听，比如滚动到下一个月，获取当前被选中的Item等等。

4.操作日历
```
controller.toggleExpandStatus();//月视图和周视图的切换
```

```
controller.previousPage();//操作日历切换到上一页
```

```
controller.nextPage();//操作日历切换到下一页
```


## 2.0版本
主要改动：
* UI配置相关的参数，移动到CalendarView的构造方法里面（旧版本是在controller里面配置）
* 日历支持padding和margin属性，item的大小计算修改
* 实现日历整体自适应高度
* controller提供changeExtraDataMap的方法，可以随时动态的修改自定义数据extraDataMap
* 支持显示月视图和周视图的情况，优先显示周视图，MODE_SHOW_WEEK_AND_MONTH
* 支持verticalSpacing和itemSize属性


## 注意事项

* 如果使用2.0之前的版本，则需要将UI配置相关的参数，移动到CalendarView的构造方法里面（旧版本是在controller里面配置）
* 暂时没有发现其他问题，如果有其他问题，可以跟我说一下。
* 如果你用这个库做了日历，可以将展示结果分享给我，我贴到文档上进行展示

## 主要API文档

[API Documentation](API.md)

