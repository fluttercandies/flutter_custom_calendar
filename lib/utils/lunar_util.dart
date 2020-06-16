import 'package:flutter_custom_calendar/flutter_custom_calendar.dart';
import 'package:flutter_custom_calendar/utils/solar_term_util.dart';

///**
///* 农历的工具类
///*/
class LunarUtil {
  static List<int> LUNAR_MONTH_DAYS = [
    1887,
    0x1694,
    0x16aa,
    0x4ad5,
    0xab6,
    0xc4b7,
    0x4ae,
    0xa56,
    0xb52a,
    0x1d2a,
    0xd54,
    0x75aa,
    0x156a,
    0x1096d,
    0x95c,
    0x14ae,
    0xaa4d,
    0x1a4c,
    0x1b2a,
    0x8d55,
    0xad4,
    0x135a,
    0x495d,
    0x95c,
    0xd49b,
    0x149a,
    0x1a4a,
    0xbaa5,
    0x16a8,
    0x1ad4,
    0x52da,
    0x12b6,
    0xe937,
    0x92e,
    0x1496,
    0xb64b,
    0xd4a,
    0xda8,
    0x95b5,
    0x56c,
    0x12ae,
    0x492f,
    0x92e,
    0xcc96,
    0x1a94,
    0x1d4a,
    0xada9,
    0xb5a,
    0x56c,
    0x726e,
    0x125c,
    0xf92d,
    0x192a,
    0x1a94,
    0xdb4a,
    0x16aa,
    0xad4,
    0x955b,
    0x4ba,
    0x125a,
    0x592b,
    0x152a,
    0xf695,
    0xd94,
    0x16aa,
    0xaab5,
    0x9b4,
    0x14b6,
    0x6a57,
    0xa56,
    0x1152a,
    0x1d2a,
    0xd54,
    0xd5aa,
    0x156a,
    0x96c,
    0x94ae,
    0x14ae,
    0xa4c,
    0x7d26,
    0x1b2a,
    0xeb55,
    0xad4,
    0x12da,
    0xa95d,
    0x95a,
    0x149a,
    0x9a4d,
    0x1a4a,
    0x11aa5,
    0x16a8,
    0x16d4,
    0xd2da,
    0x12b6,
    0x936,
    0x9497,
    0x1496,
    0x1564b,
    0xd4a,
    0xda8,
    0xd5b4,
    0x156c,
    0x12ae,
    0xa92f,
    0x92e,
    0xc96,
    0x6d4a,
    0x1d4a,
    0x10d65,
    0xb58,
    0x156c,
    0xb26d,
    0x125c,
    0x192c,
    0x9a95,
    0x1a94,
    0x1b4a,
    0x4b55,
    0xad4,
    0xf55b,
    0x4ba,
    0x125a,
    0xb92b,
    0x152a,
    0x1694,
    0x96aa,
    0x15aa,
    0x12ab5,
    0x974,
    0x14b6,
    0xca57,
    0xa56,
    0x1526,
    0x8e95,
    0xd54,
    0x15aa,
    0x49b5,
    0x96c,
    0xd4ae,
    0x149c,
    0x1a4c,
    0xbd26,
    0x1aa6,
    0xb54,
    0x6d6a,
    0x12da,
    0x1695d,
    0x95a,
    0x149a,
    0xda4b,
    0x1a4a,
    0x1aa4,
    0xbb54,
    0x16b4,
    0xada,
    0x495b,
    0x936,
    0xf497,
    0x1496,
    0x154a,
    0xb6a5,
    0xda4,
    0x15b4,
    0x6ab6,
    0x126e,
    0x1092f,
    0x92e,
    0xc96,
    0xcd4a,
    0x1d4a,
    0xd64,
    0x956c,
    0x155c,
    0x125c,
    0x792e,
    0x192c,
    0xfa95,
    0x1a94,
    0x1b4a,
    0xab55,
    0xad4,
    0x14da,
    0x8a5d,
    0xa5a,
    0x1152b,
    0x152a,
    0x1694,
    0xd6aa,
    0x15aa,
    0xab4,
    0x94ba,
    0x14b6,
    0xa56,
    0x7527,
    0xd26,
    0xee53,
    0xd54,
    0x15aa,
    0xa9b5,
    0x96c,
    0x14ae,
    0x8a4e,
    0x1a4c,
    0x11d26,
    0x1aa4,
    0x1b54,
    0xcd6a,
    0xada,
    0x95c,
    0x949d,
    0x149a,
    0x1a2a,
    0x5b25,
    0x1aa4,
    0xfb52,
    0x16b4,
    0xaba,
    0xa95b,
    0x936,
    0x1496,
    0x9a4b,
    0x154a,
    0x136a5,
    0xda4,
    0x15ac
  ];

