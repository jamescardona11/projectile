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

  // final Headers _mHeaders = Headers.empty();
  final Map<String, dynamic> _mHeaders = {};
  final Map<String, dynamic> _mParams = {};
  final Map<String, dynamic> _mQueries = {};
  final Map<String, dynamic> _mData = {};

  MultipartFileWrapper? _multipart;

  // ResponseListener mListener;

  RequestBuilder.target(this._target, [this._ignoreBaseUrl = false]);

  RequestBuilder extra({
    PResponseType responseType = PResponseType.json,
  }) {
    _responseType = responseType;
    return this;
  }

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

  // RequestBuilder defaultHeaders() {
  //   Map<String, String> headers = {
  //     'accept': 'application/json',
  //   };

  //   _mHeaders.addAll(headers);
  //   return this;
  // }

  RequestBuilder urlParams(Map<String, dynamic> params) {
    _mParams.addAll(params);
    return this;
  }

  RequestBuilder queries(Map<String, dynamic> queries) {
    _mQueries.addAll(queries);
    return this;
  }

  RequestBuilder data(Map<String, dynamic> data) {
    _mData.addAll(data);
    return this;
  }

  ProjectileRequest build() {
    if (_method == null) {
      throw Exception('Make sure that method is not null, call MODE method');
    }

    return ProjectileRequest(
      target: _target,
      method: _method!,
      contentType: _contentType ?? ContentType.json,
      responseType: _responseType ?? PResponseType.json,
      ignoreBaseUrl: _ignoreBaseUrl,
      isMultipart: _multipart != null,
      multipart: _multipart,
      queries: _mQueries,
      headers: _mHeaders,
      urlParams: _mParams,
      data: _mData,
    );
  }
}
