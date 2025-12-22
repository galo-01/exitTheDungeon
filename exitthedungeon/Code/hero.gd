extends Node2D


@onready var MaxDamageLabel = $Hand/Sprite/MaxLevel
@onready var DamageLabel = $Hand/Sprite/Damage
@onready var CoinCounter = $Money/CurrentCoins



func _ready() -> void:
	Global.HeroNode = self

func take_damage():
	$Health/Animator.play('take_damage')
	$Health/CurrentHealth.text = str(Global.player_health)

func gain_health():
	$Health/Animator.play('gain_health')
	$Health/CurrentHealth.text = str(Global.player_health)


func update_coins():
	CoinCounter.text = str(Global.player_coins)

func update_chamber():
	$Chamber/CurrentChamber.text = str('Chamber ',str(Global.chamber))


func attack():
	$Hand/Animator.play("attack")
	if(Global.player_max_weapon_damage > 99 or Global.player_weapon_level == 0):
		MaxDamageLabel.text = str('Max ∞')
	else:
		MaxDamageLabel.text = str('Max ',Global.player_max_weapon_damage)
	
	if Global.player_health <= 0:
		$GameOver.visible = true
		$GameOver/Score.text = str('Score: ',str(Global.player_coins))
		get_tree().paused = true

func get_new_weapon(level):
	$Hand/Sprite.frame = 1
	$Hand/Animator.play("change")
	DamageLabel.text = str(level)
	MaxDamageLabel.text = str('Max ∞')

func discard_weapon():
	Global.discard_current_weapon()
	$Hand/Sprite.frame = 0
	$Hand/Animator.play("change")
	DamageLabel.text = str(0)
	MaxDamageLabel.text = str('Max ∞')


func _on_texture_button_button_up() -> void:
	discard_weapon()
