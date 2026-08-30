# Spirit Farm（暂定名）

类星露谷的农场经营 + 精灵养成练手项目。

- 引擎：Godot 4.7（GDScript）
- 素材：Kenney Tiny 系列（16×16，CC0）
- 核心创意：作物孕育精灵，精灵代办重复农活；喂养作物让精灵升级、进化、变强

## 运行

用 `C:\software\Godot\Godot_v4.7.2-stable_win64.exe` 打开本目录下的
`project.godot` 即可。首次打开会生成 `.godot/` 缓存目录。

## 目录结构

```text
assets/             素材（sprites / tilesets / audio / 视觉规范）
docs/design.md      核心设定文档（项目的"宪法"，改动先改这里）
docs/roadmap.md     开发路线图（待办清单，按主题分栏）
scenes/             场景
scripts/
  autoload/         全局单例（GameState、EventBus）
  data/             数据定义（CropData、SpiritData 等 Resource）
  core/             玩法核心逻辑
```

## 核心设定

精灵不是附加系统，而是整个游戏的主轴。完整的设定、数值原则和 MVP
分期见 [docs/design.md](docs/design.md)。
