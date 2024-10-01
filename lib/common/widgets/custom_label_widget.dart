import 'package:sps/features/settings/provider/font_provider.dart';
import 'package:sps/features/settings/provider/state/font_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:rabbit_converter/rabbit_converter.dart';

class CustomLabelWidget extends ConsumerWidget {
  String text;
  TextStyle? style;
  TextAlign? align;
  CustomLabelWidget({Key? key, required this.text, this.style, this.align})
      : super(key: key);

  getLabel(text, type) {
    if (type == 1) {
      return text;
    } else {
      return Rabbit.uni2zg(text);
    }
  }

  getStyle(type) {
    if (type == 1) {
      return style;
    } else {
      if (style != null) {
        style?.merge(const TextStyle(fontFamily: 'ZawgyiOne'));
      } else {
        style = const TextStyle(fontFamily: 'ZawgyiOne');
      }

      return style;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final fontState = ref.watch(fontProvider);
    if (fontState is ActiveFontState) {
      return Text(
        getLabel(text, fontState.font),
        style: getStyle(fontState.font),
        textAlign: align,
      );
    }

    return const SizedBox.shrink();
  }
}
