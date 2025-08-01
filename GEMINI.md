# GEMINI.md - Flutter FeedMedia 工程指导文档

## 1. 项目概述

本文档旨在为 Flutter FeedMedia 项目的开发和维护提供高级别的工程指导，概述了项目的核心功能、技术架构和关键约定。

## 2. 快速上手 (Getting Started)

### 2.1 环境要求
- Flutter SDK: 版本 >= 3.5.4
- Dart SDK: 版本 >= 3.0.0

### 2.2 安装与运行
1.  **获取依赖**: 在项目根目录下运行，以安装所有必需的依赖包。
    ```bash
    flutter pub get
    ```
2.  **运行示例**: 本组件的完整功能示例已集成在 `nummate_app` 项目中。请切换到该目录并运行。
    ```bash
    cd ../nummate_app
    flutter run
    ```

## 3. 核心功能

-   **混合媒体流**: 支持视频和图片内容的无缝垂直滚动。
-   **智能视频播放**: 可见时自动播放，滑出时自动暂停。全屏单击可切换播放/暂停状态，双击可点赞，长按可弹出功能菜单。
-   **图片浏览**: 支持多图左右滑动，并带有动画指示器。
-   **进度条**: 播放时显示细线进度，暂停时显示可拖拽的圆球，交互简洁直观。
-   **完整的用户交互**: 提供带动画和状态管理的关注、点赞等社交按钮。
-   **健壮性**: 优雅地处理网络和加载错误，并通过优化的事件处理机制解决手势冲突。

## 4. 架构原则与分层

1.  **分层架构 (Layered Architecture)**: 组件严格划分为**表现层 (UI)**、**状态逻辑层 (State & Logic)** 和 **数据层 (Data)**。各层单向依赖，确保逻辑清晰、易于维护。
2.  **单一职责 (SRP)**: 每个组件或类只负责一项明确的功能。例如，UI组件只负责渲染和事件派发，业务逻辑完全由状态逻辑层的 `Notifier` 处理。
3.  **依赖倒置 (DIP)**: 通过 `Riverpod` 实现依赖注入，高层模块依赖于抽象（`Provider`）而非具体实现，这使得组件高度可测试和可扩展。

## 5. 技术栈与约定

| 模块           | 核心技术/库                               | 说明                                                              |
| :--------------- | :----------------------------------------------- | :----------------------------------------------------------------- |
| 视频播放       | `better_player`                                  | 提供基础播放能力，UI完全自定义。 |
| 图片显示       | `carousel_slider` + `dots_indicator`             | 实现多图滑动和动画指示器。 |
| 状态管理       | `Riverpod`                                       | 作为分层架构的核心，负责状态管理和依赖注入。                     |
| 进度条交互     | Flutter `Slider`                                 | 利用原生 `Slider` 的回调实现流畅、可靠的拖拽体验。 |

## 6. 编码与维护

*   **代码风格**: 严格遵循 `analysis_options.yaml` 中定义的 `flutter_lints` 规则集。
*   **文档同步**: 在进行任何重构或重要功能变更后，必须同步更新所有相关的产品和技术文档。
*   **Git 提交规范**: 在执行 `git commit` 前，**必须**遵循以下审查流程：
    1.  运行 `git status` 确认所有待提交文件已被正确暂存 (`git add`)。
    2.  运行 `git diff HEAD` 审查所有代码改动的最终内容。
    3.  **提交信息 (Commit Message)**: 
        *   **简洁明了**: 提交信息应高度概括本次提交的核心内容，避免冗长。
        *   **精确描述功能**: 对于功能性改动，应精确指出增强或修改了哪个功能（例如，“增强用户社交交互”）。
        *   **统一文档概括**: 对于文档相关的改动，统一使用“更新文档”进行概括，无需列举具体修改了哪些文档。

## 7. 质量保障与测试策略

1.  **静态代码分析 (第一道防线)**: 在**每次**代码修改任务（如新增、修改、删除文件）完成后，**必须**立即运行 `flutter analyze` 命令，并解决所有报告的错误或警告。这确保了代码始终符合项目定义的规范，并能及早发现潜在问题。

2.  **单元测试 (Unit Test)**: **必须** 覆盖所有状态逻辑层 (`Notifier`) 和数据层 (`Repository`) 的公共方法，目标覆盖率 > 90%。在测试中 **必须** 使用 Mocking 框架（如 `Mockito`）来模拟依赖项。

3.  **组件测试 (Widget Test)**: **必须** 为包含复杂交互或多状态UI的组件（如 `FeedMediaLeftActions`, `VideoOverlayController`）编写测试，验证其行为和渲染的正确性。

4.  **集成测试 (Integration Test)**: **鼓励** 为核心用户流程（如“滑动-播放-暂停-拖拽-点赞”）编写集成测试，以防止功能回归。

## 8. 未来技术演进

-   **核心抽象**: 将播放器、数据源等核心依赖接口化（`IFeedPlayer`, `IFeedMediaRepository`），实现“可插拔”架构。
-   **性能与可观测性**: 引入独立的 `CacheManager` 和轻量级的 `PerformanceMonitor` SDK，追求极致性能并建立可观测性体系。
-   **自动化**: 建立覆盖单元测试、集成测试的自动化CI/CD流水线。

## 9. 调试指南与常见问题 (FAQ)

-   **Q: 视频出现黑屏或加载失败？**
    -   **A:** 首先检查设备网络连接和应用的网络权限。其次，确认视频URL可访问且格式受 `better_player` 支持。最后，通过播放器的事件监听器捕获 `exception` 事件，查看详细的错误日志。

-   **Q: 点击按钮时，触发了视频的播放/暂停？**
    -   **A:** 这是典型的事件冲突。检查 `FeedMediaItemPage` 中的 `Listener` 组件，确认其 `_isClickInInteractiveArea` 方法是否正确计算了所有可交互UI（如按钮、进度条）的区域。确保事件被正确地分发或消费。