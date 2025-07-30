import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';

class FeedMediaProgressBar extends StatefulWidget {
  final BetterPlayerController controller;

  const FeedMediaProgressBar({super.key, required this.controller});

  @override
  State<FeedMediaProgressBar> createState() => _FeedMediaProgressBarState();
}

class _FeedMediaProgressBarState extends State<FeedMediaProgressBar> {
  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    widget.controller.addEventsListener(_onPlayerEvent);
  }

  void _onPlayerEvent(BetterPlayerEvent event) {
    if (mounted) {
      setState(() {
        if (event.betterPlayerEventType == BetterPlayerEventType.progress) {
          _currentPosition = event.parameters!['progress'] as Duration;
          _totalDuration = event.parameters!['duration'] as Duration;
        }
      });
    }
  }

  @override
  void dispose() {
    try {
      widget.controller.removeEventsListener(_onPlayerEvent);
    } catch (e) {
      debugPrint('Error removing progress bar event listener: $e');
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = _totalDuration.inMilliseconds > 0
        ? _currentPosition.inMilliseconds / _totalDuration.inMilliseconds
        : 0.0;

    return SizedBox(
      height: 20.0,
      child: SliderTheme(
        data: SliderTheme.of(context).copyWith(
          trackHeight: 3.0,
          thumbShape:
              const RoundSliderThumbShape(enabledThumbRadius: 0.0), // 移除小圆球
          overlayShape:
              const RoundSliderOverlayShape(overlayRadius: 0.0), // 移除外圈
          activeTrackColor: Colors.white, // 修改为白色进度
          inactiveTrackColor: Colors.white.withOpacity(0.3), // 降低背景透明度
          thumbColor: Colors.transparent, // 透明拖拽点
          overlayColor: Colors.transparent,
        ),
        child: IgnorePointer(
          // 忽略所有手势，纯展示用
          child: Slider(
            value: progress.clamp(0.0, 1.0),
            onChanged: null, // 禁用交互
          ),
        ),
      ),
    );
  }
}
