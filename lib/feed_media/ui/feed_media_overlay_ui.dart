import 'package:better_player/better_player.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feed_media/feed_media/models/feed_media_model.dart';
import 'package:flutter_feed_media/feed_media/ui/audio_indicator.dart';
import 'package:flutter_feed_media/feed_media/ui/feed_media_bottom_info.dart';
import 'package:flutter_feed_media/feed_media/ui/feed_media_left_actions.dart';
import 'package:flutter_feed_media/feed_media/ui/feed_media_progress_bar.dart';

class FeedMediaOverlayUI extends StatelessWidget {
  final FeedMediaModel media;
  final bool isMuted;
  final VoidCallback onToggleMute;
  final int currentImageIndex;
  final BetterPlayerController? betterPlayerController;
  final bool showProgressBar;

  const FeedMediaOverlayUI({
    super.key,
    required this.media,
    required this.isMuted,
    required this.onToggleMute,
    this.currentImageIndex = 0,
    this.betterPlayerController,
    this.showProgressBar = false,
  });

  @override
  Widget build(BuildContext context) {
    final bool isMultiImage =
        media.type == 'image' && media.imageUrls != null && media.imageUrls!.length > 1;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      // --- Video Progress Bar (conditionally displayed) ---
                      if (media.type == 'video' && betterPlayerController != null)
                        Visibility(
                          visible: showProgressBar,
                          maintainSize: true,
                          maintainAnimation: true,
                          maintainState: true,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 8.0), // Add some padding from bottom info
                            child: FeedMediaProgressBar(controller: betterPlayerController!),
                          ),
                        ),
                      if (isMultiImage)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0),
                          child: DotsIndicator(
                            dotsCount: media.imageUrls!.length,
                            position: currentImageIndex.toDouble(),
                            decorator: DotsDecorator(
                              color: Colors.white.withOpacity(0.5),
                              activeColor: Colors.white,
                              size: const Size.square(8.0),
                              activeSize: const Size(20.0, 8.0),
                              activeShape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                            ),
                          ),
                        ),
                      FeedMediaBottomInfo(media: media),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    const FeedMediaLeftActions(),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: onToggleMute,
                      child: Icon(
                        isMuted ? Icons.volume_off : Icons.volume_up,
                        color: Colors.white,
                        size: 35,
                      ),
                    ),
                    const SizedBox(height: 20),
                    const AudioIndicator(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

