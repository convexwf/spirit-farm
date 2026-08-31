# 素材目录

## 已下载的素材（assets/kenney/）

均为 CC0 授权（每个包内自带 `License.txt`），16×16 像素，可自由用于
练习和商业项目。每个包自带 `Preview.png` 预览图和 `Tilesheet.txt`
（瓦片规格说明）。

| 目录 | 内容 | 规模 |
| --- | --- | --- |
| `tiny-farm/` | 作物、家畜、农具、谷仓（农场玩法核心） | 130+ 素材，132 瓦片 |
| `tiny-town/` | 城镇建筑、地形、植被（村庄地图） | 130+ 素材，132 瓦片 |
| `tiny-dungeon/` | 室内/矿洞瓦片、武器、物品、角色 | 130+ 素材，132 瓦片 |
| `tiny-battle/` | 战斗单位（做战斗时用） | 200+ 素材 |
| `tiny-creatures/` | 180 个怪物/动物（Tiny 风格扩展，兼容 Tiny Dungeon/Town） | 180 瓦片 |
| `ui-pack-pixel-adventure/` | UI 面板、按钮、图标（背包/精灵面板用） | 大量 UI 素材 |
| `input-prompts-pixel/` | 键盘/手柄按键提示图标 | 常用按键 |

### 包内结构

```text
Tilemap/            整图 tilemap（tilemap.png 带 1px 边距，tilemap_packed.png 紧凑版）
Tilesheet.txt       瓦片规格说明
License.txt         CC0 授权文件
```

为了不给 git 增加负担，仓库里**只保留运行时需要的整图和许可文件**。
各包的独立瓦片（`Tiles/`）、Tiled 示例地图等完整内容已删除，
需要时按下方地址重新下载即可。

各包的预览图统一放在 `_previews/` 目录（文件名带包名前缀），该目录
有 `.gdignore` 标记，Godot 不会导入，仅供人工查看。

### Godot 导入注意

Kenney 的 `tilemap.png` 瓦片间距为 1px（见各包 `Tilesheet.txt`）。
在 Godot TileSet 里建 AtlasSource 时，设置 `margin=1, separation=1`
（`tilemap_packed.png` 则是 `margin=0, separation=0`）。

### 重新下载地址（完整包）

- Tiny Farm: https://kenney.nl/assets/tiny-farm
- Tiny Town: https://kenney.nl/assets/tiny-town
- Tiny Dungeon: https://kenney.nl/assets/tiny-dungeon
- Tiny Battle: https://kenney.nl/assets/tiny-battle
- Tiny Creatures: https://opengameart.org/content/tiny-creatures
- UI Pack (Pixel Adventure): https://kenney.nl/assets/ui-pack-pixel-adventure
- Input Prompts Pixel: https://kenney.nl/assets/input-prompts-pixel

### Tiny Creatures 方向说明

该包所有怪物默认朝右，角色朝左时水平翻转即可（作者原话）。

## 目录约定

| 目录 | 放什么 |
| --- | --- |
| `kenney/` | 官方包原始解压内容，**保持原结构，不修改** |
| `sprites/` | 项目自制的精灵、角色动画（按 visual-spec 规范） |
| `tilesets/` | 从 kenney 包整理出的实际使用 tileset（Godot TileSet 资源） |
| `audio/` | 音效和音乐 |

## 素材缺口

精灵本体、进化形态、孵化特效（漂浮系精灵）Kenney 系列没有现成的，
需要自制或找风格匹配素材，规则见 [visual-spec.md](visual-spec.md)。

## 占位素材（assets/sprites/）

| 文件 | 用途 | 来源 |
| --- | --- | --- |
| `player_placeholder.png` | 旧版玩家占位（保留作回退素材） | 代码生成，运行时已改用 Tiny Farm 图块 |
| `crops/crop_stage_0~4.png` | 旧版作物占位（保留作回退素材） | 代码生成，运行时已改用 Tiny Farm 64-68 |
| `fx/watered.png` | 已浇水标记 | 代码生成 |

这些旧占位图由 [tools/generate_placeholders.py](../tools/generate_placeholders.py)
逐像素生成，保留它们是为了在正式素材缺失时仍能快速回退。当前运行时已接入
Tiny Farm 的玩家图块与作物 64-68；玩家完整四向行走帧仍按
[roadmap.md](../docs/roadmap.md) 第 6 章继续补齐。

确认瓦片编号时可打开 `_previews/tiny-farm_indexed.png`、
`tiny-town_indexed.png`、`tiny-dungeon_indexed.png`（带编号索引图）对照。