  static List<int> SOLAR = [
    1887,
    0xec04c,
    0xec23f,
    0xec435,
    0xec649,
    0xec83e,
    0xeca51,
    0xecc46,
    0xece3a,
    0xed04d,
    0xed242,
    0xed436,
    0xed64a,
    0xed83f,
    0xeda53,
    0xedc48,
    0xede3d,
    0xee050,
    0xee244,
    0xee439,
    0xee64d,
    0xee842,
    0xeea36,
    0xeec4a,
    0xeee3e,
    0xef052,
    0xef246,
    0xef43a,
    0xef64e,
    0xef843,
    0xefa37,
    0xefc4b,
    0xefe41,
    0xf0054,
    0xf0248,
    0xf043c,
    0xf0650,
    0xf0845,
    0xf0a38,
    0xf0c4d,
    0xf0e42,
    0xf1037,
    0xf124a,
    0xf143e,
    0xf1651,
    0xf1846,
    0xf1a3a,
    0xf1c4e,
    0xf1e44,
    0xf2038,
    0xf224b,
    0xf243f,
    0xf2653,
    0xf2848,
    0xf2a3b,
    0xf2c4f,
    0xf2e45,
    0xf3039,
    0xf324d,
    0xf3442,
    0xf3636,
    0xf384a,
    0xf3a3d,
    0xf3c51,
    0xf3e46,
    0xf403b,
    0xf424e,
    0xf4443,
    0xf4638,
    0xf484c,
    0xf4a3f,
    0xf4c52,
    0xf4e48,
    0xf503c,
    0xf524f,
    0xf5445,
    0xf5639,
    0xf584d,
    0xf5a42,
    0xf5c35,
    0xf5e49,
    0xf603e,
    0xf6251,
    0xf6446,
    0xf663b,
    0xf684f,
    0xf6a43,
    0xf6c37,
    0xf6e4b,
    0xf703f,
    0xf7252,
    0xf7447,
    0xf763c,
    0xf7850,
    0xf7a45,
    0xf7c39,
    0xf7e4d,
    0xf8042,
    0xf8254,
    0xf8449,
    0xf863d,
    0xf8851,
    0xf8a46,
    0xf8c3b,
    0xf8e4f,
    0xf9044,
    0xf9237,
    0xf944a,
    0xf963f,
    0xf9853,
    0xf9a47,
    0xf9c3c,
    0xf9e50,
    0xfa045,
    0xfa238,
    0xfa44c,
    0xfa641,
    0xfa836,
    0xfaa49,
    0xfac3d,
    0xfae52,
    0xfb047,
    0xfb23a,
    0xfb44e,
    0xfb643,
    0xfb837,
    0xfba4a,
    0xfbc3f,
    0xfbe53,
    0xfc048,
    0xfc23c,
    0xfc450,
    0xfc645,
    0xfc839,
    0xfca4c,
    0xfcc41,
    0xfce36,
    0xfd04a,
    0xfd23d,
    0xfd451,
    0xfd646,
    0xfd83a,
    0xfda4d,
    0xfdc43,
    0xfde37,
    0xfe04b,
    0xfe23f,
    0xfe453,
    0xfe648,
    0xfe83c,
    0xfea4f,
    0xfec44,
    0xfee38,
    0xff04c,
    0xff241,
    0xff436,
    0xff64a,
    0xff83e,
    0xffa51,
    0xffc46,
    0xffe3a,
    0x10004e,
    0x100242,
    0x100437,
    0x10064b,
    0x100841,
    0x100a53,
    0x100c48,
    0x100e3c,
    0x10104f,
    0x101244,
    0x101438,
    0x10164c,
    0x101842,
    0x101a35,
    0x101c49,
    0x101e3d,
    0x102051,
    0x102245,
    0x10243a,
    0x10264e,
    0x102843,
    0x102a37,
    0x102c4b,
    0x102e3f,
    0x103053,
    0x103247,
    0x10343b,
    0x10364f,
    0x103845,
    0x103a38,
    0x103c4c,
    0x103e42,
    0x104036,
    0x104249,
    0x10443d,
    0x104651,
    0x104846,
    0x104a3a,
    0x104c4e,
    0x104e43,
    0x105038,
    0x10524a,
    0x10543e,
    0x105652,
    0x105847,
    0x105a3b,
    0x105c4f,
    0x105e45,
    0x106039,
    0x10624c,
    0x106441,
    0x106635,
    0x106849,
    0x106a3d,
    0x106c51,
    0x106e47,
    0x10703c,
    0x10724f,
    0x107444,
    0x107638,
    0x10784c,
    0x107a3f,
    0x107c53,
    0x107e48
  ];

