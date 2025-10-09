extends Area2D

@export var speed: float = 600
@export var target: Node2D
var damage: int = 0
var direction: Vector2 = Vector2.ZERO
var is_attacked: bool = false

func _ready() -> void:
	if target:
		direction = (target.global_position - global_position).normalized()
		rotation = direction.angle()
		
		
func _physics_process(delta: float) -> void:
	position += direction * speed * delta


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_attacked:
		body.apply_knockback(global_position, 1000.0, 0.1, damage)
		is_attacked = true
