extends Area2D #(Card) There will be many of them as childs of CardContainer

@onready var LevelLabel = $Sprite/LevelLabel
@onready var CardContainer = get_parent()

var tween: Tween

var level
var type

# ----------------------------------------- Card Creation
func _ready() -> void:
	$Animator.play('idle')


func set_card(data: CardData):
	
	# 1) Level and type from the card data
	type = data.type
	level = randi_range(data.min_level, data.max_level)
	
	print(level)
	
	# 2) Set texture and level visuals
	$Sprite.texture = data.texture
	LevelLabel.text = str(level)
	$Animator.play('idle')

# ---------------------------------------------------------------- Click

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		on_pressed()
	elif event is InputEventScreenTouch and event.pressed:
		on_pressed()

func on_pressed():
	match type:
		'weapon':
			grab_weapon()
		'monster':
			attack()
		'potion':
			take_potion()

# ------------------------------------------------------------------ Actions for click

signal request_remove(card)

func attack():
	if (Global.player_max_weapon_damage >= level): # If weapon can kill card (weapon_max_level)
		# 1) get damaged and get coins
		Global.attack(level)
		# 2) show card animation
		$Animator.play("die")
		await $Animator.animation_finished
		# 3) show card animation
		request_remove.emit(self)


func grab_weapon():
	#1) Get Weapon
	Global.grab_weapon(level)
	
	#2) Show animation
	$Animator.play("grab")
	await $Animator.animation_finished
	
	#3) be deleted by parent
	request_remove.emit(self)

func take_potion():
	#1) Heal
	Global.take_potion(level)
	
	#2) Show card animation
	$Animator.play("grab")
	await $Animator.animation_finished
	
	#3) be deleted by parent
	request_remove.emit(self)

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
