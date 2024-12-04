import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:flutter/material.dart';

class SyncButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final bool enabled;
  const SyncButton(
      {Key? key,
      required this.isLoading,
      required this.onPressed,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading || !enabled ? null : onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
            isLoading ? Colors.grey.shade400 : Colors.blue),
        foregroundColor: WidgetStateProperty.all(Colors.white),
      ),
      child: CustomLabelWidget(
        text: isLoading ? "..." : "Sync",
        style: const TextStyle(color: Colors.white, fontSize: 11),
      ),
    );
  }
}
