extends Node2D #(CardContainer)

@export var card_spacing := 80
@export var y_offset := 0
@export var animation_time := 0.2
var tween: Tween

func add_card(card: Node):
	add_child(card)
	card.request_remove.connect(_on_card_request_remove)
	layout_cards()

func layout_cards(): 
	var cards := get_children()
	var count := cards.size()
	if count == 0:
		return
	
	var total_width := (count - 1) * card_spacing
	var start_x := -total_width / 2.0
	
	for i in count:
		var card = cards[i]
		var target_pos = Vector2(start_x + i * card_spacing,y_offset )
		card.move_to(target_pos, animation_time)


func _on_card_request_remove(card_Object): # for the card to be deleted
	# 1) delete from table_cards (Model)
	get_parent().remove_card_from_table(card_Object)
	
	# 2) delete the actual card node (view)
	for card_node in get_children():
		if card_node.card_object == card_Object:
			card_node.queue_free()
			break
	
	await get_tree().process_frame
	layout_cards()
	
	print(Global.table_cards)

func clear_cards():
	for card_node in get_children():
		card_node.queue_free()
	
	await get_tree().process_frame
	layout_cards()

# ---------------------------------------------------------- ANimation
func move_to(target_pos: Vector2, time: float): # animation
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self,"position",target_pos,time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
