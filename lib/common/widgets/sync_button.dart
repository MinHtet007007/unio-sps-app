import 'package:sps/common/widgets/custom_label_widget.dart';
import 'package:flutter/material.dart';

class SyncButton extends StatelessWidget {
  final bool isLoading;
  final VoidCallback? onPressed;
  final bool enabled;
  final String title;
  final Color? backgroundColor;
  const SyncButton(
      {Key? key,
      required this.isLoading,
      required this.title,
      required this.onPressed,
      this.backgroundColor = Colors.blue,
      this.enabled = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: isLoading || !enabled ? null : onPressed,
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all(
            isLoading ? Colors.grey.shade400 : backgroundColor),
        foregroundColor: WidgetStateProperty.all(Colors.white),
      ),
      child: CustomLabelWidget(
        text: isLoading ? "..." : title,
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}
