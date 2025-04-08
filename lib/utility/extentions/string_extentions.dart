import 'package:flutter/foundation.dart';

extension StringExtention on String {
  String? get isDebugging => kDebugMode ? this : null;
  String get inCaps => length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
  String get allInCaps => toUpperCase();
  String get capitalizeFirstofEach => replaceAll(RegExp(' +'), ' ').split(' ').map((str) => str.inCaps).join(' ');
  double get getProportionValue => double.tryParse(split(' ')[0]) ?? 0.0;
  String get firstLetterCaps => isNotEmpty ? this[0].toUpperCase() : '';
  String cleanString(String input) {
    return input.replaceAll('(', '').replaceAll(')', '');
  }
}

extension StringNullExtention on String? {
  bool get isPureValid => this != null && this!.trim().isNotEmpty;
  bool get isNotPureValid => this == null || (this?.trim().isEmpty ?? false);
}
