# Flutter FeedMedia 组件

这是一个高度沉浸式、可滚动的媒体流（视频/图片）组件，使用 Flutter 构建，旨在模拟主流内容平台（如抖音、TikTok）的沉浸式体验。它优先考虑流畅的用户体验、高效的资源管理和可扩展性。

## ✨ 功能特性

-   **无缝滚动内容流**: 支持视频和图片内容的流畅垂直滚动切换。
-   **智能视频播放**: 
    -   当视频进入可视区域时自动播放，滑出时自动暂停。
    -   精确的播放器资源释放与重建管理，优化内存使用。
    -   单击视频区域可切换播放/暂停状态。
    -   长按视频区域可弹出功能菜单，提供倍速、保存、不感兴趣等选项。
-   **灵活的图片展示**: 
    -   支持视频与图片混合流展示。
    -   对于包含多张图片的媒体内容，支持左右滑动切换图片。
    -   **重要提示**: 图片展示不提供手势放大缩小功能，以保持与短视频应用一致的沉浸式体验。
-   **高效懒加载**: 滑动到内容流末尾时自动触发分页加载新数据，确保流畅的用户体验。
-   **丰富的交互UI**: 
    -   预留了点赞、评论、分享等互动功能的UI占位符。
    -   底部区域展示视频标题、详细描述以及可点击的相关话题。
    -   左下角提供音频播放状态指示器（通常为旋转的胶片图片），点击可查看相关音频/音乐详情。
    -   自定义的底部进度条，在视频暂停时常驻显示，方便用户拖动调整进度；播放时则自动隐藏。
-   **健壮的错误处理**: 优雅地处理网络请求失败和媒体加载失败的情况，提供友好的提示和重试机制。

## 🚀 安装指南

将以下依赖添加到您的 `pubspec.yaml` 文件中：

```yaml
dependencies:
  flutter_feed_media:
    git:
      url: https://github.com/superxabc/flutter_feed_media.git
      ref: main # 或者指定一个具体的 commit hash 或 tag
```

运行 `flutter pub get` 获取依赖。

## 📖 使用示例

在您的 Flutter 应用中，您可以像这样使用 `FeedMediaPageView` 组件：

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
      title: 'Flutter Feed Media 示例',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Scaffold(
        // FeedMediaPageView 会自动从其内部的 FeedMediaRepository 获取数据
        body: FeedMediaPageView(),
      ),
    );
  }
}
```

**注意**: 示例应用 (`example/`) 可能会遇到 Android 构建问题，这通常与 `better_player` 插件的 Gradle 兼容性有关。此问题并非组件库本身的代码问题，而是第三方依赖的构建环境问题。目前建议在 iOS 或桌面平台运行示例，或等待 `better_player` 插件更新以解决此兼容性问题。

## 📂 项目结构

```
lib/
├── feed_media.dart             (组件库主入口文件，负责导出核心组件)
└── feed_media/                 (FeedMedia 组件的核心代码目录)
    ├── models/                 (数据模型定义，例如：feed_media_model.dart)
    ├── data/                   (数据层实现，例如：feed_media_repository.dart，负责数据获取和管理)
    ├── providers/              (状态管理和业务逻辑，例如：feed_media_provider.dart, playback_controller.dart)
    └── ui/                     (所有UI相关的页面和Widget，例如：feed_media_page_view.dart, feed_media_item_page.dart, feed_media_photo_viewer.dart 等)
```

## 🤝 贡献

欢迎任何形式的贡献！如果您有任何问题、功能建议或发现 Bug，请随时提交 Issue 或 Pull Request。在提交 Pull Request 之前，请确保您的代码符合项目的编码规范。

## 📄 许可证

本项目采用 MIT 许可证 - 详情请参阅 [LICENSE](LICENSE) 文件。
