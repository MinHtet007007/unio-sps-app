import 'package:flutter/material.dart';

class CustomMultiSelectDropdown extends StatefulWidget {
  final List<String> options;
  final List<String> selectedOptions;
  final String title;
  final Function(List<String>) onSelectionChanged;

  const CustomMultiSelectDropdown({
    Key? key,
    required this.options,
    required this.selectedOptions,
    required this.title,
    required this.onSelectionChanged,
  }) : super(key: key);

  @override
  _CustomMultiSelectDropdownState createState() =>
      _CustomMultiSelectDropdownState();
}

class _CustomMultiSelectDropdownState extends State<CustomMultiSelectDropdown> {
  List<String> _selectedOptions = [];

  @override
  void initState() {
    super.initState();
    _selectedOptions = List.from(widget.selectedOptions);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showMultiSelectDialog(context);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                _selectedOptions.isEmpty
                    ? "Select ${widget.title}"
                    : _selectedOptions.join(", "),
                style: TextStyle(fontSize: 16, color: Colors.black),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const Icon(Icons.arrow_drop_down),
          ],
        ),
      ),
    );
  }

  void _showMultiSelectDialog(BuildContext context) async {
    final List<String>? results = await showDialog(
      context: context,
      builder: (context) {
        return MultiSelectDialog(
          options: widget.options,
          selectedOptions: _selectedOptions,
          title: widget.title,
        );
      },
    );

    if (results != null) {
      setState(() {
        _selectedOptions = results;
      });
      widget.onSelectionChanged(_selectedOptions);
    }
  }
}

class MultiSelectDialog extends StatefulWidget {
  final List<String> options;
  final List<String> selectedOptions;
  final String title;

  const MultiSelectDialog({
    Key? key,
    required this.options,
    required this.selectedOptions,
    required this.title,
  }) : super(key: key);

  @override
  _MultiSelectDialogState createState() => _MultiSelectDialogState();
}

class _MultiSelectDialogState extends State<MultiSelectDialog> {
  late List<String> _tempSelectedOptions;

  @override
  void initState() {
    super.initState();
    _tempSelectedOptions = List.from(widget.selectedOptions);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Select ${widget.title}"),
      content: SingleChildScrollView(
        child: Column(
          children: widget.options.map((option) {
            return CheckboxListTile(
              value: _tempSelectedOptions.contains(option),
              title: Text(option),
              onChanged: (isSelected) {
                setState(() {
                  if (isSelected == true) {
                    _tempSelectedOptions.add(option);
                  } else {
                    _tempSelectedOptions.remove(option);
                  }
                });
              },
            );
          }).toList(),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, null),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context, _tempSelectedOptions),
          child: const Text("OK"),
        ),
      ],
    );
  }
}
