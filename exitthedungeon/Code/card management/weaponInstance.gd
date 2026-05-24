class_name WeaponInstance
extends CardInstance


# type = weapon
# name = "Sword"
# power = 7
# max_tier = 0  // 0 means infinit
# element = NONE
# ability = ""


var max_tier: int
var element: Element
var ability: String

enum Element {
	NONE,
	DOMONIC,
	ARCAIC,
	JADE
}


func _init(card_data: CardData):
	super(card_data)
	element=Element.NONE
	ability=""