  ////**
  ///* 保存每年24节气
  ///*/
  static final Map<int, List<String>> SOLAR_TERMS = new Map();

  ////**
  ///* 公历节日
  ///*/
  static List<String> SOLAR_CALENDAR = [
    "0101元旦",
    "0214情人节",
    "0308妇女节",
    "0312植树节",
    "0315消权日",
    "0401愚人节",
    "0422地球日",
    "0501劳动节",
    "0504青年节",
    "0601儿童节",
    "0701建党节",
    "0801建军节",
    "0910教师节",
    "1001国庆节",
    "1031万圣节",
    "1111光棍节",
    "1224平安夜",
    "1225圣诞节",
  ];

  /**
   * 传统农历节日
   */
  static List<String> TRADITION_FESTIVAL_STR = [
    "除夕",
    "0101春节",
    "0115元宵",
    "0505端午",
    "0707七夕",
    "0815中秋",
    "0909重阳",
  ];

  /**
   * 特殊节日、母亲节和父亲节,感恩节等
   */
  static final Map<int, List<String>> SPECIAL_FESTIVAL = new Map();

  /**
   * 特殊节日的数组
   */
  static List<String> SPECIAL_FESTIVAL_STR = [
    "母亲节",
    "父亲节",
    "感恩节",
  ];

