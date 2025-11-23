extends Node

var all_item: Dictionary

func _ready() -> void:
	all_item = {
		1: preload("res://Resources/Items/Materials/ATK_damage_book.tres"),
		2: preload("res://Resources/Items/Materials/ATK_speed_book.tres"),
		3: preload("res://Resources/Items/Materials/maid_costume.tres"),
		4: preload("res://Resources/Items/Materials/Piercing_Attack.tres")
	}
