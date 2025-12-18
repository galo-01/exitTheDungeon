extends Node

@onready var HeroNode

var player_health = 20
var player_coins = 0

var player_weapon_level = 0
var player_max_weapon_damage = 999

var deck = []
var cards_on_table = []


# ------------------------------------------------------------ DECK BOULDING



# ------------------------------------------------------------- CARD ACTIONS

func attack(damage_level):
	var damage = max(damage_level - player_weapon_level, 0)
	damage_player(damage)
	
	player_coins += damage_level
	HeroNode.update_coins()
	
	if (player_weapon_level > 0):
		player_max_weapon_damage =  damage_level-1
	
	HeroNode.attack()

func damage_player(damage):
	player_health -= damage
	HeroNode.update_health()


func take_potion(level):
	player_health = min(player_health + level,20)
	HeroNode.update_health()

func grab_weapon(level):
	player_weapon_level = level
	player_max_weapon_damage = 999
	HeroNode.get_new_weapon(level)


# ------------------------------------------------------------- HAND ACTION

func discard_current_weapon():
	player_weapon_level = 0
	player_max_weapon_damage = 999