  /**
   * 用来表示1900年到2099年间农历年份的相关信息，共24位bit的16进制表示，其中：
   * 1. 前4位表示该年闰哪个月；
   * 2. 5-17位表示农历年份13个月的大小月分布，0表示小，1表示大；
   * 3. 最后7位表示农历年首（正月初一）对应的公历日期。
   * <p/>
   * 以2014年的数据0x955ABF为例说明：
   * 1001 0101 0101 1010 1011 1111
   * 闰九月 农历正月初一对应公历1月31号
   */
  static final List<int> LUNAR_INFO = [
    0x84B6BF,
    /*1900*/
    0x04AE53,
    0x0A5748,
    0x5526BD,
    0x0D2650,
    0x0D9544,
    0x46AAB9,
    0x056A4D,
    0x09AD42,
    0x24AEB6,
    0x04AE4A,
    /*1901-1910*/
    0x6A4DBE,
    0x0A4D52,
    0x0D2546,
    0x5D52BA,
    0x0B544E,
    0x0D6A43,
    0x296D37,
    0x095B4B,
    0x749BC1,
    0x049754,
    /*1911-1920*/
    0x0A4B48,
    0x5B25BC,
    0x06A550,
    0x06D445,
    0x4ADAB8,
    0x02B64D,
    0x095742,
    0x2497B7,
    0x04974A,
    0x664B3E,
    /*1921-1930*/
    0x0D4A51,
    0x0EA546,
    0x56D4BA,
    0x05AD4E,
    0x02B644,
    0x393738,
    0x092E4B,
    0x7C96BF,
    0x0C9553,
    0x0D4A48,
    /*1931-1940*/
    0x6DA53B,
    0x0B554F,
    0x056A45,
    0x4AADB9,
    0x025D4D,
    0x092D42,
    0x2C95B6,
    0x0A954A,
    0x7B4ABD,
    0x06CA51,
    /*1941-1950*/
    0x0B5546,
    0x555ABB,
    0x04DA4E,
    0x0A5B43,
    0x352BB8,
    0x052B4C,
    0x8A953F,
    0x0E9552,
    0x06AA48,
    0x6AD53C,
    /*1951-1960*/
    0x0AB54F,
    0x04B645,
    0x4A5739,
    0x0A574D,
    0x052642,
    0x3E9335,
    0x0D9549,
    0x75AABE,
    0x056A51,
    0x096D46,
    /*1961-1970*/
    0x54AEBB,
    0x04AD4F,
    0x0A4D43,
    0x4D26B7,
    0x0D254B,
    0x8D52BF,
    0x0B5452,
    0x0B6A47,
    0x696D3C,
    0x095B50,
    /*1971-1980*/
    0x049B45,
    0x4A4BB9,
    0x0A4B4D,
    0xAB25C2,
    0x06A554,
    0x06D449,
    0x6ADA3D,
    0x0AB651,
    0x095746,
    0x5497BB,
    /*1981-1990*/
    0x04974F,
    0x064B44,
    0x36A537,
    0x0EA54A,
    0x86B2BF,
    0x05AC53,
    0x0AB647,
    0x5936BC,
    0x092E50,
    0x0C9645,
    /*1991-2000*/
    0x4D4AB8,
    0x0D4A4C,
    0x0DA541,
    0x25AAB6,
    0x056A49,
    0x7AADBD,
    0x025D52,
    0x092D47,
    0x5C95BA,
    0x0A954E,
    /*2001-2010*/
    0x0B4A43,
    0x4B5537,
    0x0AD54A,
    0x955ABF,
    0x04BA53,
    0x0A5B48,
    0x652BBC,
    0x052B50,
    0x0A9345,
    0x474AB9,
    /*2011-2020*/
    0x06AA4C,
    0x0AD541,
    0x24DAB6,
    0x04B64A,
    0x6a573D,
    0x0A4E51,
    0x0D2646,
    0x5E933A,
    0x0D534D,
    0x05AA43,
    /*2021-2030*/
    0x36B537,
    0x096D4B,
    0xB4AEBF,
    0x04AD53,
    0x0A4D48,
    0x6D25BC,
    0x0D254F,
    0x0D5244,
    0x5DAA38,
    0x0B5A4C,
    /*2031-2040*/
    0x056D41,
    0x24ADB6,
    0x049B4A,
    0x7A4BBE,
    0x0A4B51,
    0x0AA546,
    0x5B52BA,
    0x06D24E,
    0x0ADA42,
    0x355B37,
    /*2041-2050*/
    0x09374B,
    0x8497C1,
    0x049753,
    0x064B48,
    0x66A53C,
    0x0EA54F,
    0x06AA44,
    0x4AB638,
    0x0AAE4C,
    0x092E42,
    /*2051-2060*/
    0x3C9735,
    0x0C9649,
    0x7D4ABD,
    0x0D4A51,
    0x0DA545,
    0x55AABA,
    0x056A4E,
    0x0A6D43,
    0x452EB7,
    0x052D4B,
    /*2061-2070*/
    0x8A95BF,
    0x0A9553,
    0x0B4A47,
    0x6B553B,
    0x0AD54F,
    0x055A45,
    0x4A5D38,
    0x0A5B4C,
    0x052B42,
    0x3A93B6,
    /*2071-2080*/
    0x069349,
    0x7729BD,
    0x06AA51,
    0x0AD546,
    0x54DABA,
    0x04B64E,
    0x0A5743,
    0x452738,
    0x0D264A,
    0x8E933E,
    /*2081-2090*/
    0x0D5252,
    0x0DAA47,
    0x66B53B,
    0x056D4F,
    0x04AE45,
    0x4A4EB9,
    0x0A4D4C,
    0x0D1541,
    0x2D92B5 /*2091-2099*/
  ];

  /**
   * 初始化各种农历、节日
   *
   * @param calendar calendar
   */
  static void setupLunarCalendar(DateModel dateModel) {
    int year = dateModel.year;
    int month = dateModel.month;
    int day = dateModel.day;

//    dateModel.isWeekend = DateUtil.isWeekend(new DateTime(year, month, day));
//    dateModel.isLeapYear = DateUtil.isLeapYear(year);
//    dateModel.isCurrentDay = DateUtil.isCurrentDay(year, month, day);

    List<int> lunar = LunarUtil.solarToLunar(2020, 2, day);

//    dateModel.lunarYear = (lunar[0]);
//    dateModel.lunarMonth = (lunar[1]);
//    dateModel.lunarDay = (lunar[2]);

//    if (lunar[3] == 1) {
//      //如果是闰月
//      dateModel.leapMonth = lunar[1];
//    }
    //24节气
//    String solarTerm = getSolarTerm(year, month, day);
//    dateModel.solarTerm=solarTerm;
//    //公历节日
//    String gregorian = gregorianFestival(month, day);
//    dateModel.gregorianFestival=gregorian;
//    //传统农历节日
//    String festival = getTraditionFestival(lunar[0], lunar[1], lunar[2]);
//    dateModel.traditionFestival=festival;
    //农历格式的日期
    String lunarText = numToChinese(lunar[1], lunar[2], lunar[3]);

//    if (gregorian.isEmpty) {
//      gregorian = getSpecialFestival(year, month, day);
//    }
//    if (solarTerm.isNotEmpty) {
//      dateModel.lunarString = solarTerm;
//    } else if (gregorian.isNotEmpty) {
//      dateModel.lunarString = gregorian;
//    } else if (festival.isNotEmpty) {
//      dateModel.lunarString = festival;
//    } else {
//      dateModel.lunarString = lunarText;
//    }
  }

