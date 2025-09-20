extends Area2D

func _on_area_entered(area):
	if area.is_in_group("Player_attack"):
		$Sprite2D.modulate = Color(2.708, 2.708, 2.708)

func _on_area_exited(area):
	if area.is_in_group("Player_attack"):
		$Sprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0)
	
