extends StaticBody2D



func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and Input.is_action_just_pressed("Interaction"):
		$AnimatedSprite2D.play("open")
		
