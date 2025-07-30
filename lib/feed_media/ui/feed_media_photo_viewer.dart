import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FeedMediaPhotoViewer extends StatelessWidget {
  final List<String> imageUrls;
  final void Function(int index) onPageChanged; // 必需的回调

  const FeedMediaPhotoViewer({
    super.key,
    required this.imageUrls,
    required this.onPageChanged,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrls.isEmpty) {
      return const Center(child: Text('No images to display'));
    }

    return CarouselSlider.builder(
      itemCount: imageUrls.length,
      itemBuilder: (context, index, realIndex) {
        final imageUrl = imageUrls[index];
        return PhotoView(
          imageProvider: CachedNetworkImageProvider(imageUrl),
          loadingBuilder: (context, event) => const Center(
            child: CircularProgressIndicator(),
          ),
          errorBuilder: (context, error, stackTrace) => const Center(
            child: Icon(Icons.error),
          ),
          disableGestures: true, // 禁用手势放大缩小
        );
      },
      options: CarouselOptions(
        height: MediaQuery.of(context).size.height,
        viewportFraction: 1.0,
        enableInfiniteScroll: false,
        onPageChanged: (index, reason) => onPageChanged(index),
      ),
    );
  }
}
