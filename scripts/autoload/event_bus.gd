extends Node

## 全局事件总线：模块之间只通过这里的信号通信，互不直接引用。
## 这些信号对应 docs/design.md 的 9.2 节，先定好，避免后续重构。

# 作物
signal crop_planted(crop_id: String, tile: Vector2i)
signal crop_matured(crop_id: String, tile: Vector2i)
signal crop_harvested(crop_id: String, tile: Vector2i, quality: int)

# 精灵
signal spirit_born(spirit_id: String, species: String, tile: Vector2i)
signal spirit_fed(spirit_id: String, crop_id: String, amount: int)
signal spirit_leveled_up(spirit_id: String, level: int)
signal spirit_evolved(spirit_id: String, from_species: String, to_species: String)
signal spirit_mood_changed(spirit_id: String, mood: float)

# 代办
signal chore_assigned(spirit_id: String, chore: String, target: Vector2i)
signal chore_completed(spirit_id: String, chore: String, result: Dictionary)
