# 📱 Flutter FeedMedia 

一个高性能的 Flutter 媒体内容展示库，支持沉浸式短视频/图片流媒体和瀑布流信息展示，提供流畅的用户交互和高性能体验。

## ✨ 核心特性

### 🎥 沉浸式媒体流 (FeedMediaPageView)
- **视频播放控制**：自动播放/暂停，全屏点击播放/暂停，暂停时显示播放/暂停图标
- **图片浏览**：支持单图/多图左右滑动切换，带动画指示器
- **长按功能菜单**：视频和图片的专属功能菜单
- **音量控制**：静音切换按钮和音频播放指示器

### 🎯 瀑布流信息展示 (FeedWaterView)
- **多列布局**：支持自定义列数，实现多列内容展示。
- **动态高度**：每个瀑布流项的高度根据内容自适应，无需固定高度。
- **无限滚动**：内置加载更多机制，支持自动加载下一页数据。
- **广告支持**：能够识别并展示广告类型的卡片，支持差异化样式。
- **灵活卡片**：支持自定义卡片内容，可展示图片、视频缩略图、文本等多种信息。
- **间距控制**：支持自定义瀑布流项之间的水平和垂直间距。

### 🤝 通用用户交互功能
- **完整的社交互动**：
  - 用户头像点击（导航到用户主页）
  - 关注按钮交互（状态切换 + 动画效果）
  - 点赞功能（动画反馈 + 计数显示 + 状态管理）
  - 评论/分享按钮响应
- **智能事件处理**：精确的点击区域检测，避免误触播放/暂停
- **优化的触摸响应**：事件响应延迟 < 16ms

### 🚀 性能优化
- **智能事件分发机制**：解决按钮点击冲突问题
- **高效状态管理**：基于 Riverpod 的状态管理
- **流畅的滑动体验**：上下滑动切换，懒加载分页
- **资源管理**：视频播放器资源释放和重建逻辑

### 🎨 布局优化
- **底部布局优化**：进度条和指示器位于组件最底部
- **视觉层次清晰**：优化的 UI 层级和交互反馈
- **响应式设计**：适配不同屏幕尺寸

## 📦 安装

在 `pubspec.yaml` 中添加依赖：
 
 ```yaml
dependencies:
   flutter_feed_media:
    path: ../flutter_feed_media  # 本地路径依赖
  flutter_riverpod: ^2.6.1     # 状态管理依赖
  flutter_staggered_grid_view: ^0.7.0 # 瀑布流布局依赖
 ```
 
## 🚀 快速开始

### 沉浸式媒体流 (FeedMediaPageView) 基础用法
 
 ```dart
 import 'package:flutter/material.dart';
 import 'package:flutter_riverpod/flutter_riverpod.dart';
 import 'package:flutter_feed_media/flutter_feed_media.dart';
 
 void main() {
   runApp(const ProviderScope(child: MyApp()));
 }
 
 class MyApp extends StatelessWidget {
   const MyApp({super.key});
 
   @override
   Widget build(BuildContext context) {
     return MaterialApp(
       home: Scaffold(
         backgroundColor: Colors.black,
         body: const FeedMediaPageView(),
       ),
     );
   }
 }
 ```

### 瀑布流信息展示 (FeedWaterView) 基础用法

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_feed_media/flutter_feed_media.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('瀑布流示例')),
        body: const FeedWaterView(),
      ),
    );
  }
}
```

### 完整示例

查看完整的使用示例，请运行统一示例工程：

```bash
cd ../nummate_app
flutter run
```

在 Nummate App 中选择 "Feed Media 组件" 或 "Feed Water View 组件" 即可体验完整功能。

## 场景选择指南

*   **使用 `FeedMediaPageView`**: 当你需要为用户提供高度沉浸式、全屏的视频或图片浏览体验时，例如短视频应用的主页、故事流等。
*   **使用 `FeedWaterView`**: 当你需要展示大量异构内容，并希望用户能够快速浏览和发现信息时，例如电商商品列表、资讯流、图片社区的“发现”页面等。

## 📝 更新日志 (Changelog)

### V1.1 - 交互与架构核心重构
此版本为一次重大的迭代，包含了对用户交互和核心组件架构的全面优化。

- **新增瀑布流信息展示 (FeedWaterView)**: 引入全新的瀑布流布局组件，支持多列、动态高度、无限滚动、广告支持及灵活卡片定制，适用于内容发现和浏览场景。
- **完整的用户交互**: `FeedMediaLeftActions` 组件被重构为功能完备的 StatefulWidget，并新增了双击点赞功能。
- **智能事件分发**: 引入 `Listener` 组件，完美解决了UI按钮点击与全屏手势之间的事件冲突。
- **进度条架构简化**: `VideoOverlayController` 被最终简化为一个极简的、无动画的双状态（播放/暂停）控制器，移除了所有冗余的拖拽模式和逻辑.

### V1.0 - MVP 版本
- 实现了上下滑动切换、视频/图片播放、懒加载、基础UI布局等核心功能。


## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进这个项目。

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件。