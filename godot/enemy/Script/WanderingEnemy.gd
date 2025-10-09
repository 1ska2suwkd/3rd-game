extends "res://enemy/Script/BaseEnemy.gd"

var wander_dir := Vector2.ZERO
var wander_timer := 0.0

func _physics_process(_delta: float) -> void:
	super._physics_process(_delta)
	
	if not is_attack:
		wander_timer -= _delta
		if wander_timer <= 0.0:
			# 새 방향 선택 (랜덤)
			var angle = randf_range(0, PI*2)
			wander_dir = Vector2(cos(angle), sin(angle)).normalized()
			wander_timer = randf_range(1.0, 3.0)  # 1~3초마다 방향 바꿈
		
		# 속도 적용
		velocity = wander_dir * stat.speed
		
		# 애니메이션
		if velocity.length() > 0.1:
			$AnimatedSprite2D.play("walk")
			$AnimatedSprite2D.flip_h = velocity.x < 0
		else:
			$AnimatedSprite2D.play("idle")
