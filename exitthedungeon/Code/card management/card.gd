extends Area2D #(Card) There will be many of them as childs of CardContainer

@onready var LevelLabel = $Sprite/LevelLabel
@onready var CardContainer = get_parent()

signal request_remove(card)

var tween: Tween
var card_object: CardObject

var is_locked := false


# ----------------------------------------- Card Creation
func _ready() -> void:
	$Animator.play('idle')

func set_card(cardObj: CardObject):
	card_object = cardObj
	
	#  Set texture and level visuals
	$Sprite.texture = card_object.data.texture
	LevelLabel.text = str(card_object.level)
	$Animator.play('idle')
	


# ---------------------------------------------------------------- Click

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if is_locked: # do nothing if card is locked
		return
	
	if event is InputEventMouseButton and event.pressed:
		on_pressed()
	elif event is InputEventScreenTouch and event.pressed:
		on_pressed()


func on_pressed():
	match card_object.data.type:
		'weapon':
			grab_weapon()
		'monster':
			attack()
		'potion':
			take_potion()

# ------------------------------------------------------------------ Actions for click

func attack():
	if (Global.player_max_weapon_damage >= card_object.level): # If weapon can kill card (weapon_max_level)
		is_locked = true # lock card
		# 1) get damaged and get coins
		Global.select_card('attack',card_object.level)
		# 2) show card animation
		$Animator.play("die")
		await $Animator.animation_finished
		# 3) show card animation
		request_remove.emit(card_object)

func grab_weapon():
	is_locked = true # lock card
	
	#1) Get Weapon
	Global.select_card('grab_weapon',card_object.level)
	
	#2) Show animation
	$Animator.play("grab")
	await $Animator.animation_finished
	
	#3) be deleted by parent
	request_remove.emit(card_object)

func take_potion():
	is_locked = true # lock card
	#1) Heal
	Global.select_card('take_potion',card_object.level)
	
	#2) Show card animation
	$Animator.play("grab")
	await $Animator.animation_finished
	
	#3) be deleted by parent
	request_remove.emit(card_object)



#--------------------------------------------------------- Visuals
func _on_mouse_entered() -> void:
	$Animator.play("hover_up")

func _on_mouse_exited() -> void:
	$Animator.play("hover_down")

func move_to(target_pos: Vector2, time: float): 
	if tween:
		tween.kill()
	tween = create_tween()
	tween.tween_property(self,"position",target_pos,time).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
