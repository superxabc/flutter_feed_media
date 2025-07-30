import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class _FeedMediaItemPageState extends ConsumerState<FeedMediaItemPage>
    with TickerProviderStateMixin {
  BetterPlayerController? _betterPlayerController;
  bool _isMuted = false;
  int _currentImageIndex = 0; // 重新添加：用于OverlayUI中的指示器显示

  // 双击点赞动画控制器
  late AnimationController _doubleTapAnimationController;
  late Animation<double> _heartScaleAnimation;
  late Animation<double> _heartOpacityAnimation;
  GlobalKey? _leftActionsKey;
  bool _showHeartAnimation = false;

  @override
  void initState() {
    super.initState();
    _leftActionsKey = GlobalKey();

    // 初始化双击动画控制器
    _doubleTapAnimationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _heartScaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _doubleTapAnimationController,
      curve: Curves.elasticOut,
    ));

    _heartOpacityAnimation = Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _doubleTapAnimationController,
      curve: const Interval(0.5, 1.0, curve: Curves.easeOut),
    ));
  }

  @override
  void dispose() {
    // 安全停止和释放动画控制器
    try {
      if (_doubleTapAnimationController.isAnimating) {
        _doubleTapAnimationController.stop();
      }
      _doubleTapAnimationController.dispose();
    } catch (e) {
      debugPrint('Error disposing double tap animation controller: $e');
    }

    // 安全地移除视频事件监听器
    try {
      _betterPlayerController?.removeEventsListener(_handleVideoEvents);
    } catch (e) {
      debugPrint('Error removing video events listener: $e');
    }

    super.dispose();
  }

  void _onControllerReady(BetterPlayerController controller) {
    if (!mounted) return;

    _betterPlayerController = controller;
    _betterPlayerController?.setVolume(_isMuted ? 0 : 1);

    // 安全地添加事件监听器
    _betterPlayerController?.addEventsListener(_handleVideoEvents);
  }

  // 安全的视频事件处理方法
  void _handleVideoEvents(BetterPlayerEvent event) {
    if (!mounted) return;

    // 使用 addPostFrameCallback 确保在安全的时机更新状态
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      try {
        setState(() {
          // Re-render to update progress bar visibility
        });
      } catch (e) {
        debugPrint('Error handling video events in item page: $e');
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
          ListTile(
            leading: Icon(_isMuted ? Icons.volume_off : Icons.volume_up),
            title: Text(_isMuted ? 'Unmute' : 'Mute'),
            onTap: () {
              _toggleMute();
              Navigator.of(context).pop();
            },
          ),
          ListTile(
              leading: const Icon(Icons.speed),
              title: const Text('Playback speed'),
              onTap: () {}),
          ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Save video'),
              onTap: () {}),
          ListTile(
              leading: const Icon(Icons.not_interested),
              title: const Text('Not interested'),
              onTap: () {}),
        ],
      ),
    );
  }

  void _showImageOptionsDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Wrap(
        children: [
          ListTile(
              leading: const Icon(Icons.save_alt),
              title: const Text('Save image'),
              onTap: () {}),
          ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share image'),
              onTap: () {}),
          ListTile(
              leading: const Icon(Icons.not_interested),
              title: const Text('Not interested'),
              onTap: () {}),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final pageIndex = int.parse(widget.media.id.split('_').last);
    final isPlaying = ref.watch(
        playbackControllerProvider.select((value) => value == pageIndex));


    return Listener(
      // 使用Listener优化事件处理
      behavior: HitTestBehavior.translucent,
      onPointerDown: (details) {
        // 预处理事件，判断是否需要传递给子组件
        _handlePointerEvent(details);
      },
      child: Stack(
        fit: StackFit.expand,
        children: [
          // --- Media Content with Optimized Gesture Detection ---
          _buildMediaContent(isPlaying),

          // --- Play/Pause Icon (conditionally displayed for video) ---
          if (widget.media.type == 'video' && _betterPlayerController != null)
            IgnorePointer(
              child: _buildPlayPauseIcon(_betterPlayerController!),
            ),

          // --- Double Tap Heart Animation ---
          if (_showHeartAnimation) _buildHeartAnimation(),

          // --- Overlay UI (Interactive elements on top) ---
          _buildOverlayUI(),
        ],
      ),
    );
  }

  void _handlePointerEvent(PointerDownEvent details) {
    // 检查是否在交互区域，如果是则让事件传递给交互组件
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(details.position);

    // 如果在交互区域，直接返回，让事件传递给子组件
    if (_isClickInInteractiveArea(localPosition)) {
      return;
    }

    // 非交互区域的事件会继续传递给底层的GestureDetector处理
  }

  bool _isClickInInteractiveArea(Offset position) {
    // 判断是否点击在交互区域（按钮、进度条等）
    final screenSize = MediaQuery.of(context).size;
    const double rightActionWidth = 100.0; // 右侧按钮区域宽度
    const double bottomAreaHeight = 180.0; // 底部区域高度，包含进度条和指示器

    return position.dx > screenSize.width - rightActionWidth ||
        position.dy > screenSize.height - bottomAreaHeight;
  }

  Widget _buildMediaContent(bool isPlaying) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // 媒体内容层
        if (widget.media.type == 'video')
          FeedMediaVideoPlayer(
            url: widget.media.url,
            coverUrl: widget.media.coverUrl,
            isActive: isPlaying,
            onControllerReady: _onControllerReady,
          )
        else if (widget.media.type == 'image' &&
            widget.media.imageUrls != null &&
            widget.media.imageUrls!.isNotEmpty)
          FeedMediaPhotoViewer(
            imageUrls: widget.media.imageUrls!,
            onPageChanged: (index) {
              if (_currentImageIndex != index) {
                setState(() {
                  _currentImageIndex = index;
                });
              }
            },
          )
        else
          FeedMediaPhotoViewer(
            imageUrls: [widget.media.url],
            onPageChanged: (index) {}, // 单张图片的空回调
          ),

        // 全屏手势检测层
        Positioned.fill(
          child: GestureDetector(
            onTap: () {
              // 全屏单击播放/暂停
              _togglePlayPause();
            },
            onDoubleTap: () {
              // 全屏双击点赞功能
              _handleDoubleTapLike();
            },
            onLongPress: () {
              // 全屏长按菜单
              if (widget.media.type == 'video') {
                _showVideoOptionsDialog();
              } else if (widget.media.type == 'image') {
                _showImageOptionsDialog();
              }
            },
            behavior: HitTestBehavior.translucent,
            child: Container(), // 透明容器，保证手势覆盖全屏
          ),
        ),
      ],
    );
  }

  void _handleDoubleTapLike() {
    if (!mounted) return;

    // 触发左侧按钮的点赞状态
    final leftActionsState = _leftActionsKey?.currentState;
    if (leftActionsState != null) {
      try {
        (leftActionsState as dynamic).triggerLike?.call();
      } catch (e) {
        debugPrint('Failed to trigger like: $e');
      }
    }

    // 播放双击动画效果
    if (mounted) {
      setState(() {
        _showHeartAnimation = true;
      });

      // 安全执行动画
      try {
        _doubleTapAnimationController.forward().then((_) {
          // 确保widget仍然mounted
          if (mounted) {
            // 使用 addPostFrameCallback 确保在安全的时机更新状态
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted) {
                setState(() {
                  _showHeartAnimation = false;
                });
                try {
                  _doubleTapAnimationController.reset();
                } catch (e) {
                  debugPrint('Error resetting animation: $e');
                }
              }
            });
          }
        }).catchError((e) {
          debugPrint('Error in double tap animation: $e');
        });
      } catch (e) {
        debugPrint('Error starting double tap animation: $e');
      }
    }

    // 添加触觉反馈
    try {
      HapticFeedback.lightImpact();
    } catch (e) {
      debugPrint('Error with haptic feedback: $e');
    }

    debugPrint('Double tap like - animation triggered');
  }

  Widget _buildOverlayUI() {
    return IgnorePointer(
      ignoring: false,
      child: Material(
        type: MaterialType.transparency,
        child: FeedMediaOverlayUI(
          media: widget.media,
          currentImageIndex: _currentImageIndex, // 传递图片指示器状态
          betterPlayerController: _betterPlayerController,
          leftActionsKey: _leftActionsKey,
        ),
      ),
    );
  }

  Widget _buildPlayPauseIcon(BetterPlayerController controller) {
    return AnimatedOpacity(
      opacity: (controller.isPlaying() ?? false) ||
              (controller.isBuffering() ?? false)
          ? 0.0
          : 1.0,
      duration: const Duration(milliseconds: 300),
      child: Center(
        child: Icon(
          (controller.isPlaying() ?? false)
              ? Icons.pause_circle_filled
              : Icons.play_circle_filled,
          color: Colors.white.withOpacity(0.7),
          size: 80,
        ),
      ),
    );
  }

  Widget _buildHeartAnimation() {
    return Positioned.fill(
      child: IgnorePointer(
        child: Center(
          child: ScaleTransition(
            scale: _heartScaleAnimation,
            child: FadeTransition(
              opacity: _heartOpacityAnimation,
              child: Icon(
                Icons.favorite,
                color: Colors.red.withOpacity(0.8),
                size: 100,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
