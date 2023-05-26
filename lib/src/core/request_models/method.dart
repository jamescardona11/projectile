// ignore_for_file: constant_identifier_names
/// {@template method}
/// {@endtemplate}
enum Method {
  GET('get'),
  POST('post'),
  PUT('put'),
  DELETE('delete'),
  PATCH('patch');

  const Method(this._value);

  final String _value;

  String get value => _value;
}
