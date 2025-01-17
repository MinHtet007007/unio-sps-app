import 'package:flutter/material.dart';
import 'package:sps/common/helpers/cache.dart';

class LastSyncedTimeWidget extends StatefulWidget {
  const LastSyncedTimeWidget({super.key});

  @override
  State<LastSyncedTimeWidget> createState() => _LastSyncedTimeWidgetState();
}

class _LastSyncedTimeWidgetState extends State<LastSyncedTimeWidget> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: Cache.getLastSyncedTimeInBangkok(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text(
            'Error: ${snapshot.error}',
            style: const TextStyle(color: Colors.red),
          );
        } else {
          return Text('Last Synced: ${snapshot.data}',
              style: const TextStyle(color: Colors.white));
        }
      },
    );
  }
}
