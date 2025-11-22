# atk_speed_book

extends "res://Resources/Items/add_Item.gd"

func _on_body_entered(body: Node2D) -> void:
	super._on_body_entered(body)
	
	update_stat()

func update_stat():
	PlayerStat.set_attack_speed(0.5)
