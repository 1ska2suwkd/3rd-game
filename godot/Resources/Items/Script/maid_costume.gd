# ATK_damage_book

extends "res://Resources/Items/add_Item.gd"

func _ready() -> void:
	connect("add_item", Callable(self, "update_item"))

func update_item():
	PlayerStat.set_attack_range(2)
