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
  bool _isDragging = false; // New state variable
  double _dragValue = 0.0; // Store value during drag

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
    widget.controller.removeEventsListener(_onPlayerEvent);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double progress = _totalDuration.inMilliseconds > 0 ? _currentPosition.inMilliseconds / _totalDuration.inMilliseconds : 0.0;

    return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: _isDragging ? 4.0 : 2.0, // Dynamic track height
        thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6.0),
        overlayShape: const RoundSliderOverlayShape(overlayRadius: 12.0),
        activeTrackColor: Colors.red,
        inactiveTrackColor: Colors.white.withOpacity(0.5),
        thumbColor: Colors.red,
      ),
      child: Slider(
        value: _isDragging ? _dragValue : progress, // Use dragValue during drag
        onChanged: (value) {
          setState(() {
            _isDragging = true;
            _dragValue = value;
          });
        },
        onChangeEnd: (value) {
          final seekTo = _totalDuration * value;
          widget.controller.seekTo(seekTo);
          setState(() {
            _isDragging = false;
          });
        },
      ),
    );
  }
}
