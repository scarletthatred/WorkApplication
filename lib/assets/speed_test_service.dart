import 'package:speed_test_dart/speed_test_dart.dart';
import 'package:workapp/assets/speed_test_results.dart';


class SpeedTestService {
  final SpeedTestDart _tester = SpeedTestDart();

  Future<SpeedTestResult> runFullTest() async {
    final servers = await _tester.getBestServers(servers: []);

    if (servers.isEmpty) {
      throw Exception("No speed test servers found");
    }

    final server = servers.first;

    final ping = 0;
    final download = await _tester.testDownloadSpeed(servers: servers);
    final upload = await _tester.testUploadSpeed(servers: servers);

    return SpeedTestResult(
      pingMs: ping,
      downloadMbps: download,
      uploadMbps: upload,
      timestamp: DateTime.now(),
    );
  }
}
