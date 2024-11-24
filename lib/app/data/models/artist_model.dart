import 'app_model.dart';
import 'image_model.dart';

class ArtistModel extends AppModel {
  final String name;
  final List<ImageModel> images;

  // constructor
  const ArtistModel({
    required this.name,
    this.images = const [],
  });

  // gets first image URL from the images list
  String? get imageUrl => images.isNotEmpty ? images[0].url : null;

  @override
  List<Object?> get props => [name, images];

  factory ArtistModel.fromJson(Map<String, dynamic> map) {
    return ArtistModel(
      name: map['name'] as String,
      images: map['images'] == null
          ? []
          : List<ImageModel>.from(
              (map['images'] as List<dynamic>).map<ImageModel>(
                (x) => ImageModel.fromJson(x as Map<String, dynamic>),
              ),
            ),
    );
  }
}
