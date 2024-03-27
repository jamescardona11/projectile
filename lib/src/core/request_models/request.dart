import 'helper_types.dart';
import 'method.dart';
import 'multipart_file.dart';

/// {@template helper_types}
/// {@endtemplate}

typedef ValueGetterRequest<T> = bool Function(dynamic json);
bool _defaultCustomSuccess(dynamic json) => true;

class ProjectileRequest {
  final String target;
  final bool ignoreBaseUrl;

  final Method method;
  final ContentType? contentType;
  final PResponseType? responseType;
  final bool isMultipart;

  /// Replace all dynamic address params with the given values in target-url that have {}
  final Map<String, dynamic> urlParams;
  final Map<String, dynamic> queries;
  final Map<String, dynamic> body;
  final MultipartFileWrapper? multipart;
  Map<String, dynamic>? headers;

  final ValueGetterRequest customSuccess;

  ProjectileRequest({
    required this.target,
    required this.method,
    this.isMultipart = false,
    this.ignoreBaseUrl = false,
    this.multipart,
    this.contentType,
    this.responseType,
    this.headers = const {},
    this.urlParams = const {},
    this.queries = const {},
    this.body = const {},
    ValueGetterRequest? customSuccess,
  }) : customSuccess = customSuccess ?? _defaultCustomSuccess;

  String get methodStr => isMultipart ? Method.POST.value : method.value;

  String getUri([String baseUrl = '']) {
    final bUrl = ignoreBaseUrl ? '' : baseUrl;

    final tempUrl = (bUrl + target).trim();

    final uri = Uri.parse(_addDynamicAddressParams(tempUrl));

    if (queries.isNotEmpty) {
      return uri.replace(queryParameters: queries).toString();
    }

    return uri.toString();
  }

  String getUrl([String baseUrl = '']) {
    return getUri(baseUrl).toString();
  }

  String _addDynamicAddressParams(String tempUrl) => urlParams.entries.fold(tempUrl, (
        String previousUrl,
        MapEntry<String, dynamic> currentParam,
      ) {
        final String key = currentParam.key;
        final String value = currentParam.value.toString();
        return previousUrl.replaceAll('{$key}', value);
      });

  @override
  String toString() =>
      'ProjectileRequest(\ntarget: $target, ignoreBaseUrl: $ignoreBaseUrl, method: ${method.value},\n ContentType: ${contentType?.value}, headers: ${headers.toString()},\nurlParams: $urlParams, queries: $queries, body: $body,\nisMultipart: $isMultipart, multipart: ${multipart?.toString()}';

  ProjectileRequest copyWith({
    String? target,
    bool? ignoreBaseUrl,
    Method? method,
    ContentType? contentType,
    Map<String, dynamic>? headers,
    bool? isMultipart,
    PResponseType? responseType,
    Map<String, dynamic>? urlParams,
    Map<String, dynamic>? queries,
    Map<String, dynamic>? body,
    MultipartFileWrapper? multipart,
    ValueGetterRequest? customSuccess,
  }) {
    return ProjectileRequest(
      target: target ?? this.target,
      ignoreBaseUrl: ignoreBaseUrl ?? this.ignoreBaseUrl,
      method: method ?? this.method,
      contentType: contentType ?? this.contentType,
      headers: headers ?? this.headers ?? const {},
      responseType: responseType ?? this.responseType,
      isMultipart: isMultipart ?? this.isMultipart,
      urlParams: urlParams ?? this.urlParams,
      queries: queries ?? this.queries,
      body: body ?? this.body,
      multipart: multipart ?? this.multipart,
      customSuccess: customSuccess ?? this.customSuccess,
    );
  }
}
