extends "res://enemy/Script/BaseEnemy.gd"

@onready var nav_agent := $NavigationAgent2D
@export var flee_distance := 300.0

var is_fleeing := false

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

	if not is_attack:
		if is_fleeing and player:
			var dir = (global_position - player.global_position).normalized()
			nav_agent.target_position = global_position + dir * flee_distance

			var next_pos = nav_agent.get_next_path_position()
			var move_dir = (next_pos - global_position).normalized()
			velocity = move_dir * stat.speed
		else:
			velocity = Vector2.ZERO

		if velocity.length() > 1.0:
			$AnimatedSprite2D.play("walk")
			$AnimatedSprite2D.flip_h = velocity.x < 0
		else:
			$AnimatedSprite2D.play("idle")


func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		is_fleeing = true

func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		is_fleeing = false
