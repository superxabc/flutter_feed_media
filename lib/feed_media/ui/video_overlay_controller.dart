import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

// 状态枚举简化，只保留 hidden 和 display
enum VideoProgressState {
  hidden, // 播放状态
  display, // 暂停状态
}

enum VideoGestureState {
  normal, // 正常状态
  seeking, // 拖拽寻址状态
}

/// VideoOverlayController - 一个统一、简化的视频进度条组件
class VideoOverlayController extends StatefulWidget {
  final BetterPlayerController controller;
  final Function(Duration)? onSeekTo;
  final VoidCallback? onPlayResume;

  const VideoOverlayController({
    super.key,
    required this.controller,
    this.onSeekTo,
    this.onPlayResume,
  });

  @override
  State<VideoOverlayController> createState() => _VideoOverlayControllerState();
}

// 移除了 SingleTickerProviderStateMixin，因为不再需要动画
class _VideoOverlayControllerState extends State<VideoOverlayController> {
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;
  double _dragValue = 0.0;

  VideoProgressState _progressState = VideoProgressState.hidden;
  VideoGestureState _gestureState = VideoGestureState.normal;

  // 移除了 AnimationController 和 Animation
  bool _lastIsPlaying = true;

  @override
  void initState() {
    super.initState();
    widget.controller.addEventsListener(_onPlayerEvent);
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkPlayerState();
    });
  }

  @override
  void dispose() {
    try {
      widget.controller.removeEventsListener(_onPlayerEvent);
    } catch (e) {
      debugPrint('Error removing video overlay event listener: $e');
    }
    super.dispose();
  }

  void _onPlayerEvent(BetterPlayerEvent event) {
    if (!mounted) return;

    try {
      if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
        final progress = event.parameters?['progress'] as Duration?;
        final duration = event.parameters?['duration'] as Duration?;

        if (progress != null && duration != null && mounted) {
          SchedulerBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              setState(() {
                _currentPosition = progress;
                _totalDuration = duration;

                if (_gestureState != VideoGestureState.seeking) {
                  _dragValue = _totalDuration.inMilliseconds > 0
                      ? _currentPosition.inMilliseconds /
                          _totalDuration.inMilliseconds
                      : 0.0;
                }
              });
              _checkPlayerState();
            }
          });
        }
      } else if (event.betterPlayerEventType == BetterPlayerEventType.play) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (mounted) _checkPlayerState();
        });
      } else if (event.betterPlayerEventType == BetterPlayerEventType.pause) {
        SchedulerBinding.instance.addPostFrameCallback((_) {
          if (mounted) _checkPlayerState();
        });
      }
    } catch (e) {
      debugPrint('Error in player event handler: $e');
    }
  }

  void _checkPlayerState() {
    if (!mounted) return;

    final isPlaying = widget.controller.isPlaying() ?? false;
    
    if (_lastIsPlaying != isPlaying) {
      _lastIsPlaying = isPlaying;
      
      final newState = isPlaying ? VideoProgressState.hidden : VideoProgressState.display;
      
      if (_progressState != newState && _gestureState != VideoGestureState.seeking) {
        _updateProgressState(newState);
      }
    }
  }

  void _updateProgressState(VideoProgressState newState) {
    if (_progressState == newState || !mounted) return;

    // 直接更新状态，不再有动画控制器
    setState(() {
      _progressState = newState;
    });
  }

  Widget _buildPauseProgressBar() {
    return SizedBox(
      width: double.infinity,
      height: 20.0,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 3.0,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8.0),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 16.0),
          activeTrackColor: Colors.white,
          inactiveTrackColor: Colors.white.withOpacity(0.3),
          thumbColor: Colors.white,
          overlayColor: Colors.white.withOpacity(0.3),
        ),
        child: Slider(
          value: _dragValue.clamp(0.0, 1.0),
          onChanged: (value) {
            setState(() {
              _dragValue = value;
              _gestureState = VideoGestureState.seeking;
            });
            
            final seekTo = _totalDuration * value;
            widget.controller.seekTo(seekTo);
            widget.onSeekTo?.call(seekTo);
          },
          onChangeEnd: (value) {
            final seekTo = _totalDuration * value;
            widget.controller.seekTo(seekTo);
            widget.onSeekTo?.call(seekTo);
            
            setState(() {
              _gestureState = VideoGestureState.normal;
            });
            
            widget.controller.play();
            widget.onPlayResume?.call();
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // 整体布局保持不变，但内部渲染逻辑已简化
    return Positioned(
      left: 16.0,
      right: 16.0,
      bottom: 8.0,
      child: _buildProgressBarContent(),
    );
  }

  Widget _buildProgressBarContent() {
    // 根据状态直接返回对应的 Widget，不再需要 FadeTransition
    if (_progressState == VideoProgressState.hidden) {
      return SizedBox(
        width: double.infinity,
        height: 20.0,
        child: SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 3.0,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0.0),
            overlayShape: const RoundSliderOverlayShape(overlayRadius: 0.0),
            activeTrackColor: Colors.white,
            inactiveTrackColor: Colors.white.withOpacity(0.3),
            thumbColor: Colors.transparent,
            overlayColor: Colors.transparent,
          ),
          child: IgnorePointer(
            child: Slider(
              value: _dragValue.clamp(0.0, 1.0),
              onChanged: null,
            ),
          ),
        ),
      );
    } else { // This is the 'display' state
      return _buildPauseProgressBar();
    }
  }
}



