extends Node

var all_item: Dictionary

func _ready() -> void:
	all_item = {
		1: preload("res://Resources/Items/ATK_damage_book.tres"),
		2: preload("res://Resources/Items/ATK_speed_book.tres"),
		3: preload("res://Resources/Items/maid_costume.tres"),
		4: preload("res://Resources/Items/Piercing_Attack.tres")
	}
