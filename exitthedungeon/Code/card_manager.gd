extends Node2D #(CardManager)

@export var Card: PackedScene
@onready var CardContainer = $CardsContainer

var cards = {
	0: {'card_type':'monster','level':2},
	1: {'card_type':'monster','level':5},
	2: {'card_type':'monster','level':7},
	3: {'card_type':'weapon','level':3},
	4: {'card_type':'weapon','level':6},
	5: {'card_type':'potion','level':4},
}

func _ready() -> void:
	add_new_cards(4)

func next_set_of_cards(num): # NOT BEING USED
	for child in CardContainer.get_children():
		child.queue_free()
		
	add_new_cards(num)

func add_new_cards(num):
	print('------------')
	for i in num:
		# Create card and add to CardContainer
		var card_instance = Card.instantiate()
		
		# Add card to CardContainer
		CardContainer.add_card(card_instance)
		
		# Set card to that card (what type of card it will be)
		var x = randi_range(0,5)
		var card_obj = cards[x].duplicate() # .duplicate() porque sino lo pasa por referencia (edita el objeto original)
		card_obj['card_index'] = x
		card_instance.set_card(card_obj)
		
	
	# Update layout after all cards were added
	CardContainer.layout_cards()

func _on_timer_timeout() -> void:
	add_new_cards(3)
