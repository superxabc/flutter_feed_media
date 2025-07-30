import 'package:flutter/material.dart';

class AudioIndicator extends StatefulWidget {
  const AudioIndicator({super.key});

  @override
  State<AudioIndicator> createState() => _AudioIndicatorState();
}

class _AudioIndicatorState extends State<AudioIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 5),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _controller,
      child: GestureDetector(
        onTap: () {
          // TODO: Implement navigation to audio/music details page
        },
        child: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.5),
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: const Icon(Icons.music_note, color: Colors.white, size: 30),
        ),
      ),
    );
  }
}