  /**
   * 公历转农历 Solar To Lunar
   *
   * @param year  公历年
   * @param month 公历月
   * @param day   公历日
   * @return [0]农历年 [1]农历月 [2]农历日 [3]是否闰月 0 false : 1 true
   */
  static List<int> solarToLunar(int year, int month, int day) {
    List<int> lunarInt = new List(4);
    int index = year - SOLAR[0];
    int data = (year << 9) | (month << 5) | (day);
    int solar11;
    if (SOLAR[index] > data) {
      index--;
    }
    solar11 = SOLAR[index];
    int y = getBitInt(solar11, 12, 9);
    int m = getBitInt(solar11, 4, 5);
    int d = getBitInt(solar11, 5, 0);
    int offset = solarToInt(year, month, day) - solarToInt(y, m, d);

    int days = LUNAR_MONTH_DAYS[index];
    int leap = getBitInt(days, 4, 13);

    int lunarY = index + SOLAR[0];
    int lunarM = 1;
    int lunarD;
    offset += 1;

    for (int i = 0; i < 13; i++) {
      int dm = getBitInt(days, 1, 12 - i) == 1 ? 30 : 29;
      if (offset > dm) {
        lunarM++;
        offset -= dm;
      } else {
        break;
      }
    }

    lunarD = offset;
    lunarInt[0] = lunarY;
    lunarInt[1] = lunarM;
    lunarInt[3] = 0;

    if (leap != 0 && lunarM > leap) {
      lunarInt[1] = lunarM - 1;
      if (lunarM == leap + 1) {
        lunarInt[3] = 1;
      }
    }
    lunarInt[2] = lunarD;
    return lunarInt;
  }

  static int getBitInt(int data, int length, int shift) {
    return (data & (((1 << length) - 1) << shift)) >> shift;
  }

  static int solarToInt(int y, int m, int d) {
    m = (m + 9) % 12;
    y = y - (m / 10).toInt();
    return (365 * y +
        (y / 4).toInt() -
        (y / 100).toInt() +
        (y / 400).toInt() +
        ((m * 306 + 5) / 10).toInt() +
        (d - 1));
  }

  /**
   * 返回24节气
   *
   * @param year  年
   * @param month 月
   * @param day   日
   * @return 返回24节气
   */
  static String getSolarTerm(int year, int month, int day) {
    if (!SOLAR_TERMS.containsKey(year)) {
      SOLAR_TERMS.addAll({year: SolarTermUtil.getSolarTerms(year)});
    }
    List<String> solarTerm = SOLAR_TERMS[year];
    String text = "${year}" + getString(month, day);
    String solar = "";
    for (String solarTermName in solarTerm) {
      if (solarTermName.contains(text)) {
        solar = solarTermName.replaceAll(text, "");
        break;
      }
    }
    return solar;
  }

  /**
   * 数字转换为农历节日或者日期
   *
   * @param month 月
   * @param day   日
   * @param leap  1==闰月
   * @return 数字转换为汉字日
   */
  static String numToChinese(int month, int day, int leap) {
    if (day == 1) {
      return numToChineseMonth(month, leap);
    }
    return CalendarConstants.LUNAR_DAY_TEXT[day - 1];
  }

  /**
   * 数字转换为汉字月份
   *
   * @param month 月
   * @param leap  1==闰月
   * @return 数字转换为汉字月份
   */
  static String numToChineseMonth(int month, int leap) {
    if (leap == 1) {
      return "闰" + CalendarConstants.LUNAR_MONTH_TEXT[month - 1];
    }
    return CalendarConstants.LUNAR_MONTH_TEXT[month - 1];
  }

