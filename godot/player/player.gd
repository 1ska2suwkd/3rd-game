# player.gd
extends CharacterBody2D

var stat: PlayerStat
var attacking := false
# 공격하면서 이동 시 이동속도 감소
var slow = 1
var combo = "1"

const DEFAULT_SPEED = 400
const DEFAULT_HP = 6
const DEFAULT_DAMAGE = 2
const DEFAULT_ATTACK_SPEED = 1.0

var speed := DEFAULT_SPEED
var damage := DEFAULT_DAMAGE
var attack_speed := DEFAULT_ATTACK_SPEED


func _ready():
	stat = PlayerStat.new(DEFAULT_SPEED, DEFAULT_DAMAGE, DEFAULT_HP,DEFAULT_ATTACK_SPEED) 
	$AnimatedSprite2D.animation_finished.connect(_on_anim_finished)
	attack_speed = 4.0

func _process(delta):
	if(speed != DEFAULT_SPEED):
		stat.update_speed(speed)
	if(damage != DEFAULT_DAMAGE):
		stat.update_damage(damage)
	if(attack_speed != DEFAULT_ATTACK_SPEED):
		stat.update_attack_speed(attack_speed)
		if $AnimatedSprite2D.animation == "idle" or $AnimatedSprite2D.animation == "walk":
			$AnimatedSprite2D.speed_scale = DEFAULT_ATTACK_SPEED
		else:
			$AnimatedSprite2D.speed_scale = attack_speed
	
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
	
	if attacking:
		slow = 0.7
	# 방향 벡터 정규화 후 속도 적용
	if dir != Vector2.ZERO:
		velocity = dir.normalized() * stat.speed * slow
		if not attacking:
			$AnimatedSprite2D.play("walk")
			if velocity.x < 0:
				$AnimatedSprite2D.flip_h = true
			elif velocity.x > 0:
				$AnimatedSprite2D.flip_h = false
	else:
		velocity = Vector2.ZERO
		if not attacking:
			$AnimatedSprite2D.play("idle")
		
	if Input.is_action_pressed("attack") and not attacking:
		_do_attack()
		
	# 충돌 계산 포함된 이동
	move_and_slide()
	
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
		$AnimatedSprite2D.play(dir + "_attack" + combo)
	elif dir == "right" :
		$AnimatedSprite2D.flip_h = false
		$AnimatedSprite2D.play(dir + "_attack" + combo)
	else:
		$AnimatedSprite2D.play(dir + "_attack" + combo)
	
func _on_anim_finished():
	if $AnimatedSprite2D.animation.ends_with("_attack" + combo):
		attacking = false
		slow = 1
		if combo == "1":
			combo = "2"
		else:
			combo = "1"
