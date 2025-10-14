extends Area2D

@export var target: Node2D
var damage: int = 0
var overlapping_bodies: Array = []


func _ready() -> void:
	$AnimatedSprite2D.play("Projectile")
	

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") :
		overlapping_bodies.append(body)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		overlapping_bodies.erase(body)


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "Projectile":
		$AnimatedSprite2D.play("Explosion")

		# 폭발 시작 시점에 한 번만 데미지 적용
		for body in overlapping_bodies:
			if is_instance_valid(body):
				body.apply_knockback(global_position, 1000.0, 0.1, damage)
				
	elif $AnimatedSprite2D.animation == "Explosion":
		queue_free()
