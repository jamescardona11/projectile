import 'helper_types.dart';
import 'method.dart';
import 'multipart_file.dart';
import 'request.dart';

/// {@template request_builder}
/// {@endtemplate}
class RequestBuilder {
  late final String _target;
  late final bool _ignoreBaseUrl;
  Method? _method;
  ContentType? _contentType;
  PResponseType? _responseType;

  final Map<String, dynamic> _mHeaders = {};
  final Map<String, dynamic> _mParams = {};
  final Map<String, dynamic> _mQueries = {};
  final Map<String, dynamic> _mBody = {};

  MultipartFileWrapper? _multipart;

  RequestBuilder.target(this._target, [this._ignoreBaseUrl = false]);

  RequestBuilder mode(
    Method method, [
    ContentType contentType = ContentType.json,
  ]) {
    _method = method;
    contentType = contentType;
    return this;
  }

  RequestBuilder multipart(MultipartFileWrapper multipart) {
    _multipart = multipart;
    return this;
  }

  RequestBuilder headers(Map<String, String> headers) {
    _mHeaders.addAll(headers);
    return this;
  }

  RequestBuilder urlParams(Map<String, dynamic> params) {
    _mParams.addAll(params);
    return this;
  }

  RequestBuilder queries(Map<String, dynamic> queries) {
    _mQueries.addAll(queries);
    return this;
  }

  RequestBuilder body(Map<String, dynamic> body) {
    _mBody.addAll(body);
    return this;
  }

  RequestBuilder extra(PResponseType responseType) {
    _responseType = responseType;
    return this;
  }

  ProjectileRequest build() {
    if (_method == null) {
      throw Exception('Make sure that method is not null, call MODE method');
    }

    return ProjectileRequest(
      target: _target,
      method: _method!,
      contentType: _contentType,
      responseType: _responseType,
      ignoreBaseUrl: _ignoreBaseUrl,
      isMultipart: _multipart != null,
      multipart: _multipart,
      queries: _mQueries,
      headers: _mHeaders,
      urlParams: _mParams,
      body: _mBody,
    );
  }
}
