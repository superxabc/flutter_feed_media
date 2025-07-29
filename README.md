# Flutter FeedMedia Component

A highly immersive and scrollable media stream (video/image) component built with Flutter, similar to popular content platforms.

## Features

- Seamless vertical scrolling of video and image content.
- Auto-play video when visible, auto-pause when scrolled out, with explicit resource management.
- Supports mixed streams of video and images, with multi-image horizontal swiping.
- Lazy loading for pagination and data fetching.
- Interactive placeholders for like, comment, and share functionalities.
- Robust error handling for network and loading failures.
- Customizable UI with bottom information (title, description, topics), left-side action bar, audio indicator, and a custom progress bar.
- Single tap to play/pause, long press for options menu.

## Installation

Add this to your `pubspec.yaml`:

```yaml
dependencies:
  flutter_feed_media:
    git:
      url: https://github.com/superxabc/flutter_feed_media.git
      ref: main # Or a specific commit/tag
```

## Usage

```dart
import 'package:flutter/material.dart';
import 'package:flutter_feed_media/flutter_feed_media.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Feed Media Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        body: FeedMediaPageView(),
      ),
    );
  }
}
```

## Project Structure

```
lib/
├── feed_media.dart             (Main entry point, exports the component)
└── feed_media/                 (Root directory for the FeedMedia component)
    ├── models/                 (Data models, e.g., feed_media_model.dart)
    ├── data/                   (Data layer, e.g., feed_media_repository.dart)
    ├── providers/              (State management and business logic, e.g., feed_media_provider.dart, playback_controller.dart)
    └── ui/                     (All UI-related pages and widgets)
```

## Contributing

Contributions are welcome! Please feel free to open an issue or submit a pull request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.