class SpeedTestResult {
  final double downloadMbps;
  final double uploadMbps;
  final int pingMs;
  final DateTime timestamp;

  SpeedTestResult({
    required this.downloadMbps,
    required this.uploadMbps,
    required this.pingMs,
    required this.timestamp,
  });
}