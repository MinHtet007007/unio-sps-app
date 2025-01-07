import 'package:flutter/material.dart';
import 'package:sps/local_database/entity/receive_package_entity.dart';

class MonthDetailReimbursementTable extends StatefulWidget {
  final List<ReceivePackageEntity> patientReimbursements;

  const MonthDetailReimbursementTable({
    Key? key,
    required this.patientReimbursements,
  }) : super(key: key);

  @override
  State<MonthDetailReimbursementTable> createState() =>
      _MonthDetailReimbursementTableState();
}

class _MonthDetailReimbursementTableState
    extends State<MonthDetailReimbursementTable> {
  final ScrollController _scrollController =
      ScrollController(); // Add ScrollController

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Scrollable Table
        Scrollbar(
          thumbVisibility: true, // Ensures the scrollbar is always visible
          controller: _scrollController,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            controller: _scrollController,
            child: DataTable(
              columnSpacing: 18.0,
              columns: const [
                DataColumn(label: Text('No')),
                DataColumn(label: Text('Month')),
                DataColumn(label: Text('Packages')),
                DataColumn(label: Text('Month Year')),
              ],
              // rows: const [
              //   DataRow(cells: [
              //     DataCell(Text('1')),
              //     DataCell(Text(
              //       "Month-1",
              //     )),
              //     DataCell(Text("Package 2")),
              //     DataCell(Text('2022-01')),
              //   ])
              // ],
              rows: widget.patientReimbursements.asMap().entries.map((entry) {
                int index = entry.key;
                var item = entry.value;

                return DataRow(cells: [
                  DataCell(Text('${index + 1}')),
                  DataCell(Text(
                    item.reimbursementMonth == -1
                        ? "Pre-enroll Month"
                        : "Month-${item.reimbursementMonth}",
                  )),
                  DataCell(Text(item.patientPackageName)),
                  DataCell(Text('${item.reimbursementMonthYear}')),
                ]);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
