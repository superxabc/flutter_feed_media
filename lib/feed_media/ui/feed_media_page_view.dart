import 'package:flutter/material.dart';
import 'package:flutter_feed_media/feed_media/providers/feed_media_provider.dart';
import 'package:flutter_feed_media/feed_media/providers/playback_controller.dart';
import 'package:flutter_feed_media/feed_media/ui/feed_media_item_page.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class FeedMediaPageView extends ConsumerWidget {
  const FeedMediaPageView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final feedState = ref.watch(feedMediaProvider);
    final playbackController = ref.watch(playbackControllerProvider.notifier);
    final pageController = PageController();

    pageController.addListener(() {
      if (pageController.page == feedState.items.length - 1) {
        ref.read(feedMediaProvider.notifier).loadMedia();
      }
    });

    if (feedState.items.isEmpty && feedState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (feedState.error != null && feedState.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('Failed to load media'),
            ElevatedButton(
              onPressed: () => ref.read(feedMediaProvider.notifier).loadMedia(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    return PageView.builder(
      controller: pageController,
      scrollDirection: Axis.vertical,
      itemCount: feedState.items.length,
      onPageChanged: (index) {
        playbackController.setCurrentIndex(index);
      },
      itemBuilder: (context, index) {
        final item = feedState.items[index];
        return FeedMediaItemPage(media: item);
      },
    );
  }
}