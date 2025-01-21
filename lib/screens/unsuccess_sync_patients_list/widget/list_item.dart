import 'package:sps/common/constants/route_list.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CustomItem extends StatelessWidget {
  final int id;
  final String name;
  final String? code;
  final bool isSynced;
  const CustomItem(
      {Key? key,
      required this.id,
      required this.name,
      required this.isSynced,
      required this.code})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        context.push('${RouteName.patientDetail}/$id/true');
      },
      child: Card(
          color: isSynced ? Colors.white : Colors.redAccent,
          elevation: 2,
          child: ListTile(
            trailing: const Icon(Icons.arrow_forward),
            title: CustomLabelWidget(
                text: '$name ${code != null ? "($code)" : ""}',
                style: TextStyle(
                    color: isSynced ? Colors.black : Colors.white,
                    fontSize: 16)),
          )),
    );
  }
}
