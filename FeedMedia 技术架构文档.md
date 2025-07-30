# FeedMedia 技术架构文档 (V2.0)

## 一、 架构设计原则

本组件的架构遵循以下核心原则，以确保其长期健壮、可维护和可扩展：

1.  **单一职责原则 (SRP)**: 每个组件或类只负责一项明确的功能。例如，`VideoOverlayController` 仅负责进度条的UI与交互，而数据获取则完全委托给 `FeedMediaRepository`。

2.  **依赖倒置原则 (DIP)**: 高层模块不依赖于低层模块的具体实现，而是依赖于抽象。我们通过 `Riverpod` 的 `Provider` 机制实现这一点，例如，UI层依赖的是 `feedMediaProvider` 这个抽象，而非其具体的 `FeedMediaNotifier` 实现。这为未来的单元测试和功能替换（如更换播放器）奠定了基础。

3.  **分层架构 (Layered Architecture)**: 组件严格划分为三个层次，各层之间单向依赖，确保数据流清晰可控。

## 二、分层架构详解

```mermaid
graph TD
    subgraph 表现层 (UI Layer)
        A(FeedMediaPageView)
        B(FeedMediaItemPage)
        C(FeedMediaOverlayUI)
    end

    subgraph 状态逻辑层 (State & Logic Layer)
        D(feedMediaProvider)
        E(playbackControllerProvider)
    end

    subgraph 数据层 (Data Layer)
        F(FeedMediaRepository)
    end

    A --> D
    A --> E
    B --> E
    C --> E
    D --> F
```

-   **1. 表现层 (UI Layer)**: 负责UI的渲染和用户事件的捕获。此层是“被动”的，它通过监听状态层的变化来更新视图，并将用户交互事件传递给状态逻辑层进行处理。核心组件包括 `FeedMediaPageView`, `FeedMediaItemPage` 等。

-   **2. 状态逻辑层 (State & Logic Layer)**: 负责处理所有业务逻辑和状态管理。它接收来自表现层的用户事件，执行相应的操作（如请求数据、更新状态），并驱动表现层刷新。此层是整个组件的大脑，核心是 `Riverpod` 的各个 `Notifier`。

-   **3. 数据层 (Data Layer)**: 负责数据的获取和持久化。通过 `Repository` 模式将数据来源（网络API、本地数据库、模拟数据）与上层完全隔离。状态逻辑层只与 `FeedMediaRepository` 这个统一的入口交互，不关心数据究竟从何而来。

## 三、核心组件的架构定位

-   **`FeedMediaPageView`**: **[UI层]** 顶层容器与页面状态的订阅者。
-   **`FeedMediaItemPage`**: **[UI层]** 核心协调器，负责组合媒体播放器和浮层UI，并向上层（状态逻辑层）派发手势事件。
-   **`VideoOverlayController`**: **[UI层]** 一个高度自治的、封装良好的UI子组件，内部管理自身的状态（播放/暂停），不包含任何业务逻辑。
-   **`feedMediaProvider`**: **[状态逻辑层]** 媒体流数据的状态管理器，负责分页加载、数据缓存等核心业务逻辑。
-   **`playbackControllerProvider`**: **[状态逻辑层]** 全局播放控制器，确保在任何时候只有一个视频在播放。
-   **`FeedMediaRepository`**: **[数据层]** 数据源的唯一入口，为状态逻辑层提供统一、干净的数据接口。

## 四、未来技术架构演进路线

为了支撑更复杂的功能并持续优化非功能性需求（性能、稳定性、可测试性），我们规划了以下技术演进路线：

### 阶段一：核心抽象与解耦
- **目标**: 将核心依赖（如播放器、数据源）接口化，实现真正的“可插拔”。
- **任务**:
  1.  **播放器API抽象**: 定义一个 `IFeedPlayer` 接口，包含 `play()`, `pause()`, `seekTo()`, `getStream()` 等方法。当前的 `BetterPlayer` 将作为该接口的一个实现。这将使未来替换或新增播放器（如 `ijkplayer`）变得轻而易举。
  2.  **数据源接口化**: 将 `FeedMediaRepository` 提升为 `IFeedMediaRepository` 接口，使其可以有不同的实现，如 `ApiRepository`, `MockRepository`, `CachedRepository`，极大提升可测试性。

### 阶段二：高性能与可观测性
- **目标**: 追求极致的性能，并建立完善的可观测性体系。
- **任务**:
  1.  **高级缓存策略**: 引入专门的 `CacheManager`，实现更精细的视频预加载和淘汰策略（如 LRU 算法），而不仅仅是依赖播放器自带的缓存。
  2.  **性能监控 SDK**: 设计一个轻量级的性能监控服务 (`PerformanceMonitor`)，在播放链路的关键节点（如首帧渲染、播放卡顿）进行数据埋点和上报。
  3.  **渲染优化**: 探索对关键动画（如点赞动画）使用 `CustomPainter` 进行绘制，以减少 Widget 重建，获得更优的性能。

### 阶段三：自动化与质量保障
- **目标**: 建立完善的自动化测试体系，保障代码质量和迭代速度。
- **任务**:
  1.  **完善单元测试**: 确保所有 `Notifier` 和 `Repository` 的逻辑覆盖率达到90%以上。
  2.  **引入集成测试**: 针对核心用户流程（如“滑动-播放-暂停-拖拽-点赞”）编写端到端的集成测试，防止出现功能回归。
  3.  **建立CI/CD流水线**: 接入 `GitHub Actions` 或 `Jenkins`，实现自动化测试、代码分析、打包和发布流程。