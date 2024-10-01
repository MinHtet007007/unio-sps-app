sealed class FontState {}
class ActiveFontState extends FontState {
  final int font;
  ActiveFontState(this.font);
}
class FontLoadingState extends FontState {}
