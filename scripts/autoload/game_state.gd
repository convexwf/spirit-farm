extends Node

## 全局游戏状态：日期、季节、当日时间。
## 后续把天气、金钱、存档统一入口也归到这里。

signal day_changed(day: int, season: int)

const SEASONS := ["春", "夏", "秋", "冬"]
const DAYS_PER_SEASON := 28
const MINUTES_PER_DAY := 24 * 60

var day := 1
var season := 0          # 0=春 1=夏 2=秋 3=冬
var minute_of_day := 600 # 早上 10:00
var money := 0
var harvests := 0

var season_name: String:
	get:
		return SEASONS[season]

func advance_minutes(amount: int) -> void:
	minute_of_day += amount
	while minute_of_day >= MINUTES_PER_DAY:
		minute_of_day -= MINUTES_PER_DAY
		_next_day()

func _next_day() -> void:
	day += 1
	if day > DAYS_PER_SEASON:
		day = 1
		season = (season + 1) % SEASONS.size()
	day_changed.emit(day, season)
