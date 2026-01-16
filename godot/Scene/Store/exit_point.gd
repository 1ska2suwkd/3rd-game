extends Area2D

@export var player: Player

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		global.player_next_position = global.STORE_FRONT
		var animated_sprite = body.get_node_or_null("AnimatedSprite2D")
		if animated_sprite:
			global.player_flip_h = animated_sprite.flip_h
			print(global.player_flip_h)
		
		SceneManager.change_scene("res://Scene/Village/Village.tscn")
