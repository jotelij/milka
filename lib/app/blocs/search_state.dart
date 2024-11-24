part of 'search_cubit.dart';

class SearchState extends Equatable {
  final SearchStateType stateType;
  final SearchType? searchType;
  final ResponseModel responseModel;
  final String? errorMessage;

  const SearchState({
    this.stateType = SearchStateType.Initial,
    this.searchType,
    this.responseModel = const ResponseModel(),
    this.errorMessage,
  });

  bool get hasError => errorMessage != null;

  @override
  List<Object?> get props => [
        stateType,
        searchType,
        responseModel,
        errorMessage,
      ];

  SearchState copyWith({
    SearchStateType? stateType,
    SearchType? searchType,
    ResponseModel? responseModel,
    String? errorMessage,
  }) {
    return SearchState(
      stateType: stateType ?? this.stateType,
      searchType: searchType ?? this.searchType,
      responseModel: responseModel ?? this.responseModel,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}
