extends RefCounted
class_name CardObject

var data: CardData
var level: int

func _init(card_data: CardData):
	data = card_data
	level = randi_range(data.min_level, data.max_level)
