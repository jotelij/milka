import 'package:equatable/equatable.dart';

class TokenModel extends Equatable {
  final String accessToken;
  final DateTime expireTime;

  const TokenModel({required this.accessToken, required this.expireTime});

  @override
  List<Object?> get props => [accessToken, expireTime];

  factory TokenModel.fromJson(Map<String, dynamic> map) {
    return TokenModel(
      accessToken: map['access_token'] as String,
      expireTime:
          DateTime.now().add(Duration(seconds: map['expires_in'] as int)),
    );
  }
}
