import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feed_media/feed_media/providers/playback_controller.dart';
import 'package:flutter_feed_media/feed_media/models/feed_media_model.dart';
import 'package:flutter_feed_media/feed_media/ui/feed_media_overlay_ui.dart';
import 'package:flutter_feed_media/feed_media/ui/feed_media_photo_viewer.dart';
import 'package:flutter_feed_media/feed_media/ui/feed_media_video_player.dart';
import 'package:flutter_feed_media/feed_media/ui/feed_media_progress_bar.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedMediaItemPage extends ConsumerStatefulWidget {
  final FeedMediaModel media;

  const FeedMediaItemPage({super.key, required this.media});

  @override
  ConsumerState<FeedMediaItemPage> createState() => _FeedMediaItemPageState();
}

class _FeedMediaItemPageState extends ConsumerState<FeedMediaItemPage> {
  BetterPlayerController? _betterPlayerController;
  bool _isMuted = false;

  void _onControllerReady(BetterPlayerController controller) {
    _betterPlayerController = controller;
    _betterPlayerController?.setVolume(_isMuted ? 0 : 1);
    _betterPlayerController?.addEventsListener((event) {
      if (mounted) {
        setState(() {
          // No longer managing _showProgressBar here, it will be managed by the parent
        });
      }
    });
  }

  void _togglePlayPause() {
    if (_betterPlayerController == null) return;
    if (_betterPlayerController!.isPlaying() == true) {
      _betterPlayerController!.pause();
    } else {
      _betterPlayerController!.play();
    }
  }

  void _toggleMute() {
    setState(() {
      _isMuted = !_isMuted;
      _betterPlayerController?.setVolume(_isMuted ? 0 : 1);
    });
  }

  void _showOptionsDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(leading: const Icon(Icons.speed), title: const Text('Playback speed'), onTap: () {}),
          ListTile(leading: const Icon(Icons.save_alt), title: const Text('Save video'), onTap: () {}),
          ListTile(leading: const Icon(Icons.not_interested), title: const Text('Not interested'), onTap: () {}),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageIndex = int.parse(widget.media.id.split('_').last);
    final isPlaying = ref.watch(playbackControllerProvider.select((value) => value == pageIndex));

    // Determine if progress bar should be shown
    final bool showProgressBar = widget.media.type == 'video' &&
        _betterPlayerController != null &&
        (_betterPlayerController!.isPlaying() == false || _betterPlayerController!.isBuffering() == true);

    return Stack(
      children: [
        if (widget.media.type == 'video')
          GestureDetector(
            onTap: _togglePlayPause,
            onLongPress: _showOptionsDialog,
            child: FeedMediaVideoPlayer(
              url: widget.media.url,
              coverUrl: widget.media.coverUrl,
              isActive: isPlaying,
              onControllerReady: _onControllerReady,
            ),
          )
        else if (widget.media.type == 'image' && widget.media.imageUrls != null && widget.media.imageUrls!.isNotEmpty)
          FeedMediaPhotoViewer(imageUrls: widget.media.imageUrls!)
        else
          FeedMediaPhotoViewer(imageUrls: [widget.media.url]),
        FeedMediaOverlayUI(
          media: widget.media,
          isMuted: _isMuted,
          onToggleMute: _toggleMute,
        ),
        if (widget.media.type == 'video' && _betterPlayerController != null && showProgressBar)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: FeedMediaProgressBar(controller: _betterPlayerController!),
          ),
      ],
    );
  }
}


