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
  BetterPlayerController? _betterPlayerController;
  bool _hasError = false;
  bool _isInitialized = false;
  bool _isDisposed = false;

  @override
  void initState() {
    super.initState();
    _initializePlayer();
  }

  void _initializePlayer() {
    if (_isDisposed) return;

    _betterPlayerController = BetterPlayerController(
      const BetterPlayerConfiguration(
        aspectRatio: 9 / 16,
        fit: BoxFit.cover,
        autoPlay: true,
        looping: true,
        controlsConfiguration:
            BetterPlayerControlsConfiguration(showControls: false),
        placeholder: Center(child: CircularProgressIndicator()),
      ),
      betterPlayerDataSource: BetterPlayerDataSource(
        BetterPlayerDataSourceType.network,
        widget.url,
        cacheConfiguration:
            const BetterPlayerCacheConfiguration(useCache: true),
      ),
    );

    // 安全的事件监听器添加
    _betterPlayerController?.addEventsListener(_handlePlayerEvents);

    if (widget.isActive && !_isDisposed) {
      _betterPlayerController?.play();
    } else if (!_isDisposed) {
      _betterPlayerController?.pause();
    }
  }

  // 安全的事件处理方法
  void _handlePlayerEvents(BetterPlayerEvent event) {
    // 检查组件是否已销毁
    if (!mounted || _isDisposed) return;

    // 使用 WidgetsBinding.instance.addPostFrameCallback 确保在安全的时机更新状态
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _isDisposed) return;

      try {
        setState(() {
          _isInitialized =
              event.betterPlayerEventType == BetterPlayerEventType.initialized;
          if (event.betterPlayerEventType == BetterPlayerEventType.exception) {
            _hasError = true;
          }
        });

        if (event.betterPlayerEventType == BetterPlayerEventType.initialized) {
          widget.onControllerReady(_betterPlayerController!);
        }
      } catch (e) {
        debugPrint('Error handling player events: $e');
      }
    });
  }

  @override
  void didUpdateWidget(covariant FeedMediaVideoPlayer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (_isDisposed) return;

    try {
      if (widget.isActive && !oldWidget.isActive) {
        _betterPlayerController?.play();
      } else if (!widget.isActive && oldWidget.isActive) {
        _betterPlayerController?.pause();
      }
    } catch (e) {
      debugPrint('Error updating widget: $e');
    }
  }

  @override
  void dispose() {
    _isDisposed = true;

    // 安全地移除事件监听器和释放资源
    try {
      _betterPlayerController?.removeEventsListener(_handlePlayerEvents);
      _betterPlayerController?.dispose();
    } catch (e) {
      debugPrint('Error disposing video player: $e');
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasError || _isDisposed) {
      return const Center(child: Icon(Icons.error, color: Colors.white));
    }

    if (_betterPlayerController == null) {
      return const Center(child: CircularProgressIndicator());
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
            errorWidget: (context, url, error) => const Center(
              child: Icon(Icons.error, color: Colors.white),
            ),
          ),
        BetterPlayer(controller: _betterPlayerController!),
      ],
    );
  }
}
