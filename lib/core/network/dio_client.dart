import 'package:dio/dio.dart';

import '../constants/api_constants.dart';

/// One configured Dio instance for the whole app.
/// Add interceptors here (auth, logging, retry) as the app grows.
Dio createDio() {
  return Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
    ),
  );
}
