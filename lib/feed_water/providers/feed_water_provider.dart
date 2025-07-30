// feed_water_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/feed_water_repository.dart';
import '../models/feed_water_model.dart';

class FeedWaterState {
  final List<FeedWaterItemModel> items;
  final int page;
  final bool isLoading;
  final bool hasMore;
  final String? error;

  FeedWaterState({
    this.items = const [],
    this.page = 0,
    this.isLoading = false,
    this.hasMore = true,
    this.error,
  });

  FeedWaterState copyWith({
    List<FeedWaterItemModel>? items,
    int? page,
    bool? isLoading,
    bool? hasMore,
    String? error,
  }) {
    return FeedWaterState(
      items: items ?? this.items,
      page: page ?? this.page,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      error: error ?? this.error,
    );
  }
}

class FeedWaterNotifier extends StateNotifier<FeedWaterState> {
  final FeedWaterRepository _repository;

  FeedWaterNotifier(this._repository) : super(FeedWaterState()) {
    loadMoreData();
  }

  Future<void> loadMoreData() async {
    if (state.isLoading || !state.hasMore) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final newItems = await _repository.fetchWaterFlowData(state.page);
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

final feedWaterRepositoryProvider = Provider((ref) => FeedWaterRepository());

final feedWaterProvider =
    StateNotifierProvider<FeedWaterNotifier, FeedWaterState>((ref) {
  return FeedWaterNotifier(ref.watch(feedWaterRepositoryProvider));
});
