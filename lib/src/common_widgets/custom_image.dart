import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// Custom image widget that loads an image as a static asset or uses
/// [CachedNetworkImage] depending on the image url.
class CustomImage extends StatelessWidget {
  const CustomImage({Key? key, required this.imageUrl}) : super(key: key);
  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    if (imageUrl.contains("https")) {
      // TODO: Handle CORS https://flutter.dev/docs/development/platform-integration/web-images
      return CachedNetworkImage(imageUrl: imageUrl);
    } else {
      return Image.asset(imageUrl);
    }
  }
}
