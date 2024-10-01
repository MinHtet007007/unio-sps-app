import 'package:sps/common/constants/route_list.dart';
import 'package:sps/common/helpers/get_couseling_phase.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:sps/features/counseling_list/provider/local_counselings_provider.dart';
import 'package:sps/local_database/entity/counseling_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class CustomItem extends ConsumerWidget {
  final Counseling counseling;

  const CustomItem({Key? key, required this.counseling}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final phase = counseling.phase == CONTINUOUS_PHASE ? 'ဆက်လက်' : 'ကနဦး';
    return Card(
      color: counseling.isSynced ? Colors.white : Colors.redAccent.shade100,
      elevation: 2,
      child: ListTile(
        title: CustomLabelWidget(text: '${counseling.date} ($phase)'),
        subtitle: CustomLabelWidget(
            text:
                counseling.type == 'In Person' ? 'လူကိုယ်တိုင်' : 'ဖုန်းဖြင့်'),
        trailing: counseling.isSynced
            ? const SizedBox.shrink()
            : IconButton(
                icon: const Icon(Icons.delete),
                onPressed: () {
                  ref
                      .read(localCounselingsProvider.notifier)
                      .deleteCounseling(counseling);
                },
              ),
        leading: counseling.isSynced
            ? const SizedBox.shrink()
            : IconButton(
                icon: const Icon(Icons.edit),
                onPressed: () async {
                  await context.push(
                      '${RouteName.updateCounseling}/${counseling.patientId}/${counseling.id}');
                },
              ),
      ),
    );
  }
}
