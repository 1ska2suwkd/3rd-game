extends Area2D

func _ready() -> void:
	$AnimatedSprite2D.play("spawn")
	await $AnimatedSprite2D.animation_finished
	
	$CollisionShape2D.disabled = false

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		PlayerStat.set_gold(1)
		queue_free()
