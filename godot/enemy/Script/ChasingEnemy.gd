extends "res://enemy/Script/BaseEnemy.gd"

func _physics_process(_delta: float) -> void:
	super._physics_process(_delta)
	
	if not is_attack:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		if player_chase and player:
			velocity = dir * stat.speed
		
		if velocity.length() > 1.0 :
			$AnimatedSprite2D.play("walk")
			if abs(velocity.x) > 1.0: # 임계점 설정
				$AnimatedSprite2D.flip_h = velocity.x < 0
		else:
			$AnimatedSprite2D.play("idle")
