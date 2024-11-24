import 'app_model.dart';

class ImageModel extends AppModel {
  final String url;
  final int width;
  final int height;

  // constructor
  const ImageModel({
    required this.url,
    required this.width,
    required this.height,
  });

  @override
  List<Object?> get props => [url, width, height];

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'url': url,
      'width': width,
      'height': height,
    };
  }

  factory ImageModel.fromJson(Map<String, dynamic> map) {
    return ImageModel(
      url: map['url'] as String,
      width: map['width'] as int,
      height: map['height'] as int,
    );
  }
}
