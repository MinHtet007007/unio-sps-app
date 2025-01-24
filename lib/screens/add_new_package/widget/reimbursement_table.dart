import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sps/local_database/entity/patient_package_entity.dart';

class ReimbursementTable extends StatefulWidget {
  final List<Map<String, dynamic>> selectedReimbursements;
  final List<PatientPackageEntity> editablePatientPackages;
  final Function(int index, int reimbursementTotal) onDeleteReimbursement;

  const ReimbursementTable({
    Key? key,
    required this.selectedReimbursements,
    required this.editablePatientPackages,
    required this.onDeleteReimbursement,
  }) : super(key: key);

  @override
  State<ReimbursementTable> createState() => _ReimbursementTableState();
}

class _ReimbursementTableState extends State<ReimbursementTable> {
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
              columnSpacing: 12.0,
              columns: const [
                DataColumn(label: Text('No')),
                DataColumn(label: Text('Month')),
                DataColumn(label: Text('Packages')),
                DataColumn(label: Text('Given Amount')),
                DataColumn(label: Text('Month Year')),
                DataColumn(label: Text('Delete')),
              ],
              rows: widget.selectedReimbursements.asMap().entries.map((entry) {
                int index = entry.key;
                var item = entry.value;

                return DataRow(cells: [
                  DataCell(Text('${index + 1}')),
                  DataCell(Text(
                    item['reimbursement_month'] == -1
                        ? "Pre-enroll Month"
                        : "Month-${item['reimbursement_month']}",
                  )),
                  DataCell(Text('${item['reimbursement_packages']}')),
                  DataCell(Text('${item['given_amount']}')),
                  DataCell(Text('${item['reimbursement_month_year']}')),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        int packageId = int.parse(item['package_id']);
                        int givenAmount = item['given_amount'];

                        final package = widget.editablePatientPackages
                            .firstWhere((p) => p.id == packageId);

                        if (package.packageName != "Package 8") {
                          package.remainingAmount += givenAmount;
                        }

                        widget.onDeleteReimbursement(index, givenAmount);
                      },
                    ),
                  ),
                ]);
              }).toList(),
            ),
          ),
        ),
      ],
    );
  }
}
