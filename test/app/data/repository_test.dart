import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:milka/app/data/repository.dart';
import 'package:milka/core/app_errors.dart';

void main() {
  late final Dio dio = Dio(BaseOptions());
  late final Dio refreshDio = Dio(BaseOptions());

  final dioAdapter = DioAdapter(dio: dio);
  final dioRefreshAdapter = DioAdapter(dio: refreshDio);

  late final Repository repository;

  setUp(() {
    repository = Repository(dio: dio, refreshDio: refreshDio);
  });

  group('Search Results', () {
    final Map<String, dynamic> jsonResults = {
      'artists': {
        'href': 'aaaaa',
        'items': [
          {
            'name': 'artist 1',
            'images': null,
          },
          {
            'name': 'artist 2',
            'images': null,
          },
          {
            'name': 'artist 3',
            'images': null,
          },
          {
            'name': 'artist 4',
            'images': null,
          }
        ],
      },
      'albums': {
        'href': 'aaaaa',
        'items': [
          {
            'name': 'album 1',
            'release_date': '2024-11',
            'album_type': 'single',
            'image': [],
            'artists': [
              {
                'name': 'artist 1',
                'images': null,
              }
            ],
          },
          {
            'name': 'album 2',
            'release_date': '2023-11',
            'album_type': 'single',
            'images': [],
            'artists': [
              {
                'name': 'artist 2',
                'images': null,
              }
            ],
          },
        ],
      },
    };

    test('Should return search results successfully upon successful search',
        () async {
      // arrange
      dioAdapter.onGet(
        "/search",
        queryParameters: {
          'q': "searchWord",
          'type': "album,artist",
        },
        (server) => server.reply(
          200,
          jsonResults,
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );
      // act
      final result = await repository.searchResult("searchWord");
      // assert
      expect(result.albums.length, 2);
      expect(result.artists.length, 4);
    });

    test('should throw AppException up on encountaring error', () async {
      // arrange
      dioAdapter.onGet(
        "/search",
        queryParameters: {
          'q': "searchWord",
          'type': "album,artist",
        },
        (server) => server.reply(
          404,
          {'error': 'error'},
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );
      //
      //
      expect(() async => await repository.searchResult("searchWord"),
          throwsA(isA<AppException>()));
    });
  });

  group('Token Refresh', () {
    final Map<String, dynamic> successResults = {
      "access_token": "NgCXRKc...MzYjw",
      "token_type": "bearer",
      "expires_in": 3600
    };

    test('Should return access token upon successlly login', () async {
      final beforeToken = repository.getAccessToken;
      // arrange
      dioRefreshAdapter.onPost(
        "/token",
        data: {
          'grant_type': 'client_credentials',
        },
        (server) => server.reply(
          200,
          successResults,
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );
      // act
      final result = await repository.refreshToken();
      // assert
      expect(repository.getAccessToken, result.accessToken);
      expect(repository.getAccessToken, isNot(beforeToken));
    });

    test('Should throw AppException upon encountering error', () async {
      // arrange
      dioRefreshAdapter.onPost(
        "/token",
        data: {
          'grant_type': 'client_credentials',
        },
        (server) => server.reply(
          401,
          {'error': 'error'},
          // Reply would wait for one-sec before returning data.
          delay: const Duration(seconds: 1),
        ),
      );
      // act
      // assert
      expect(() async => await repository.searchResult("searchWord"),
          throwsA(isA<AppException>()));
    });
  });
}
