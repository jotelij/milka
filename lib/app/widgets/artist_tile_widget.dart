import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../data/models/models.dart';

class ArtistTileWidget extends StatelessWidget {
  const ArtistTileWidget({super.key, required this.artistEntity});

  final ArtistModel artistEntity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: CircleAvatar(
          radius: 30,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: CachedNetworkImage(
              imageUrl:
                  artistEntity.imageUrl ?? "http://via.placeholder.com/200x200",
              progressIndicatorBuilder: (context, url, downloadProgress) =>
                  CircularProgressIndicator(value: downloadProgress.progress),
              errorWidget: (context, url, error) => const Icon(Icons.error),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(
          artistEntity.name,
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
