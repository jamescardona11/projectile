// ignore_for_file: public_member_api_docs, sort_constructors_first
/// {@template config}
/// {@endtemplate}

class BaseConfig {
  final String baseUrl;
  final Map<String, dynamic>? baseHeaders;
  final Duration timeout;
  final String logsTag;
  final bool enableLog;

  const BaseConfig({
    this.baseUrl = '',
    this.baseHeaders,
    this.timeout = const Duration(seconds: 10),
    this.logsTag = 'BasicProjectileLogs',
    this.enableLog = false,
  });

  @override
  String toString() {
    return 'BaseConfig(baseUrl: $baseUrl, baseHeaders: $baseHeaders, timeout: $timeout, logsTag: $logsTag, enableLog: $enableLog)';
  }

  BaseConfig copyWith({
    String? baseUrl,
    Map<String, dynamic>? baseHeaders,
    Duration? timeout,
    String? logsTag,
    bool? enableLog,
  }) {
    return BaseConfig(
      baseUrl: baseUrl ?? this.baseUrl,
      baseHeaders: baseHeaders ?? this.baseHeaders,
      timeout: timeout ?? this.timeout,
      logsTag: logsTag ?? this.logsTag,
      enableLog: enableLog ?? this.enableLog,
    );
  }
}

const contentTypeKeyOne = 'content-type';
const contentTypeKeyTwo = 'Content-Type';
