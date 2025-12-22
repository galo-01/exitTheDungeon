extends Node


## ORIGINAL SCREEN SIZE 270x480

## now points to  SIZE 270x604




var HeroNode: Node = null

var player_health = 20
var player_coins = 0

var player_weapon_level = 0
var player_max_weapon_damage = 999

var redraw_token = 1

var chamber = 0

# ------------------------------------------------------------ DECK BUILDING

var player_deck = [] # not used yet

var deck = []
var table_cards = []

# ------------------------------------------------------------- CARD ACTIONS

func attack(damage_level):
	var damage = max(damage_level - player_weapon_level, 0)
	damage_player(damage)
	
	player_coins += damage_level
	HeroNode.update_coins()
	
	if (player_weapon_level > 0):  
		player_max_weapon_damage =  damage_level-1
	
	if(player_max_weapon_damage == 0):
		HeroNode.discard_weapon()
	
	HeroNode.attack()

func damage_player(damage):
	player_health -= damage
	HeroNode.take_damage()

func take_potion(level):
	player_health = min(player_health + level,20)
	HeroNode.gain_health()

func grab_weapon(level):
	player_weapon_level = level
	player_max_weapon_damage = 999
	HeroNode.get_new_weapon(level)


func next_chamber():
	chamber += 1
	if HeroNode:
		HeroNode.update_chamber()

# ------------------------------------------------------------- HAND ACTION

func discard_current_weapon():
	player_weapon_level = 0
	player_max_weapon_damage = 999
