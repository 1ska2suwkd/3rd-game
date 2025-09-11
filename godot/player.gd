extends CharacterBody2D

@export var speed := 400.0

func _physics_process(delta):
	var dir := Vector2.ZERO
	if Input.is_action_pressed("move_up"):
		dir.y -= 1
	if Input.is_action_pressed("move_down"):
		dir.y += 1
	if Input.is_action_pressed("move_left"):
		dir.x -= 1
	if Input.is_action_pressed("move_right"):
		dir.x += 1

	# 방향 벡터 정규화 후 속도 적용
	if dir != Vector2.ZERO:
		velocity = dir.normalized() * speed
		$AnimatedSprite2D.play("walk")
		if velocity.x < 0:
			$AnimatedSprite2D.flip_h = true
		elif velocity.x > 0:
			$AnimatedSprite2D.flip_h = false
	else:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("idle")

	# ❗ 충돌 계산 포함된 이동
	move_and_slide()
