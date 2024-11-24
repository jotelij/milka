import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:milka/app/data/enums.dart';
import 'package:milka/app/data/models/models.dart';
import 'package:milka/core/app_errors.dart';
import 'package:mockito/annotations.dart';
import 'package:milka/app/blocs/search_cubit.dart';
import 'package:milka/app/data/i_repository.dart';
import 'package:mockito/mockito.dart';

import 'search_cubit_test.mocks.dart';

@GenerateMocks([IRepository])
void main() {
  late final IRepository repository = MockIRepository();

  setUp(() {});

  group('Search Types', () {
    blocTest(
      "Should emit state containing albums search upon initiation",
      build: () => SearchCubit(repository: repository),
      act: (bloc) => bloc.initiate(),
      expect: () => [const SearchState(searchType: SearchType.albums)],
    );

    blocTest(
      "Should emit albums search state upon change to albums",
      build: () => SearchCubit(repository: repository),
      act: (bloc) => bloc.changeSearchType(SearchType.albums),
      expect: () => [const SearchState(searchType: SearchType.albums)],
    );

    blocTest(
      "Should emit artist search state upon change artists",
      build: () => SearchCubit(repository: repository),
      act: (bloc) => bloc.changeSearchType(SearchType.artists),
      expect: () => [const SearchState(searchType: SearchType.artists)],
    );
  });

  group("Search Word", () {
    blocTest(
      "Should emit loading, error state upon exception is thrown",
      setUp: (() {
        return when(repository.searchResult("searchWord")).thenThrow(
          (_) async => AppException(message: "Error occured"),
        );
      }),
      build: () => SearchCubit(repository: repository),
      act: (bloc) => bloc.search("searchWord"),
      wait: const Duration(seconds: 2),
      expect: () => [
        const SearchState(stateType: SearchStateType.Loading),
        const SearchState(
          stateType: SearchStateType.Error,
          errorMessage: "Error occured",
        ),
      ],
    );

    blocTest(
      "Should emit loading, success state upon successful parse",
      setUp: (() {
        return when(repository.searchResult("searchWord")).thenAnswer(
          (_) async => const ResponseModel(albums: [], artists: []),
        );
      }),
      build: () => SearchCubit(repository: repository),
      act: (bloc) => bloc.search("searchWord"),
      wait: const Duration(seconds: 2),
      expect: () => [
        const SearchState(stateType: SearchStateType.Loading),
        const SearchState(stateType: SearchStateType.Success),
      ],
    );
  });
}
