import 'package:sps/features/counseling_list/ui/widget/list_item.dart';
import 'package:sps/local_database/entity/counseling_entity.dart';
import 'package:flutter/material.dart';

class CustomListView extends StatelessWidget {
  final List<Counseling>? counselings;

  const CustomListView({
    this.counselings,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: counselings?.length,
        itemBuilder: (BuildContext context, int index) {
          Counseling data = counselings![index];
          return CustomItem(
            counseling: data,
          );
        });
  }
}
