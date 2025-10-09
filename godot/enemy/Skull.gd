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
				if velocity.x < 0:
					$AnimatedSprite2D.flip_h = true
					$Attack_hitbox.scale.x = -1
				else:
					$AnimatedSprite2D.flip_h = false
					$Attack_hitbox.scale.x = 1
					
		else:
			$AnimatedSprite2D.play("idle")
	else:
		velocity = Vector2.ZERO


func _on_attack_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_attack = true
		$AnimatedSprite2D.play("attack")


func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "attack":
		if $AnimatedSprite2D.frame == 2:
			$Attack_hitbox/attack_hitbox.disabled = false


func _on_animated_sprite_2d_animation_finished() -> void:
	is_attack = false
	$Attack_hitbox/attack_hitbox.disabled = true
	
func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.apply_knockback(global_position, 1000.0, 0.5, stat.damage)
