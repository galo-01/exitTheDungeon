extends Node2D #(CardManager)

@export var Card: PackedScene
@onready var CardContainer = $CardsContainer


@export var monster_pool: Array[CardData]
@export var weapon_pool: Array[CardData]
@export var potion_pool: Array[CardData]


var deck_set_size = 8
var draw_size = 4


func _ready() -> void:
	Global.CardManagerNode = self
	fill_deck(deck_set_size)
	add_cards_to_table(draw_size)


func fill_deck(setAmout:int):
	Global.next_chamber()
	Global.deck.clear()
	
	
	for i in setAmout:
		# monster
		for j in randi_range(2,3):
			if monster_pool.is_empty():
				break
			var newEnemy =CardInstance.new(monster_pool.pick_random())
			Global.deck.append(newEnemy)
			print(newEnemy.info())
		
		# wepons
		if not weapon_pool.is_empty():
			var newWeapon = WeaponInstance.new(weapon_pool.pick_random())
			Global.deck.append(newWeapon)
			print(newWeapon.info())
		
		# potions
		if not potion_pool.is_empty():
			var newPotion = CardInstance.new(potion_pool.pick_random())
			Global.deck.append(newPotion)
			print(newPotion.info())
	
	Global.deck.shuffle()


func next_set_of_cards():
	Global.redraw_token = 1
	Global.can_redraw = true
	#show redraw button
	$ChangeCards/Sprite.modulate = Color("ffffff")
	
	add_cards_to_table(min(draw_size-1, Global.deck.size()))
	
	if(Global.table_cards.size() == 0):
		fill_deck(deck_set_size)
		add_cards_to_table(draw_size)
	

func redraw_cards():
	if Global.table_cards.size() == draw_size and Global.can_redraw:
		
		Global.redraw_token -= 1
		
		if Global.redraw_token < 1:
			Global.can_redraw = false
		
		
		# Return cards con table_cards to the deck
		for card in Global.table_cards:
			Global.deck.append(card)
		Global.table_cards.clear()
		
		# 2) clean cards
		await CardContainer.clear_cards()
		
		add_cards_to_table(draw_size)
		
		#hide redraw button
		lock_redraw_button()


func add_cards_to_table(num: int):
	for i in num: 
		if Global.deck.is_empty():
			break
		
		# 1) get first card from deck
		var card_obj = Global.deck.pop_front()
		
		# 2) model
		Global.table_cards.append(card_obj)
		
		# 3) show
		var card_instance = Card.instantiate()
		CardContainer.add_card(card_instance)
		card_instance.set_card(card_obj)
	
	CardContainer.layout_cards()


func remove_card_from_table(card_object):
	Global.table_cards.erase(card_object)
	if Global.table_cards.size() <= 1:
		next_set_of_cards()

func lock_redraw_button():
	$ChangeCards/Sprite.modulate = Color("ffffff93")


# ----------------------------------------------------- Button

func _on_change_cards_button_up() -> void:
	redraw_cards()
