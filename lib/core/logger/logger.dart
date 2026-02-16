class Logger {
  const Logger();

  void info(String message) {
    final time = DateTime.now().toIso8601String();
    // Simple console logging for debug
    // IDE/terminals will show these when running with F5
    print('[INFO] $time: $message');
  }

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    final time = DateTime.now().toIso8601String();
    print('[ERROR] $time: $message');
    if (error != null) print('  error: $error');
    if (stackTrace != null) print('  stack: $stackTrace');
  }
}
