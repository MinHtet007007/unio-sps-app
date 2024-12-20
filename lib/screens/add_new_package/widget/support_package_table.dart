import 'package:flutter/material.dart';
import 'package:sps/local_database/entity/patient_package_entity.dart';

class SupportPackageTable extends StatefulWidget {
  final List<Map<String, dynamic>> selectedSupportReceivedMonthPackages;
  final int grandTotal;
  final List<PatientPackageEntity> editablePatientPackages;
  final Function(int index, int givenAmount) onDelete;

  const SupportPackageTable({
    Key? key,
    required this.selectedSupportReceivedMonthPackages,
    required this.grandTotal,
    required this.onDelete,
    required this.editablePatientPackages,
  }) : super(key: key);

  @override
  State<SupportPackageTable> createState() => _SupportPackageTableState();
}

class _SupportPackageTableState extends State<SupportPackageTable> {
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
                DataColumn(label: Text('Packages')),
                DataColumn(label: Text('Given Amount')),
                DataColumn(label: Text('Delete')),
              ],
              rows: widget.selectedSupportReceivedMonthPackages
                  .asMap()
                  .entries
                  .map((entry) {
                int index = entry.key;
                var item = entry.value;

                return DataRow(cells: [
                  DataCell(Text('${index + 1}')),
                  DataCell(Text('${item['package']}')),
                  DataCell(Text('${item['given_amount']}')),
                  DataCell(
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        int packageId = int.parse(item['package_id']);
                        int givenAmount = item['given_amount'];

                        final package =
                            widget.editablePatientPackages.firstWhere((p) => p.id == packageId);

                        package.remainingAmount += givenAmount;
                        widget.onDelete(index, item['given_amount']);
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
