import 'only_week_page.dart';
import 'red_style_page.dart';
import 'package:flutter/material.dart';
import 'blue_style_page.dart';
import 'custom_sign_page.dart';
import 'custom_style_page.dart';
import 'default_style_page.dart';
import 'multi_select_style_page.dart';
import 'progress_style_page.dart';

void main() {
//  debugProfileBuildsEnabled=true;
//  debugProfilePaintsEnabled=true;
//  debugPrintRebuildDirtyWidgets=true;
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
//        checkerboardOffscreenLayers: true, // 使用了saveLayer的图形会显示为棋盘格式并随着页面刷新而闪烁
        routes: <String, WidgetBuilder>{
          "/default": (context) => DefaultStylePage(
                title: "默认风格+单选",
              ),
          "/custom": (context) => CustomStylePage(
                title: "自定义风格+单选",
              ),
          "/multi_select": (context) => MultiSelectStylePage(
                title: "自定义风格+多选",
              ),
          "/progress": (context) => ProgressStylePage(
                title: "进度条风格+单选",
              ),
          "/custom_sign": (context) => CustomSignPage(
                title: "自定义额外数据，实现标记功能",
              ),
          "/only_week_view": (context) => OnlyWeekPage(
                title: "仅显示周视图",
              ),
          "/blue_style_page": (context) => BlueStylePage(title: "蓝色背景Demo"),
          "/red_style_page": (context) => RedStylePage(title: "蓝色背景Demo"),
        },
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: SafeArea(
        child: new Column(
          children: <Widget>[
            new RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/default");
              },
              child: new Text("默认风格+单选"),
            ),
            new RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/custom");
              },
              child: new Text("自定义风格+单选"),
            ),
            new RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/multi_select");
              },
              child: new Text("自定义风格+多选"),
            ),
            new RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/progress");
              },
              child: new Text("进度条风格+单选"),
            ),
            new RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/custom_sign");
              },
              child: new Text("自定义额外数据，实现标记功能"),
            ),
            new RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/only_week_view");
              },
              child: new Text("仅显示周视图"),
            ),
            new RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/blue_style_page");
              },
              child: new Text("蓝色Demo"),
            ),
            new RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/red_style_page");
              },
              child: new Text("红色Demo"),
            )
          ],
        ),
      ),
    );
  }
}
