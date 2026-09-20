import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

/// One configured Dio instance for the whole app.
/// Add interceptors here (auth, logging, retry) as the app grows.
Dio createDio() {
  return Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      queryParameters: {'api_key': ApiConstants.apiKey},
    ),
  );
}
