extends Node

var all_item: Dictionary

func _ready() -> void:
	all_item = {
		0: MasterSkill.Crescent_Slash_item,
		1: MasterSkill.speer_item,
		2: preload("res://Resources/Items/ATK_damage_book.tres"),
		3: preload("res://Resources/Items/ATK_speed_book.tres"),
		4: preload("res://Resources/Items/maid_costume.tres"),
		5: preload("res://Resources/Items/Piercing_Attack.tres")
	}
