import 'package:flutter/material.dart';

class AppConstants {
  AppConstants._();

  static const String appName = "Milka";
  static const String apiEndpoint = "https://api.spotify.com/v1";
  static const String apiAccountEndpoint = "https://accounts.spotify.com/api";

  // !!!! SECURITY IN CONSIDERATION !!!!
  static const String clientID = "3af8e17840684c5bb3325a5e8b8e808d";
  static const String clientSecret = "e46b037b7f76416ca7e3ac9676f557f7";

  static const requestTimeoutSeconds = 30;

  // colors
  static const Color bgColor = Colors.black;
  static const Color mainTextColor = Colors.white;
  static const Color lightTextColor = Colors.white70;
  static const Color greyTextColor = Colors.grey;
}
