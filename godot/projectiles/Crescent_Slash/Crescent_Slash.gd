extends Area2D

@export var speed: float = 1300
var damage: int = 0
var direction: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemy"):
		#body.apply_knockback(global_position, 500.0, 0.1)
		queue_free()
	elif body.is_in_group("Wall"):
		queue_free()
	
