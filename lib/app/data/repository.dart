import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:milka/core/app_errors.dart';

import '../../core/app_constants.dart';
import 'i_repository.dart';
import 'models/models.dart';

class Repository implements IRepository {
  // dio used for making search requests
  late final Dio _dio;

  // dio used for making authentication and token refresh
  late final Dio _refreshDio;

  // the token value with expire time saved
  TokenModel? _tokenModel;

  // dio when provided as parameter => used for
  @visibleForTesting
  Repository({required Dio dio, required Dio refreshDio})
      : _dio = dio,
        _refreshDio = refreshDio;

  // singleton instance of the repository setup
  Repository._singleton() {
    /// SEARCHINF DIO SETUP
    // initiate the dio
    _dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiEndpoint,
        connectTimeout:
            const Duration(seconds: AppConstants.requestTimeoutSeconds),
        receiveTimeout:
            const Duration(seconds: AppConstants.requestTimeoutSeconds),
      ),
    );

    // add interceptor to the dio
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          /// Add the access token to the request header

          // check if token exists and it is not to expire in 1 min
          if (_tokenModel == null ||
              _tokenModel!.expireTime
                  .isBefore(DateTime.now().add(const Duration(minutes: 1)))) {
            try {
              await refreshToken();
            } catch (e) {
              return handler.reject(DioException(requestOptions: options));
            }
          }
          options.headers['Authorization'] = "Bearer $getAccessToken";
          return handler.next(options);
        },
        onError: (DioException e, handler) async {
          if (e.response?.statusCode == 401) {
            // If a 401 response is received, refresh the access token
            try {
              await refreshToken();
            } catch (ex) {
              return handler
                  .reject(DioException(requestOptions: e.requestOptions));
            }

            // Update the request header with the new access token
            e.requestOptions.headers['Authorization'] =
                'Bearer $getAccessToken';

            // Repeat the request with the updated header
            return handler.resolve(await _dio.fetch(e.requestOptions));
          }
          return handler.next(e);
        },
      ),
    );

    /// REFRESH DIO SETUP
    // create new dio instance for token refereshing
    _refreshDio = Dio(
      BaseOptions(
        baseUrl: AppConstants.apiAccountEndpoint,
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        // contentType: Headers.formUrlEncodedContentType,
      ),
    );
  }

  static final Repository instance = Repository._singleton();

  @override
  String? get getAccessToken => _tokenModel?.accessToken;

  @override
  Future<TokenModel> refreshToken() async {
    try {
      // fetch the access token
      final rawToken = await _refreshDio.post<Map<String, dynamic>>(
        "/token",
        data: {
          'grant_type': 'client_credentials',
        },
        options: Options(
          headers: {
            "Content-Type": "application/x-www-form-urlencoded",
            "Authorization":
                "Basic ${base64Encode(utf8.encode('${AppConstants.clientID}:${AppConstants.clientSecret}'))}",
          },
        ),
      );

      // deserialize the token JSON
      final result = TokenModel.fromJson(rawToken.data!);

      // assign the token
      _tokenModel = result;

      return result;
    } catch (e) {
      throw const AppErrors(message: "Authentication Error occured.");
    }
  }

  @override
  Future<ResponseModel> searchResult(String searchWord) async {
    try {
      final response = await _dio.get(
        '/search',
        queryParameters: {
          'q': searchWord,
          'type': "album,artist",
        },
        options: Options(
          validateStatus: (status) => status != null && status < 404,
        ),
      );

      final result = ResponseModel.fromJson(response.data!);
      return result;
    } on DioException catch (e) {
      throw AppException(message: e.response?.statusMessage ?? "Unknown Error");
    } catch (e) {
      throw AppException(message: "Unknown Error");
    }
  }
}
