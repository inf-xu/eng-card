# eng_card V1 产品与工程方案

## 摘要
- `eng_card / 英格卡` 首版定位为中文界面的纯本地离线 Flutter App，目标平台为 Android 和 iOS；不做登录、云同步、导入导出。
- 采用 `feature-first` 分层：`app shell`、`decks`、`study`、`stats`、`settings`、`data/local`；业务状态与 UI 分离，所有卡片数据和学习记录落本地库。
- 技术基线确定为 `flutter_riverpod` 管状态、`go_router` 管路由、`drift + drift_flutter` 管结构化本地数据、`shared_preferences` 仅存简单设置、`fl_chart` 画趋势图、`table_calendar` 做学习日历。

## 关键实现
- 底部导航固定 3 个 Tab：`首页 / 统计 / 设置`。路由使用 `go_router` 的 Shell 结构保留 Tab 状态；额外页面为 `卡片组管理`、`卡片列表`、`新增/编辑卡片组`、`新增/编辑卡片`、`本轮选卡面板`、`学习完成页`。
- 首页只在存在“当前卡片组”且该组有卡片时渲染学习 UI；否则显示空状态与引导按钮。卡片区域用 `PageView.builder` 实现懒加载和无限循环，左滑下一张、右滑上一张，索引按活跃卡片列表取模。
- 卡片组和卡片都做完整 CRUD。卡片组列表点击即切换当前卡片组；首页右上“新增卡片”默认写入当前卡片组，无当前卡片组时先引导用户选择或新建卡片组。
- 进入本轮学习前必须创建 `StudySession`，支持 `自选 / 加权随机 / 顺序选择` 三种来源，默认数量来自设置且初始为 `30`；若请求数量大于等于卡组总数则直接全选。顺序选择按 `sortIndex` 连续取卡，并把 `nextSequentialCursor` 存在卡片组上，下次从上次断点继续。
- 会话创建时立即落库快照：`selectedCardIds`、`displayOrder`、`currentIndex`、`mode`、`overState`、`startedAt`。三种选卡方式都在创建会话后统一“随机洗牌一次并持久化展示顺序”；这样“选卡集合固定，但首页按随机顺序学习”。App 重启后自动恢复该快照；源卡片后续被编辑或删除，不影响当前会话。
- `Reset` 让当前卡片继续留在活跃集合，并累计该卡历史 `resetCount`；`Over` 在当轮首次点击时累计历史 `overCount`、标记该会话卡片完成并立即从后续循环中剔除。若全部会话卡片都被 `Over`，则本轮完成，写入完成时长、完成轮次和汇总记录。
- 加权随机采用“不放回抽样”。单卡权重固定为 `clamp(0.2, 20, ((resetCount + 1) * (resetCount + 1)) / ((selectionCount + 1) * (overCount + 1)))`；`selectionCount` 在会话创建时递增，`resetCount` 在 `Reset` 时递增，`overCount` 在当轮首次 `Over` 时递增。这样“经常被抽中/已经掌握”的卡权重下降，“频繁 Reset 的难卡”权重上升，同时保留最小概率避免永远抽不到。
- 练习模式默认直接展示 `title + answer`；考试模式默认只展示 `title`，点击卡面后记录一次 `answerRevealed` 事件并展开 `answer`。设置页里的“默认模式”只决定新会话初值；首页 AppBar 的模式切换只作用于当前学习上下文，不回写默认设置。
- 统计页做 6 个模块：`总览指标卡`、`7/30 天学习趋势折线`、`月度学习日历`、`卡片组学习排行`、`困难卡片榜`、`连续学习/完成率徽章`。日历使用 `table_calendar` 自定义单元格强度颜色；图表与榜单统一用彩色图标卡片表达，数据全部从事件表和会话表聚合，不从页面临时状态倒推。

## 公共接口与类型
- 枚举：`StudyMode { practice, exam }`、`SessionSource { manual, weightedRandom, sequential }`、`StudyEventType { sessionStarted, answerRevealed, reset, over, sessionCompleted }`。
- 核心模型：`Deck`、`CardItem`、`StudySession`、`StudySessionCard`、`StudyEvent`、`AppSettings`。
- 关键仓储与服务：`DeckRepository`、`CardRepository`、`StudySessionRepository`、`StatsRepository`、`SettingsRepository`、`WeightedSelectionService`。
- 本地库表结构：`decks(id, name, nextSequentialCursor, createdAt, updatedAt)`、`cards(id, deckId, title, answer?, sortIndex, selectionCount, resetCount, overCount, createdAt, updatedAt)`、`study_sessions(id, deckId, source, mode, currentIndex, startedAt, completedAt?, cycleCount)`、`study_session_cards(id, sessionId, cardId, titleSnapshot, answerSnapshot?, displayOrder, isOver)`、`study_events(id, sessionId, deckId, cardId?, type, occurredAt, payload?)`。
- 约束：`answer` 可空；`sortIndex` 由创建顺序自动赋值，首版不做拖拽排序；设置值只包含 `themeMode`、`defaultSelectionCount`、`defaultStudyMode`、`currentDeckId`。

## 测试计划
- 单元测试覆盖：权重公式、随机不放回抽样、顺序选择游标推进、`Reset/Over` 计数、副作用写库、统计聚合计算。
- Widget 测试覆盖：首页空状态、选卡面板三种模式、考试模式点按显隐答案、左滑右滑循环、全部 `Over` 后完成页、设置项持久化后重新打开仍生效。
- 集成测试覆盖：新建卡片组与卡片 -> 创建学习会话 -> 退出重进自动恢复 -> 完成本轮 -> 统计页出现对应记录。
- 回归重点：卡组总数小于默认 `30` 时自动全选；源卡片被删除后当前会话仍能继续；无当前卡片组时首页不渲染学习卡片 UI。

## 默认假设
- 首版界面语言为中文，模型与代码命名保持英文。
- 当前学习会话以“快照”作为事实来源，不追随源卡片实时变化。
- `Over` 立即移出后续循环，而不是等整轮结束后再移除。
- 设置使用 `shared_preferences` 仅保存简单默认值；卡片、会话、统计都放 `drift` 数据库。
- 若实现阶段新增通用组件或路由辅助方法，需要同步登记到 `docs/widget.md` 并补齐测试代码。
- 参考依赖与文档：[flutter_riverpod](https://pub.dev/packages/flutter_riverpod)、[go_router](https://pub.dev/packages/go_router)、[drift](https://pub.dev/packages/drift)、[drift_flutter](https://pub.dev/packages/drift_flutter)、[shared_preferences](https://pub.dev/packages/shared_preferences)、[fl_chart](https://pub.dev/packages/fl_chart)、[table_calendar](https://pub.dev/packages/table_calendar)。
- 备注：本方案按 Flutter 工程实践规则制定。
