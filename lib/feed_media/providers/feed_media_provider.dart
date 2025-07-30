import 'package:flutter_feed_media/feed_media/data/feed_media_repository.dart';
import 'package:flutter_feed_media/feed_media/models/feed_media_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// 1. 定义状态
class FeedMediaState {
  final List<FeedMediaModel> items;
  final int page;
  final bool isLoading;
  final bool hasMore;
  final String? error;

  FeedMediaState({
    this.items = const [],
    this.page = 0,
    this.isLoading = false,
    this.hasMore = true,
    this.error,
  });

  FeedMediaState copyWith({
    List<FeedMediaModel>? items,
    int? page,
    bool? isLoading,
    bool? hasMore,
    String? error,
  }) {
    return FeedMediaState(
      items: items ?? this.items,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
    );
  }
}

// 2. 创建 StateNotifier
class FeedMediaNotifier extends StateNotifier<FeedMediaState> {
  final FeedMediaRepository _repository;

  FeedMediaNotifier(this._repository) : super(FeedMediaState()) {
    loadMedia();
  }

  Future<void> loadMedia() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final newItems = await _repository.fetchMedia(state.page);
      if (newItems.isEmpty) {
        state = state.copyWith(hasMore: false, isLoading: false);
      } else {
        state = state.copyWith(
          items: [...state.items, ...newItems],
          page: state.page + 1,
          isLoading: false,
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}

final feedMediaProvider =
    StateNotifierProvider<FeedMediaNotifier, FeedMediaState>((ref) {
  return FeedMediaNotifier(ref.watch(feedMediaRepositoryProvider));
});

// Repository Provider
final feedMediaRepositoryProvider = Provider((ref) => FeedMediaRepository());
