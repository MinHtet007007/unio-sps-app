import 'package:flutter/cupertino.dart';
import 'package:rabbit_converter/rabbit_converter.dart';

class CustomText {
  static String getText(BuildContext context, String text) {
    // int font = Provider.of<FontSystemProvider>(context, listen: false).font;
    // if (font == 1) {
    //   return text;
    // } else {
      return Rabbit.uni2zg(text);
    // }
  }
}
