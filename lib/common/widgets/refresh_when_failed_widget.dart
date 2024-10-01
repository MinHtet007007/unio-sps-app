import 'package:sps/common/constants/theme.dart';
import 'package:flutter/material.dart';

class RefreshWhenFailedWidget extends StatelessWidget {
  final void Function() refresh;
  final String? errorMessage;

  const RefreshWhenFailedWidget({
    Key? key,
    this.errorMessage,
    required this.refresh,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (errorMessage != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: refresh,
            style: ElevatedButton.styleFrom(backgroundColor: ColorTheme.danger),
            child: const Text('Refresh',
                style: TextStyle(fontSize: 16, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
