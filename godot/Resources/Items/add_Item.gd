extends Area2D

@export var item_resources : Resource

signal add_item()

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		PlayerStat.player_inv.items[item_resources.item_number] = item_resources
		emit_signal("add_item")
		queue_free()
