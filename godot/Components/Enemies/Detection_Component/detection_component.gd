extends Area2D
class_name DetectionComponent

var player_chase: bool = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_chase = true


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_chase = false
