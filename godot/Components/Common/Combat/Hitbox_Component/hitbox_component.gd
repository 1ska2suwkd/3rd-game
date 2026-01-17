extends Area2D
class_name HitboxComponent

@onready var AnimationSprite = $"../../AnimatedSprite2D"
@export var health_component: HealthComponent
@export var knockback_component: KnockbackComponent


func take_damage(p_damage, player_position):
	AnimationSprite.modulate = Color(0.847, 0.0, 0.102)
	$HitFlashTimer.start()
	
	health_component.damage(p_damage)
	knockback_component.apply_knockback(player_position)

func _on_hit_flash_timer_timeout() -> void:
	AnimationSprite.modulate = Color(1.0, 1.0, 1.0, 1.0)
