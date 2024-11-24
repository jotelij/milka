import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'data/enums.dart';
import 'data/repository.dart';
import 'blocs/search_cubit.dart';
import 'widgets/widgets.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => SearchCubit(
        repository: Repository.instance,
      ),
      child: const SearchBody(),
    );
  }
}

class SearchBody extends StatelessWidget {
  const SearchBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24.0, 32.0, 24.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            children: [
              Text(
                "Search",
                style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(
                height: 16,
              ),
              // textbox for searching
              TextField(
                autofocus: false,
                onTap: () => BlocProvider.of<SearchCubit>(context).initiate(),
                onChanged: (value) =>
                    BlocProvider.of<SearchCubit>(context).search(value),
                decoration: InputDecoration(
                  hintText: "Artists, albums...",
                  hintStyle: Theme.of(context).textTheme.bodySmall,
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: const Icon(
                    CupertinoIcons.search,
                    color: Colors.black,
                  ),
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 24),
              // search type selecting rows --> Albums or Artists
              BlocBuilder<SearchCubit, SearchState>(
                builder: (context, state) {
                  if (state.searchType == null) {
                    return Container();
                  }
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      SearchTypeButton(
                        name: "Albums",
                        isSelected: state.searchType == SearchType.albums,
                        onPressed: () => BlocProvider.of<SearchCubit>(context)
                            .changeSearchType(SearchType.albums),
                      ),
                      SearchTypeButton(
                        name: "Artists",
                        isSelected: state.searchType == SearchType.artists,
                        onPressed: () => BlocProvider.of<SearchCubit>(context)
                            .changeSearchType(SearchType.artists),
                      ),
                    ],
                  );
                },
              ),
              const SizedBox(height: 24),
              Expanded(
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    if (state.stateType == SearchStateType.Initial) {
                      return Container();
                    } else if (state.stateType == SearchStateType.Error) {
                      return Center(
                        child: Text(
                          state.errorMessage!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      );
                    } else if (state.stateType == SearchStateType.Loading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state.stateType == SearchStateType.Success) {
                      if (state.searchType == SearchType.albums) {
                        if (state.responseModel.albums.isNotEmpty) {
                          return GridView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: const BouncingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.65,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemBuilder: (_, index) => AlbumGridWidget(
                              albumEntity: state.responseModel.albums[index],
                            ),
                            // itemBuilder: (_, index) => Container(),
                            itemCount: state.responseModel.albums.length,
                          );
                        } else {
                          return const Center(
                            child: Text("No album found.",
                                style: TextStyle(color: Colors.white)),
                          );
                        }
                      } else if (state.searchType == SearchType.artists) {
                        if (state.responseModel.artists.isNotEmpty) {
                          return ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            itemCount: state.responseModel.artists.length,
                            physics: const BouncingScrollPhysics(),
                            // padding: EdgeInsets.zero,
                            itemBuilder: (context, index) => ArtistTileWidget(
                              artistEntity: state.responseModel.artists[index],
                            ),
                          );
                        } else {
                          return const Center(
                            child: Text("No artist found.",
                                style: TextStyle(color: Colors.white)),
                          );
                        }
                      }
                    }

                    return Container();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
