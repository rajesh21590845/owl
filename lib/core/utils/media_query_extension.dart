import 'package:flutter/widgets.dart';

extension MediaQueryDataExtension on MediaQueryData {
  bool get boldTextOverride {
    try {
      // For older Flutter versions, if it exists, return it
      return (this as dynamic).boldTextOverride ?? false;
    } catch (e) {
      // For newer Flutter versions, fallback to regular boldText or false
      return this.boldText;
    }
  }
}
