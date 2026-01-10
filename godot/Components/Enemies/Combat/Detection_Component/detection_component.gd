extends Area2D
class_name DetectionComponent

var player_in_area: bool = false
var player_position: Vector2
var target: CharacterBody2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_area = true
		target = body


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		player_in_area = false
