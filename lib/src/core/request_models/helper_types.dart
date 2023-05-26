/// {@template helper_types}
/// {@endtemplate}
enum ContentType {
  binary('application/octet-stream'),
  json('application/json; charset=utf-8'),
  plainText('text/plain; charset=utf-8');

  const ContentType(this._value);

  final String _value;

  String get value => _value;
}

// based in DIO
enum PResponseType {
  json,

  /// Transform the response data to a String encoded with UTF8.
  plain,

  /// Get original bytes, the type of [ResponseSuccess.data] will be List<int>
  bytes,

  unknown;

  bool get isJson => this == json;

  bool get isPlain => this == plain;

  bool get isBytes => this == bytes;
}
