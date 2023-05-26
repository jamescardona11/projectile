import 'package:http_parser/http_parser.dart' show MediaType;

/// `MultipartFileWrapper` is a wrapper for Multipart class from dio or http
/// https://github.com/flutterchina/dio/blob/develop/dio/lib/src/multipart_file.dart
/// https://github.com/dart-lang/http/blob/master/pkgs/http/lib/src/multipart_file.dart
///
/// This wrapper don't override any original behavior
///
///
/// {@template multipart_file}
///
/// {@endtemplate}
class MultipartFileWrapper {
  MultipartFileWrapper._({
    required this.field,
    required this.contentType,
    required this.type,
    this.valueString = '',
    this.valueBytes = const [],
    this.filename,
    this.valuePath = '',
  });

  /// key of json data
  final String field;
  final String? filename;
  final String? valuePath;
  final String? valueString;
  final MediaType? contentType;
  final List<int>? valueBytes;
  final MultipartFileType type;

  factory MultipartFileWrapper.fromBytes({
    required List<int> valueBytes,
    required String field,
    String? filename,
    MediaType? contentType,
  }) =>
      MultipartFileWrapper._(
        type: MultipartFileType.bytes,
        valueBytes: valueBytes,
        filename: filename,
        contentType: contentType,
        field: field,
      );

  factory MultipartFileWrapper.fromString({
    required String valueString,
    required String field,
    String? filename,
    MediaType? contentType,
  }) =>
      MultipartFileWrapper._(
        type: MultipartFileType.string,
        field: field,
        valueString: valueString,
        filename: filename,
        contentType: contentType,
      );

  factory MultipartFileWrapper.fromFileOrPath({
    required String valuePath,
    required String field,
    String? filename,
    MediaType? contentType,
  }) =>
      MultipartFileWrapper._(
        type: MultipartFileType.fileOrPath,
        field: field,
        filename: filename,
        contentType: contentType,
        valuePath: valuePath,
      );

  @override
  String toString() =>
      'ProjectileRequest(\nfield: $field, contentType: $contentType, type: $type, valueString: $valueString, valueBytes: $valueBytes, valuePath: $valuePath, filename: $filename ';
}

enum MultipartFileType {
  bytes,
  string,
  fileOrPath;

  bool get isBytes => this == bytes;
  bool get isString => this == string;
  bool get isFileOrPath => this == fileOrPath;
}
