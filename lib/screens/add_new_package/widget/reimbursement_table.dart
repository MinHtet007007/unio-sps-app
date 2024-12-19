import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:sps/local_database/entity/patient_package_entity.dart';

class ReimbursementTable extends StatelessWidget {
  final List<Map<String, dynamic>> selectedReimbursements;
  final List<PatientPackageEntity> editablePatientPackages;
  final Function(int index,int reimbursementTotal) onDeleteReimbursement; // Callback for delete action

  const ReimbursementTable({
    Key? key,
    required this.selectedReimbursements,
    required this.editablePatientPackages,
    required this.onDeleteReimbursement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    int grandTotal = 0; // Assuming you need to track grand total

    return Table(
      border: TableBorder.all(),
      children: [
        const TableRow(
          children: [
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('No'),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Month'),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Packages'),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Given Amount'),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Month Year'),
              ),
            ),
            TableCell(
              verticalAlignment: TableCellVerticalAlignment.middle,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text('Delete'),
              ),
            ),
          ],
        ),
        ...selectedReimbursements.asMap().entries.map((entry) {
          int index = entry.key;
          var item = entry.value;

          grandTotal += item['given_amount'] as int; // Update grandTotal

          return TableRow(
            children: [
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${index + 1}'),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    item['reimbursement_month'] == -1
                        ? "Pre-enroll Month"
                        : "Month-${item['reimbursement_month']}",
                  ),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${item['reimbursement_packages']}'),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${item['given_amount']}'),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text('${item['reimbursement_month_year']}'),
                ),
              ),
              TableCell(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () {
                      int packageId = int.parse(item['package_id']);
                      int givenAmount = item['given_amount'];

                      final package = editablePatientPackages
                          .firstWhere((p) => p.id == packageId);

                      package.remainingAmount += givenAmount;
                      grandTotal -= givenAmount;
                      // selectedReimbursements.removeAt(index);
                      onDeleteReimbursement(index,grandTotal); // Call callback
                    },
                  ),
                ),
              ),
            ],
          );
        }).toList(),
      ],
    );
  }
}
