#!/usr/bin/env python3
"""生成 v0.1 占位素材（玩家、作物 5 阶段、浇水标记）。

来源说明：Kenney Tiny 系列没有玩家角色图，Tiny Farm 的作物瓦片
编号未确认，因此用本脚本逐像素绘制 16x16 占位图，先保证玩法可跑。
正式素材替换见 docs/roadmap.md 第 6 章"素材与美术"。

用法：
    python3 tools/generate_placeholders.py

输出（相对仓库根目录）：
    assets/sprites/player_placeholder.png
    assets/sprites/crops/crop_stage_0.png .. crop_stage_4.png
    assets/sprites/fx/watered.png
"""

import os
from PIL import Image

OUTLINE = (44, 32, 24, 255)
ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))


def new_img():
    return Image.new("RGBA", (16, 16), (0, 0, 0, 0))


def px(img, x, y, c):
    if 0 <= x < 16 and 0 <= y < 16:
        img.putpixel((x, y), c)


def rect(img, x0, y0, x1, y1, c):
    for y in range(y0, y1 + 1):
        for x in range(x0, x1 + 1):
            px(img, x, y, c)


def outline_rect(img, x0, y0, x1, y1):
    for x in range(x0, x1 + 1):
        px(img, x, y0, OUTLINE)
        px(img, x, y1, OUTLINE)
    for y in range(y0, y1 + 1):
        px(img, x0, y, OUTLINE)
        px(img, x1, y, OUTLINE)


def player_placeholder():
    p = new_img()
    rect(p, 4, 0, 11, 2, (160, 104, 56))      # 帽顶
    rect(p, 3, 3, 12, 3, (160, 104, 56))      # 帽檐
    outline_rect(p, 3, 0, 12, 3)
    rect(p, 5, 4, 10, 8, (240, 200, 160))     # 脸
    px(p, 6, 6, OUTLINE)                       # 眼睛
    px(p, 9, 6, OUTLINE)
    px(p, 7, 8, (216, 96, 96))                # 嘴
    rect(p, 4, 9, 11, 12, (96, 144, 208))     # 身体（工装）
    px(p, 3, 9, (240, 200, 160))              # 手
    px(p, 12, 9, (240, 200, 160))
    outline_rect(p, 3, 9, 12, 12)
    rect(p, 5, 10, 6, 11, (240, 200, 160))    # 吊带
    rect(p, 9, 10, 10, 11, (240, 200, 160))
    rect(p, 4, 13, 7, 15, (72, 96, 144))      # 腿
    rect(p, 8, 13, 11, 15, (72, 96, 144))
    px(p, 4, 15, OUTLINE)
    px(p, 11, 15, OUTLINE)
    return p


def watered_mark():
    d = new_img()
    pixels = [
        (8, 2, OUTLINE), (7, 3, OUTLINE), (8, 3, OUTLINE), (9, 3, OUTLINE),
        (7, 4, (80, 160, 240)), (8, 4, (80, 160, 240)), (9, 4, (80, 160, 240)),
        (6, 5, (80, 160, 240)), (7, 5, (120, 190, 250)), (8, 5, (120, 190, 250)), (9, 5, (80, 160, 240)), (10, 5, (80, 160, 240)),
        (6, 6, (80, 160, 240)), (7, 6, (120, 190, 250)), (8, 6, (120, 190, 250)), (9, 6, (80, 160, 240)), (10, 6, (80, 160, 240)),
        (6, 7, (80, 160, 240)), (7, 7, (120, 190, 250)), (8, 7, (120, 190, 250)), (9, 7, (80, 160, 240)), (10, 7, (80, 160, 240)),
        (6, 8, (80, 160, 240)), (7, 8, (120, 190, 250)), (8, 8, (120, 190, 250)), (9, 8, (80, 160, 240)), (10, 8, (80, 160, 240)),
        (7, 9, (80, 160, 240)), (8, 9, (120, 190, 250)), (9, 9, (80, 160, 240)),
        (8, 10, OUTLINE), (7, 11, OUTLINE), (8, 11, OUTLINE), (9, 11, OUTLINE), (8, 12, OUTLINE),
    ]
    for x, y, c in pixels:
        px(d, x, y, c)
    return d


def leaf(img, x, y, c=(80, 168, 80)):
    for dx, dy in [(0, 0), (1, 0), (-1, 0), (0, 1), (0, -1)]:
        px(img, x + dx, y + dy, c)


def crop_stages():
    stages = []
    # 0 播种：土堆
    s = new_img()
    rect(s, 5, 12, 10, 13, (140, 96, 56))
    for x in range(6, 10):
        px(s, x, 11, (140, 96, 56))
    outline_rect(s, 5, 11, 10, 13)
    stages.append(s)
    # 1 发芽
    s = new_img()
    rect(s, 7, 12, 8, 13, (140, 96, 56))
    for y in range(11, 5, -1):
        px(s, 7, y, (64, 140, 64))
        px(s, 8, y, (64, 140, 64))
    px(s, 6, 6, (96, 190, 96))
    px(s, 9, 6, (96, 190, 96))
    stages.append(s)
    # 2 幼苗
    s = new_img()
    for y in range(12, 5, -1):
        px(s, 7, y, (64, 140, 64))
        px(s, 8, y, (64, 140, 64))
    leaf(s, 6, 5)
    leaf(s, 9, 5)
    leaf(s, 5, 7, (96, 190, 96))
    leaf(s, 10, 7, (96, 190, 96))
    stages.append(s)
    # 3 成株
    s = new_img()
    for y in range(12, 4, -1):
        px(s, 7, y, (64, 140, 64))
        px(s, 8, y, (64, 140, 64))
    for cx, cy in [(5, 5), (10, 5), (6, 4), (9, 4), (4, 7), (11, 7)]:
        leaf(s, cx, cy)
    stages.append(s)
    # 4 成熟：金黄麦穗 + 果点
    s = new_img()
    for y in range(12, 3, -1):
        px(s, 7, y, (64, 140, 64))
        px(s, 8, y, (64, 140, 64))
    for cx, cy in [(5, 5), (10, 5), (6, 4), (9, 4), (4, 7), (11, 7)]:
        leaf(s, cx, cy, (96, 190, 96))
    for x, y in [(6, 3), (9, 3), (5, 6), (10, 6), (7, 5), (8, 5), (6, 8), (9, 8)]:
        px(s, x, y, (240, 200, 80))
    px(s, 7, 6, (224, 96, 80))
    px(s, 8, 6, (224, 96, 80))
    stages.append(s)
    return stages


def main():
    out_player = os.path.join(ROOT, "assets/sprites/player_placeholder.png")
    out_watered = os.path.join(ROOT, "assets/sprites/fx/watered.png")
    out_crops = os.path.join(ROOT, "assets/sprites/crops")
    os.makedirs(os.path.dirname(out_watered), exist_ok=True)
    os.makedirs(out_crops, exist_ok=True)
    player_placeholder().save(out_player)
    watered_mark().save(out_watered)
    for i, stage in enumerate(crop_stages()):
        stage.save(os.path.join(out_crops, f"crop_stage_{i}.png"))
    print("占位素材已生成：", out_player, out_watered, out_crops)


if __name__ == "__main__":
    main()
