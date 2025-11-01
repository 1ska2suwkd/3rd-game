extends Area2D

@export var target: Node2D
var damage: int = 0
var overlapping_bodies: Array = []
var is_attacked = false


func _ready() -> void:
	$AnimatedSprite2D.play("Projectile")

func _physics_process(_delta: float) -> void:
	if overlapping_bodies and $AnimatedSprite2D.animation == "Explosion" and not is_attacked:
		is_attacked = true
		overlapping_bodies[0].apply_knockback(global_position, 1000.0, 0.1, damage)
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") :
		overlapping_bodies.append(body)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		overlapping_bodies.erase(body)


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "Projectile":
		$AnimatedSprite2D.play("Explosion")
	elif $AnimatedSprite2D.animation == "Explosion":
		queue_free()


func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "Explosion" and $AnimatedSprite2D.frame == 4:
		$CollisionShape2D.disabled = true
