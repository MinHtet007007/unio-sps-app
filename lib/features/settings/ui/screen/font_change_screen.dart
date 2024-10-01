import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:sps/common/widgets/loading_widget.dart';
import 'package:sps/features/settings/provider/font_provider.dart';
import 'package:sps/features/settings/provider/state/font_state.dart';
import 'package:sps/features/settings/ui/widget/font_change_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FontChangeScreen extends ConsumerStatefulWidget {
  const FontChangeScreen({Key? key}) : super(key: key);
  @override
  ConsumerState<FontChangeScreen> createState() => _FontChangeScreenState();
}

class _FontChangeScreenState extends ConsumerState<FontChangeScreen> {
  @override
  Widget build(BuildContext context) {
    final fontState = ref.watch(fontProvider);

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: CustomLabelWidget(text: "Font ပြောင်းမည်"),
          backgroundColor: ColorTheme.primary,
        ),
        body: _fontChangeWidget(fontState),
      ),
    );
  }

  void _onFontChange(int font) async {
    await Future.delayed(Duration.zero);
    ref.read(fontProvider.notifier).setFont(font);
  }

  Widget _fontChangeWidget(FontState fontState) {
    return switch (fontState) {
      FontLoadingState() => const Center(child: CircularProgressIndicator()),
      ActiveFontState() => FontChangeWidget(
          font: fontState.font,
          setFont: _onFontChange,
        ), // This will be replaced by navigation
    };
  }
}
