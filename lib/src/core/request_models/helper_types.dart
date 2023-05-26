/// {@template helper_types}
/// {@endtemplate}
enum ContentType {
  binary('application/octet-stream'),
  json('application/json; charset=utf-8');

  const ContentType(this._value);

  final String _value;

  String get value => _value;
}

// based in DIO
enum PResponseType {
  json,

  /// Get original bytes, the type of [ResponseSuccess.data] will be List<int>
  bytes,

  unknown;

  bool get isJson => this == json;

  bool get isBytes => this == bytes;
}
