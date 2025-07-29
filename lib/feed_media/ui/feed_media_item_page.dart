import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feed_media/feed_media/providers/playback_controller.dart';
import 'package:flutter_feed_media/feed_media/models/feed_media_model.dart';
import 'package:flutter_feed_media/feed_media/ui/feed_media_overlay_ui.dart';
import 'package:flutter_feed_media/feed_media/ui/feed_media_photo_viewer.dart';
import 'package:flutter_feed_media/feed_media/ui/feed_media_video_player.dart';
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
  int _currentImageIndex = 0; // State for image indicator

  void _onControllerReady(BetterPlayerController controller) {
    _betterPlayerController = controller;
    _betterPlayerController?.setVolume(_isMuted ? 0 : 1);
    _betterPlayerController?.addEventsListener((event) {
      if (mounted) {
        setState(() {
          // Re-render to update progress bar visibility
        });
      }
    });
  }

  void _togglePlayPause() {
    if (widget.media.type != 'video') return; // Only toggle for videos
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

  void _showVideoOptionsDialog() {
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

  void _showImageOptionsDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(leading: const Icon(Icons.save_alt), title: const Text('Save image'), onTap: () {}),
          ListTile(leading: const Icon(Icons.share), title: const Text('Share image'), onTap: () {}),
          ListTile(leading: const Icon(Icons.not_interested), title: const Text('Not interested'), onTap: () {}),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageIndex = int.parse(widget.media.id.split('_').last);
    final isPlaying = ref.watch(playbackControllerProvider.select((value) => value == pageIndex));

    final bool showProgressBar = widget.media.type == 'video' &&
        _betterPlayerController != null &&
        (_betterPlayerController!.isPlaying() == false || _betterPlayerController!.isBuffering() == true);

    return Stack(
      fit: StackFit.expand,
      children: [
        // --- Media Content (Video or Image) ---
        if (widget.media.type == 'video')
          FeedMediaVideoPlayer(
            url: widget.media.url,
            coverUrl: widget.media.coverUrl,
            isActive: isPlaying,
            onControllerReady: _onControllerReady,
          )
        else if (widget.media.type == 'image' && widget.media.imageUrls != null && widget.media.imageUrls!.isNotEmpty)
          FeedMediaPhotoViewer(
            imageUrls: widget.media.imageUrls!,
            onPageChanged: (index) {
              setState(() {
                _currentImageIndex = index;
              });
            },
          )
        else
          // Fallback for single image
          FeedMediaPhotoViewer(
            imageUrls: [widget.media.url],
            onPageChanged: (index) {},
          ),

        // --- Play/Pause Icon (conditionally displayed for video) ---
        if (widget.media.type == 'video' && _betterPlayerController != null)
          IgnorePointer( // Ignore taps on the icon itself
            child: _buildPlayPauseIcon(_betterPlayerController!),
          ),

        // --- Overlay UI (now with indicator logic and progress bar) ---
        Material(
          type: MaterialType.transparency,
          child: FeedMediaOverlayUI(
            media: widget.media,
            isMuted: _isMuted,
            onToggleMute: _toggleMute,
            currentImageIndex: _currentImageIndex,
            betterPlayerController: _betterPlayerController, // Pass controller
            showProgressBar: showProgressBar, // Pass showProgressBar
          ),
        ),

        // --- Full-screen Tap Detector for Play/Pause (LAST CHILD = ON TOP) ---
        Positioned.fill(
          child: GestureDetector(
            onTap: _togglePlayPause,
            onLongPress: () {
              if (widget.media.type == 'video') {
                _showVideoOptionsDialog();
              } else if (widget.media.type == 'image') {
                _showImageOptionsDialog();
              }
            },
            behavior: HitTestBehavior.translucent, // Ensures it's hit-testable even if child is transparent
            child: Container(), // Transparent, but hit-testable
          ),
        ),
      ],
    );
  }

  Widget _buildPlayPauseIcon(BetterPlayerController controller) {
    return AnimatedOpacity(
      opacity: (controller.isPlaying() ?? false) || (controller.isBuffering() ?? false) ? 0.0 : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Center(
        child: Icon(
          (controller.isPlaying() ?? false) ? Icons.pause_circle_filled : Icons.play_circle_filled,
          color: Colors.white.withOpacity(0.7),
          size: 80,
        ),
      ),
    );
  }
}





