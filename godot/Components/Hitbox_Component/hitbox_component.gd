extends Area2D

@onready var AnimationSprite = $"../../AnimatedSprite2D"


func take_damage():
	AnimationSprite = Color(0.847, 0.0, 0.102)
	$HitFlashTimer.start()
	
	
	

func _on_hit_flash_timer_timeout() -> void:
	AnimationSprite = Color(1.0, 1.0, 1.0, 1.0)
