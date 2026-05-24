extends RefCounted
class_name CardInstance


# type = "enemy" or "potion"
# name = "Goblin"
# power = 7


var data: CardData
var power: int


func _init(card_data: CardData):
	data = card_data
	power = randi_range(data.min_power, data.max_power)


# ------------------------------------------------ GETTERS

func getPower():
	return power

func info():
	return str("[Card]: ",data.name," , Power: ",power)
