import 'package:flutter/material.dart';

class CustomMultiSelectDropdown extends FormField<List<String>> {
  CustomMultiSelectDropdown({
    Key? key,
    required List<String> options,
    required List<String> selectedOptions,
    required String title,
    required Function(List<String>) onSelectionChanged,
    String? Function(List<String>? value)? validator,
  }) : super(
          key: key,
          initialValue: selectedOptions,
          validator: validator,
          builder: (FormFieldState<List<String>> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () {
                    _showMultiSelectDialog(
                      state.context,
                      options,
                      state.value ?? [],
                      title,
                      (selectedOptions) {
                        state.didChange(selectedOptions);
                        onSelectionChanged(selectedOptions);
                      },
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: state.hasError ? Colors.red : Colors.grey,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            state.value == null || state.value!.isEmpty
                                ? "Select $title"
                                : state.value!.join(", "),
                            style: const TextStyle(
                                fontSize: 16, color: Colors.black),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
                if (state.hasError)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      state.errorText ?? '',
                      style: const TextStyle(
                        color: Colors.red,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
            );
          },
        );

  static void _showMultiSelectDialog(
    BuildContext context,
    List<String> options,
    List<String> selectedOptions,
    String title,
    Function(List<String>) onSelectionChanged,
  ) async {
    final List<String>? results = await showDialog(
      context: context,
      builder: (context) {
        return MultiSelectDialog(
          options: options,
          selectedOptions: selectedOptions,
          title: title,
        );
      },
    );

    if (results != null) {
      onSelectionChanged(results);
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
