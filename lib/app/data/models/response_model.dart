import 'package:equatable/equatable.dart';

import 'album_model.dart';
import 'artist_model.dart';

class ResponseModel extends Equatable {
  final List<ArtistModel> artists;
  final List<AlbumModel> albums;

  const ResponseModel({
    this.artists = const [],
    this.albums = const [],
  });

  @override
  List<Object?> get props => [artists, albums];

  factory ResponseModel.fromJson(Map<String, dynamic> map) {
    final List artistsItems = map['artists']['items'] ?? [];
    final List albumItems = map['albums']['items'] ?? [];

    return ResponseModel(
      artists: List<ArtistModel>.from(
        (artistsItems)
            .where((e) => (e as Map<String, dynamic>?) != null)
            .map<ArtistModel>(
              (x) => ArtistModel.fromJson(x as Map<String, dynamic>),
            ),
      ),
      albums: List<AlbumModel>.from(
        (albumItems)
            .where((e) => (e as Map<String, dynamic>?) != null)
            .map<AlbumModel>(
              (x) => AlbumModel.fromJson(x as Map<String, dynamic>),
            ),
      ),
    );
  }
}
