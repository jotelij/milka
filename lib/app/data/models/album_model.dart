import 'app_model.dart';
import 'artist_model.dart';
import 'image_model.dart';

class AlbumModel extends AppModel {
  final String name;
  final String albumType;
  final List<ImageModel> images;
  final List<ArtistModel> artists;
  final String releaseDate;

  // constructor
  const AlbumModel({
    required this.name,
    required this.albumType,
    required this.artists,
    required this.releaseDate,
    this.images = const [],
  });

  factory AlbumModel.fromJson(Map<String, dynamic> map) {
    return AlbumModel(
      name: map['name'] as String,
      albumType: map['album_type'] as String,
      images: map['images'] == null
          ? []
          : List<ImageModel>.from(
              (map['images'] as List<dynamic>).map<ImageModel>(
                (x) => ImageModel.fromJson(x as Map<String, dynamic>),
              ),
            ),
      artists: List<ArtistModel>.from(
        (map['artists'] as List<dynamic>).map<ArtistModel>(
          (x) => ArtistModel.fromJson(x as Map<String, dynamic>),
        ),
      ),
      releaseDate: map['release_date'] as String,
    );
  }

  // single album checking getter
  bool get isSingle => albumType == "single";

  // gets artists name from artists list
  String get artistsName => artists.map((e) => e.name).toList().join(", ");

  // gets first image URL from the images list
  String? get imageUrl => images.isNotEmpty ? images[0].url : null;

  // a year getter from release date
  String get year => releaseDate.substring(0, 4);

  // props for equatablility
  @override
  List<Object?> get props => [name, images, artists, releaseDate];
}
