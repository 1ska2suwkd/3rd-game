extends CharacterBody2D

@export var speed := 400.0
var attacking := false

func _ready():
	$AnimatedSprite2D.animation_finished.connect(_on_anim_finished)

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

	if not attacking:
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
	else:
		velocity = Vector2.ZERO
		

	# 충돌 계산 포함된 이동
	move_and_slide()

func _input(event):
	if event.is_action_pressed("attack") and not attacking:
		_do_attack()
	
func _do_attack():
	attacking = true
	var mouse_pos = get_global_mouse_position()
	var to_mouse = mouse_pos - global_position
	var dir = ""
	
	if abs(to_mouse.x) > abs(to_mouse.y):
		dir = "right" if to_mouse.x > 0 else "left"
	else:
		dir = "down" if to_mouse.y > 0 else "up"
		
	if dir == "left" :
		$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play(dir + "_attack1")
	elif dir == "right" :
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play(dir + "_attack1")
	else:
		$AnimatedSprite2D.play(dir + "_attack1")
	
func _on_anim_finished():
	if $AnimatedSprite2D.animation.ends_with("_attack1"):
		attacking = false
