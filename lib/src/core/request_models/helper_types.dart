/// {@template helper_types}
/// {@endtemplate}
enum ContentType {
  binary('application/octet-stream'),
  json('application/json; charset=utf-8');

  const ContentType(this._value);

  final String _value;

  String get value => _value;
}
