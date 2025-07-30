import 'package:flutter/material.dart';
import 'package:flutter_feed_media/feed_media/models/feed_media_model.dart';

class FeedMediaBottomInfo extends StatelessWidget {
  final FeedMediaModel media;

  const FeedMediaBottomInfo({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          media.title,
          style: const TextStyle(
              color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Text(
          media.description,
          style: const TextStyle(color: Colors.white, fontSize: 14),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: media.topics
              .map(
                (topic) => GestureDetector(
                  onTap: () {
                    // TODO: Implement navigation to topic page
                  },
                  child: Text(
                    topic,
                    style: const TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )
              .toList(),
        ),
        // TODO: Add RelatedContentArea here
      ],
    );
  }
}
