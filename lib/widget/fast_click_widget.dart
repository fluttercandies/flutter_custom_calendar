import 'package:flutter/material.dart';

/**
 * 防止快速点击
 */
class FastClickWidget extends StatelessWidget {
  final int between_time = 500; //默认两次点击间隔500ms内则点击无效

  Function onTap;
  Widget child;

  FastClickWidget({@required this.onTap, @required this.child});

  int lastClickTime = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (lastClickTime == 0 ||
            DateTime.now().millisecondsSinceEpoch - lastClickTime >
                between_time) {
          onTap();
          lastClickTime = DateTime.now().millisecondsSinceEpoch;
        } else {
          //间隔500ms内点击无效
        }
      },
      child: child,
    );
  }
}
