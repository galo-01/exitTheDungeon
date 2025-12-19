extends Node2D #(CardManager)

@export var Card: PackedScene
@onready var CardContainer = $CardsContainer



@export var cards_pool: Array[CardData] # NEW array of posible cards



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
		
		# Choose a card from the card_pool
		var card_data = cards_pool[randi_range(0,cards_pool.size()-1)]
		
		# give cardData to the card created
		card_instance.set_card(card_data)
		
	
	# Update layout after all cards were added
	CardContainer.layout_cards()

func _on_timer_timeout() -> void:
	add_new_cards(3)
