import 'package:flutter/material.dart';

class AppColors {
  static const Color primary = Color(0xFF804EEC);

  static const Color primaryRed = Color(0xFFD1345B);

  static const Color dark = Color(0xFF191621);

  static const Color drawerTextColor = Color(0xFF1A1B1C);

  static const Color subText = Color(0xFF6C7785);

  static const Color greenDark = Color(0xFF1B5E20);

  static const Color inputFieldBg = Color(0xFFF4F4F4);

  static const Color background = Color(0xFFF5F6FA);

  static const Color black = Color(0xFF000000);

  static const Color redOrange = Color(0xFFFF3939);

  static const Color white = Color(0xFFFFFFFF);

  static const Color border = Color(0xFFE9EAFF);

  static const Color orange = Color(0xFFF48503);
  static const Color uploadOrangeColor = Color(0xFFECA34E);

  static const Color orangeLight = Color(0xFFFDECCB);

  static const Color redLight = Color(0xFFFFD7E1);

  static const Color cinderBlack = Color(0xFF101315);

  static const Color tealishBlue = Color(0xff041d42);

  static const Color blue = Color(0xff14133E);

  static const Color gray = Color(0xffF0F0FA);
  static const Color lightGray = Color(0xffF1F1F6);

  static const Color tableGray = Color(0xfff8f9fd);

  static const Color skinColor = Color(0xffFFC9B7);

  static const Color strokeColor = Color(0xffF3EDFF);

  static const Color deepSkyBlue = Color(0xff0085FF);

  static const Color sunShade = Color(0xffFF9F2D);

  static const Color davyGray = Color(0xff585757);

  static const Color mediumGreen = Color(0xff00BA34);

  static const Color tyrianPurple = Color(0xffC765EA);

  static const Color holidayBackgroundColor = Color(0xffBAD5FF);

  static const Color lovelyPurple = Color(0xff7F4DEC);

  static const Color lightWisteria = Color(0xffC19FE0);

  static const Color chardonnay = Color(0xffFFC780);

  static const Color columbiaBlue = Color(0xff80DEFF);

  static const Color mediumSpringBud = Color(0xffBDDB8A);

  static const Color lightSalmonPink = Color(0xffFF9999);

  static const Color periwinkle = Color(0xffBAD5FF);

  static const Color creamBrulee = Color(0xffFFE39C);

  static const Color paleLightGreen = Color(0xffAFFA8D);

  static const Color pastelMagenta = Color(0xffFF92C7);

  static const Color sweetPink = Color(0xffFFA4A4);

  static const Color geyser = Color(0xffD8D8EC);

  static const Color lightMint = Color(0xffB7FFD4);
  static const Color paleLavender = Color(0xffE5D5FF);

  static const Color purpleMimosa = Color(0xffA075FF);

  static const Color transparent = Colors.transparent;

  static const Color oldLace = Color(0xffFFF4E8);

  static const Color lavenderBlush = Color(0xffFFECF0);

  static const Color bubbles = Color(0xffE5F3FF);
  static const Color conflictBackgroundColor = Color(0xffFFBDBD);

  static Color hexToColor(String hexColor) {
    // Remove any non-hex characters (e.g., # or parentheses)
    var hex = hexColor.replaceAll('#', '').replaceAll('(', '').replaceAll(')', '');

    if (hex.length == 6) {
      hex = 'FF$hex'; // Add opacity if hex is 6 characters
    }

    return Color(int.parse(hex, radix: 16));
  }
}
