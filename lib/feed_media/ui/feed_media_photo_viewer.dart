import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class FeedMediaPhotoViewer extends StatefulWidget {
  final List<String> imageUrls;

  const FeedMediaPhotoViewer({super.key, required this.imageUrls});

  @override
  State<FeedMediaPhotoViewer> createState() => _FeedMediaPhotoViewerState();
}

class _FeedMediaPhotoViewerState extends State<FeedMediaPhotoViewer> {
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return const Center(child: Text('No images to display'));
    }

    return PageView.builder(
      controller: _pageController,
      itemCount: widget.imageUrls.length,
      itemBuilder: (context, index) {
        final imageUrl = widget.imageUrls[index];
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
    );
  }
}
