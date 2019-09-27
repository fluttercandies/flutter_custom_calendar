import 'package:flutter/material.dart';
import 'custom_sign_page.dart';
import 'custom_style_page.dart';
import 'default_style_page.dart';
import 'multi_select_style_page.dart';
import 'progress_style_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
              )
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
          ],
        ),
      ),
    );
  }
}
