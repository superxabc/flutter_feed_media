import 'package:better_player/better_player.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feed_media/feed_media/models/feed_media_model.dart';
import 'package:flutter_feed_media/feed_media/ui/audio_indicator.dart';
import 'package:flutter_feed_media/feed_media/ui/feed_media_bottom_info.dart';
import 'package:flutter_feed_media/feed_media/ui/feed_media_left_actions.dart';
import 'package:flutter_feed_media/feed_media/ui/video_overlay_controller.dart';

class FeedMediaOverlayUI extends StatefulWidget {
  final FeedMediaModel media;
  final int currentImageIndex;
  final BetterPlayerController? betterPlayerController;
  final GlobalKey? leftActionsKey;

  const FeedMediaOverlayUI({
    super.key,
    required this.media,
    this.currentImageIndex = 0,
    this.betterPlayerController,
    this.leftActionsKey,
  });

  @override
  State<FeedMediaOverlayUI> createState() => _FeedMediaOverlayUIState();
}

class _FeedMediaOverlayUIState extends State<FeedMediaOverlayUI> {
  @override
  Widget build(BuildContext context) {
    final bool isMultiImage = widget.media.type == 'image' &&
        widget.media.imageUrls != null &&
        widget.media.imageUrls!.length > 1;

    return Stack(
      fit: StackFit.expand,
      children: [
        _buildBaseOverlayContent(isMultiImage),
        if (widget.media.type == 'video' && widget.betterPlayerController != null)
          VideoOverlayController(
            controller: widget.betterPlayerController!,
            onSeekTo: (duration) {
              debugPrint('Video seeked to: ${duration.inSeconds}s');
            },
            onPlayResume: () {
              debugPrint('Video resumed playing');
            },
          ),
      ],
    );
  }

  Widget _buildBaseOverlayContent(bool isMultiImage) {
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
                      AbsorbPointer(
                        child: FeedMediaBottomInfo(media: widget.media),
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IgnorePointer(
                      ignoring: false,
                      child: FeedMediaLeftActions(key: widget.leftActionsKey),
                    ),
                    const SizedBox(height: 20),
                    const AudioIndicator(),
                  ],
                ),
              ],
            ),
          ),
          if (isMultiImage)
            AbsorbPointer(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: DotsIndicator(
                    dotsCount: widget.media.imageUrls!.length,
                    position: widget.currentImageIndex.toDouble(),
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
              ),
            ),
        ],
      ),
    );
  }
}
