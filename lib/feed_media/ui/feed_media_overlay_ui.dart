import 'package:flutter/material.dart';
import 'package:flutter_feed_media/feed_media/models/feed_media_model.dart';
import 'package:flutter_feed_media/feed_media/ui/audio_indicator.dart';
import 'package:flutter_feed_media/feed_media/ui/feed_media_bottom_info.dart';
import 'package:flutter_feed_media/feed_media/ui/feed_media_left_actions.dart';

class FeedMediaOverlayUI extends StatelessWidget {
  final FeedMediaModel media;
  final bool isMuted;
  final VoidCallback onToggleMute;

  const FeedMediaOverlayUI({
    super.key,
    required this.media,
    required this.isMuted,
    required this.onToggleMute,
  });

  @override
  Widget build(BuildContext context) {
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
                  child: FeedMediaBottomInfo(media: media),
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