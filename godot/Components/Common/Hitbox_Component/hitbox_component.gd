extends Area2D

@onready var AnimationSprite = $"../../AnimatedSprite2D"
@export var health_component: HealthComponent


func take_damage(p_damage):
	AnimationSprite.modulate = Color(0.847, 0.0, 0.102)
	$HitFlashTimer.start()
	
	health_component.damage(p_damage)
	

func _on_hit_flash_timer_timeout() -> void:
	AnimationSprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
