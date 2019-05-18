class Math {
  static double abs(double num) {
    if (num < 0) {
      return -num;
    } else {
      return num;
    }
  }
}

class System {
//todo：后面再检查这个方法是否正确
//  src:源数组；
//  srcPos:源数组要复制的起始位置；
//  dest:目的数组；
//  destPos:目的数组放置的起始位置；
//  length:复制的长度。
  static void arraycopy(List<String> src, int srcPos, List<String> dest,
      int destPos, int length) {
    List.copyRange(dest, destPos, src, srcPos, srcPos+length);
  }
}
