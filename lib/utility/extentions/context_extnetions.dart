import 'package:flutter/material.dart';
import 'package:responsive_builder/responsive_builder.dart';

extension ContextExtention on BuildContext {
  bool get isMobile => getValueForScreenType(context: this, mobile: true, tablet: true, desktop: false);
  bool get isDesktop => getValueForScreenType(context: this, mobile: false, tablet: false, desktop: true);
}
