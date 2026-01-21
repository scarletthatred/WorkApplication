import 'package:flutter/material.dart';
import 'package:workapp/assets/speed_test_results.dart';
import 'package:workapp/assets/speed_test_service.dart';
import 'package:workapp/assets/speed_test_state.dart';


class SpeedTestCard extends StatefulWidget {
  const SpeedTestCard({super.key});

  @override
  State<SpeedTestCard> createState() => _SpeedTestCardState();
}

class _SpeedTestCardState extends State<SpeedTestCard> {
  final SpeedTestService _service = SpeedTestService();

  SpeedTestStatus _status = SpeedTestStatus.idle;
  SpeedTestResult? _result;
  String? _error;

  Future<void> _startTest() async {
    setState(() {
      _status = SpeedTestStatus.running;
      _error = null;
    });

    try {
      final result = await _service.runFullTest();

      if (!mounted) return;

      setState(() {
        _result = result;
        _status = SpeedTestStatus.success;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
        _status = SpeedTestStatus.error;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton.icon(
              icon: const Icon(Icons.speed),
              label: const Text("Run Internet Speed Test"),
              onPressed: _status == SpeedTestStatus.running ? null : _startTest,
            ),

            const SizedBox(height: 16),

            if (_status == SpeedTestStatus.running) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 8),
              const Text("Testing network speed..."),
            ],

            // if (_status == SpeedTestStatus.success && _result != null)
            //   _ResultView(result: _result!),

            if (_status == SpeedTestStatus.error)
              Text(
                _error ?? "Unknown error",
                style: const TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
