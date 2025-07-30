# 📱 Flutter FeedMedia 

一个高性能的 Flutter 短视频/图片流媒体组件，支持上下滑动切换、用户交互和流畅的播放体验。

## ✨ 核心特性

### 🎥 媒体播放功能
- **视频播放控制**：自动播放/暂停，全屏点击播放/暂停，暂停时显示播放/暂停图标
- **图片浏览**：支持单图/多图左右滑动切换，带动画指示器
- **长按功能菜单**：视频和图片的专属功能菜单
- **音量控制**：静音切换按钮和音频播放指示器

### 🎯 用户交互功能
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
 ```
 
## 🚀 快速开始

### 基础用法
 
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

### 完整示例

查看完整的使用示例，请运行统一示例工程：

```bash
cd ../nummate_app
flutter run
```

在 Nummate App 中选择 "Feed Media 组件" 即可体验完整功能。

## 📝 更新日志 (Changelog)

### V1.1 - 交互与架构核心重构
此版本为一次重大的迭代，包含了对用户交互和核心组件架构的全面优化。

- **完整的用户交互**: `FeedMediaLeftActions` 组件被重构为功能完备的 StatefulWidget，并新增了双击点赞功能。
- **智能事件分发**: 引入 `Listener` 组件，完美解决了UI按钮点击与全屏手势之间的事件冲突。
- **进度条架构简化**: `VideoOverlayController` 被最终简化为一个极简的、无动画的双状态（播放/暂停）控制器，移除了所有冗余的拖拽模式和逻辑。

### V1.0 - MVP 版本
- 实现了上下滑动切换、视频/图片播放、懒加载、基础UI布局等核心功能。


## 🤝 贡献

欢迎提交 Issue 和 Pull Request 来改进这个项目。

## 📄 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件。