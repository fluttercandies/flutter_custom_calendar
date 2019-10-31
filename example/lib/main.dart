import 'package:example/only_week_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
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
          "/blue_style_page":(context)=>BlueStylePage(
            title:"蓝色背景Demo"
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
            new RaisedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/only_week_view");
              },
              child: new Text("仅显示周视图"),
            ),
            new RaisedButton(onPressed: (){
              Navigator.pushNamed(context, "/blue_style_page");
            },child: new Text("蓝色Demo"),)
          ],
        ),
      ),
    );
  }
}

//
//# Desktop Flutter Example
//
//This is the standard Flutter template application, modified to run on desktop.
//
//The `linux` and `windows` directories serve as early prototypes of
//what will eventually become the `flutter create` templates for desktop, and will
//be evolving over time to better reflect that goal. The `macos` directory has
//now become a `flutter create` template, so is largely identical to what that
//command creates.
//
//## Building and Running
//
//See [the main project README](../README.md).
//
//To build without running, use `flutter build macos`/`windows`/`linux` rather than `flutter run`, as with
//a standard Flutter project.
//
//## Dart Differences from Flutter Template
//
//The `main.dart` and `pubspec.yaml` have minor changes to support desktop:
//* `debugDefaultTargetPlatformOverride` is set to avoid 'Unknown platform'
//exceptions.
//* The font is explicitly set to Roboto, and Roboto is bundled via
//`pubspec.yaml`, to ensure that text displays on all platforms.
//
//See the [Flutter Application Requirements section of the Flutter page on
//desktop support](https://github.com/flutter/flutter/wiki/Desktop-shells#flutter-application-requirements)
//for more information.
//
//## Adapting for Another Project
//
//Since `flutter create` is not yet supported for Windows and Linux, the easiest
//way to try out desktop support with an existing Flutter application on those
//platforms is to copy the platform directories from this example; see below for
//details. For macOS, just run `flutter create --macos .` in your project.
//
//Be sure to read the [Flutter page on desktop
//support](https://github.com/flutter/flutter/wiki/Desktop-shells) before trying to
//run an existing project on desktop, especially the [Flutter Application Requirements
//section](https://github.com/flutter/flutter/wiki/Desktop-shells#flutter-application-requirements).
//
//### Coping the Desktop Runners
//
//The 'linux' and 'windows' directories are self-contained, and can be copied to
//an existing Flutter project, enabling `flutter run` for those platforms.
//
//**Be aware that neither the API surface of the Flutter desktop libraries nor the
//interaction between the `flutter` tool and the platform directories is stable,
//and no attempt will be made to provide supported migration paths as things
//change.** You should expect that every time you update Flutter you may have
//to delete your copies of the platform directories and re-copy them from an
//updated version of flutter-desktop-embedding.
//
//### Customizing the Runners
//
//See [Application Customization](App-Customization.md) for premilinary
//documenation on modifying basic application information like name and icon.
//
//If you are building for macOS, you should also read about [managing macOS
//security configurations](../macOS-Security.md).
