import 'package:flutter/material.dart';
import 'package:workapp/assets/speed_test_results.dart';

class _ResultView extends StatelessWidget {
  final SpeedTestResult result;

  const _ResultView({required this.result});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Ping: ${result.pingMs} ms",
            style: Theme.of(context).textTheme.titleMedium),

        Text("Download: ${result.downloadMbps.toStringAsFixed(2)} Mbps"),
        Text("Upload: ${result.uploadMbps.toStringAsFixed(2)} Mbps"),

        const SizedBox(height: 8),

        Text(
          "Tested at ${result.timestamp}",
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