  static String getString(int month, int day) {
    return (month >= 10 ? month.toString() : "0$month") +
        (day >= 10 ? day.toString() : "0$day");
  }

  /**
   * 获取公历节日
   *
   * @param month 公历月份
   * @param day   公历日期
   * @return 公历节日
   */
  static String gregorianFestival(int month, int day) {
    String text = getString(month, day);
    String solar = "";
    for (String aMSolarCalendar in SOLAR_CALENDAR) {
      if (aMSolarCalendar.contains(text)) {
        solar = aMSolarCalendar.replaceAll(text, "");
        break;
      }
    }
    return solar;
  }

  /**
   * 返回传统农历节日
   *
   * @param year  农历年
   * @param month 农历月
   * @param day   农历日
   * @return 返回传统农历节日
   */
  static String getTraditionFestival(int year, int month, int day) {
    if (month == 12) {
      int count = daysInLunarMonth(year, month);
      if (day == count) {
        return TRADITION_FESTIVAL_STR[0]; //除夕
      }
    }
    String text = getString(month, day);
    String festivalStr = "";
    for (String festival in TRADITION_FESTIVAL_STR) {
      if (festival.contains(text)) {
        festivalStr = festival.replaceAll(text, "");
        break;
      }
    }
    return festivalStr;
  }

  /**
   * 传回农历 year年month月的总天数，总共有13个月包括闰月
   *
   * @param year  将要计算的年份
   * @param month 将要计算的月份
   * @return 传回农历 year年month月的总天数
   */
  static int daysInLunarMonth(int year, int month) {
    if ((LUNAR_INFO[year - 1900] & (0x100000 >> month)) == 0)
      return 29;
    else
      return 30;
  }

  /**
   * 获取特殊计算方式的节日
   * 如：每年五月的第二个星期日为母亲节，六月的第三个星期日为父亲节
   * 每年11月第四个星期四定为"感恩节"
   *
   * @param year  year
   * @param month month
   * @param day   day
   * @return 获取西方节日
   */
  static String getSpecialFestival(int year, int month, int day) {
    if (!SPECIAL_FESTIVAL.containsKey(year)) {
      SPECIAL_FESTIVAL.addAll({year: getSpecialFestivals(year)});
    }
    List<String> specialFestivals = SPECIAL_FESTIVAL[year];
    String text = "$year" + getString(month, day);
    String solar = "";
    for (String special in specialFestivals) {
      if (special.contains(text)) {
        solar = special.replaceAll(text, "");
        break;
      }
    }
    return solar;
  }

  /**
   * 获取每年的母亲节和父亲节和感恩节
   * 特殊计算方式的节日
   *
   * @param year 年
   * @return 获取每年的母亲节和父亲节、感恩节
   */
  static List<String> getSpecialFestivals(int year) {
    List<String> festivals = new List(3);
    DateTime dateTime = new DateTime(year, 5, 1);

    //母亲节
    int week = (dateTime.weekday + 1) % 8;
    int startDiff = 7 - week + 1;
    if (startDiff == 7) {
      festivals[0] =
          dateToString(year, 5, startDiff + 1) + SPECIAL_FESTIVAL_STR[0];
    } else {
      festivals[0] =
          dateToString(year, 5, startDiff + 7 + 1) + SPECIAL_FESTIVAL_STR[0];
    }

    //父亲节
    dateTime = new DateTime(year, 6, 1);

    week = (dateTime.weekday + 1) % 8;
    startDiff = 7 - week + 1;
    if (startDiff == 7) {
      festivals[1] =
          dateToString(year, 6, startDiff + 7 + 1) + SPECIAL_FESTIVAL_STR[1];
    } else {
      festivals[1] = dateToString(year, 6, startDiff + 7 + 7 + 1) +
          SPECIAL_FESTIVAL_STR[1];
    }

    //感恩节
    dateTime = new DateTime(year, 11, 1);
    week = (dateTime.weekday + 1) % 8;

    startDiff = 7 - week + 1;
    if (startDiff <= 2) {
      festivals[2] =
          dateToString(year, 11, startDiff + 21 + 5) + SPECIAL_FESTIVAL_STR[2];
    } else {
      festivals[2] =
          dateToString(year, 11, startDiff + 14 + 5) + SPECIAL_FESTIVAL_STR[2];
    }
    return festivals;
  }

  static String dateToString(int year, int month, int day) {
    return "$year" + getString(month, day);
  }
}
