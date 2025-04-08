extension DateExtentions on DateTime {
  int get dateHasCode => '$year-$month-$day'.hashCode;
}
