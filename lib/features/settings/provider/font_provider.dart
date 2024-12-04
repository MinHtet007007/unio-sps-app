import 'package:sps/features/settings/provider/state/font_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

const defaultFont = 1;

class FontProvider extends Notifier<FontState> {
  FontState fontState = ActiveFontState(defaultFont);

  @override
  FontState build() {
    return fontState;
  }

  void getFont() async {
    state = FontLoadingState();
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('currentFont')) {
      state = ActiveFontState(defaultFont);
    } else {
      final String currentFont = prefs.getString('currentFont') as String;
      state = ActiveFontState(int.parse(currentFont));
    }
  }

  void setFont(int font) async {
    state = FontLoadingState();
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('currentFont', font.toString());
    state = ActiveFontState(font);
  }
}

final fontProvider = NotifierProvider<FontProvider, FontState>(
  FontProvider.new,
);
