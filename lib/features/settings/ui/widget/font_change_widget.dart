import 'package:flutter/material.dart';

class FontChangeWidget extends StatelessWidget {
  final int font;
  final Function setFont;
  const FontChangeWidget({super.key, required this.font, required this.setFont});

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Card(
        child: CheckboxListTile(
          title: const Text("Unicode"),
          value: font == 1,
          onChanged: (bool? value)  {
             setFont(1);
          },
        ),
      ),
      Card(
        child: CheckboxListTile(
          value: font == 2,
          title: const Text("Zawgyi"),
          onChanged: (bool? value) {
             setFont(2);
          },
        ),
      ),
    ]);
  }
}