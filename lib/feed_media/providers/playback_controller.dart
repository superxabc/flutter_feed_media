import 'package:flutter_riverpod/flutter_riverpod.dart';

final playbackControllerProvider = StateNotifierProvider<PlaybackController, int>((ref) {
  return PlaybackController();
});

class PlaybackController extends StateNotifier<int> {
  PlaybackController() : super(0);

  void setCurrentIndex(int index) {
    state = index;
  }
}
