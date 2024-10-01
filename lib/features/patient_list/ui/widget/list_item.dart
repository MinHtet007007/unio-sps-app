import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomItem extends StatelessWidget {
  final int id;
  final String name;
  final String unionTempCode;
  const CustomItem(
      {Key? key,
      required this.id,
      required this.name,
      required this.unionTempCode})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('/patient/$id');
      },
      child: Card(
          color: Colors.white,
          elevation: 2,
          child: ListTile(
            trailing: const Icon(Icons.arrow_forward),
            title: CustomLabelWidget(text: '$name ($unionTempCode)'),
          )),
    );
  }
}
