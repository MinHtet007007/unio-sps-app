import 'package:sps/common/constants/theme.dart';
import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:flutter/material.dart';

class CustomDropDown extends StatelessWidget {
  final String title;
  final List<DropdownMenuItem<String>> items;
  final String? selectedData;
  final String? hintText;
  final void Function(dynamic)? onChanged;
  final bool isRequired;

  const CustomDropDown({
    super.key,
    required this.title,
    required this.items,
    required this.selectedData,
    required this.hintText,
    required this.onChanged,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(
          //   title,
          //   style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          // ),
          // const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: ColorTheme.primary),
              borderRadius: const BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                enabledBorder: InputBorder.none,
                isDense: true,
              ),
              itemHeight: 50,
              hint: CustomLabelWidget(
                text: '$hintText',
                style: const TextStyle(
                  fontSize: 14.0,
                  color: Colors.blue,
                ),
              ),
              isExpanded: true,
              value: selectedData,
              items: items.toList(),
              onChanged: onChanged,
              icon: const Icon(
                Icons.arrow_drop_down,
                color: Colors.blue,
              ),
              validator: isRequired
                  ? (value) => value == null ? '$title is required' : null
                  : null,
              iconSize: 42,
            ),
          ),
        ],
      ),
    );
  }
}
