import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/i_repository.dart';
import '../data/repository.dart';
import '../data/enums.dart';
import '../data/models/models.dart';

part 'search_state.dart';

// search CUBIT
class SearchCubit extends Cubit<SearchState> {
  final IRepository repository;

  SearchCubit({required this.repository}) : super(const SearchState());

  // initiate the search type to emit state enabling a album & artists buttom shows
  void initiate() {
    if (state.searchType == null) {
      emit(state.copyWith(searchType: SearchType.albums));
    }
  }

  // a function to change search type -> album/artists
  void changeSearchType(SearchType? type) {
    emit(state.copyWith(searchType: type));
  }

  // a function to search a query
  Future<void> search(String searchWord) async {
    // emit the searching state
    emit(
      state.copyWith(
        stateType: SearchStateType.Loading,
        errorMessage: null,
      ),
    );
    try {
      final result = await Repository.instance.searchResult(searchWord);
      emit(
        state.copyWith(
          stateType: SearchStateType.Success,
          responseModel: result,
          errorMessage: null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          stateType: SearchStateType.Error,
          errorMessage: "Error occured",
        ),
      );
    }
  }
}
