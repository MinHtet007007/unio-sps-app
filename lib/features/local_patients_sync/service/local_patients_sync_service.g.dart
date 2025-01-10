// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_patients_sync_service.dart';

// **************************************************************************
// RetrofitGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps,no_leading_underscores_for_local_identifiers

class _LocalPatientsSyncService implements LocalPatientsSyncService {
  _LocalPatientsSyncService(
    this._dio, {
    this.baseUrl,
  }) {
    baseUrl ??= 'https://1869-93-127-170-22.ngrok-free.app/api/v1/';
  }

  final Dio _dio;

  String? baseUrl;

  @override
  Future<RemotePatientResponse> uploadPatientsWithSignatures({
    required String patients,
    List<MultipartFile>? signatures,
  }) async {
    final _extra = <String, dynamic>{};
    final queryParameters = <String, dynamic>{};
    queryParameters.removeWhere((k, v) => v == null);
    final _headers = <String, dynamic>{};
    final _data = FormData();
    _data.fields.add(MapEntry(
      'patients',
      patients,
    ));
    if (signatures != null) {
      _data.files.addAll(signatures.map((i) => MapEntry('signatures[]', i)));
    }
    final _result = await _dio.fetch<Map<String, dynamic>>(
        _setStreamType<RemotePatientResponse>(Options(
      method: 'POST',
      headers: _headers,
      extra: _extra,
      contentType: 'multipart/form-data',
    )
            .compose(
              _dio.options,
              'app/patients/sync',
              queryParameters: queryParameters,
              data: _data,
            )
            .copyWith(
                baseUrl: _combineBaseUrls(
              _dio.options.baseUrl,
              baseUrl,
            ))));
    final value = RemotePatientResponse.fromJson(_result.data!);
    return value;
  }

  RequestOptions _setStreamType<T>(RequestOptions requestOptions) {
    if (T != dynamic &&
        !(requestOptions.responseType == ResponseType.bytes ||
            requestOptions.responseType == ResponseType.stream)) {
      if (T == String) {
        requestOptions.responseType = ResponseType.plain;
      } else {
        requestOptions.responseType = ResponseType.json;
      }
    }
    return requestOptions;
  }

  String _combineBaseUrls(
    String dioBaseUrl,
    String? baseUrl,
  ) {
    if (baseUrl == null || baseUrl.trim().isEmpty) {
      return dioBaseUrl;
    }

    final url = Uri.parse(baseUrl);

    if (url.isAbsolute) {
      return url.toString();
    }

    return Uri.parse(dioBaseUrl).resolveUri(url).toString();
  }
}
