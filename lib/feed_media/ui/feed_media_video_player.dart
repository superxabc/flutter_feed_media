import 'package:better_player/better_player.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class FeedMediaVideoPlayer extends StatefulWidget {
  final String url;
  final String coverUrl;
  final bool isActive;
  final Function(BetterPlayerController) onControllerReady;

  const FeedMediaVideoPlayer({
    super.key,
    required this.url,
    required this.coverUrl,
    required this.isActive,
    required this.onControllerReady,
  });

  @override
  State<FeedMediaVideoPlayer> createState() => _FeedMediaVideoPlayerState();
}

class _FeedMediaVideoPlayerState extends State<FeedMediaVideoPlayer> {
  late BetterPlayerController _betterPlayerController;
  bool _hasError = false;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    _betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(
        aspectRatio: 9 / 16,
        fit: BoxFit.cover,
        autoPlay: true,
        looping: true,
        controlsConfiguration: BetterPlayerControlsConfiguration(showControls: false),
        placeholder: Center(child: CircularProgressIndicator()),
      ),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.url,
        cacheConfiguration: const BetterPlayerCacheConfiguration(useCache: true),
      ),
    );

    _betterPlayerController.addEventsListener((event) {
      if (mounted) {
        setState(() {
          _isInitialized = event.betterPlayerEventType == BetterPlayerEventType.initialized;
          if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
            _hasError = true;
          }
        });
        if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
          widget.onControllerReady(_betterPlayerController);
        }
      }
    });

    if (widget.isActive) {
      _betterPlayerController.play();
    } else {
      _betterPlayerController.pause();
    }
  }

  @override
  void didUpdateWidget(covariant FeedMediaVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isActive && !oldWidget.isActive) {
      _betterPlayerController.play();
    } else if (!widget.isActive && oldWidget.isActive) {
      _betterPlayerController.pause();
    }
  }

  @override
  void dispose() {
    _betterPlayerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError) {
      return const Center(child: Icon(Icons.error, color: Colors.white));
    }

    return Stack(
      alignment: Alignment.center,
      children: [
        if (!_isInitialized)
          CachedNetworkImage(
            imageUrl: widget.coverUrl,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
        BetterPlayer(controller: _betterPlayerController),
      ],
    );
  }
}

