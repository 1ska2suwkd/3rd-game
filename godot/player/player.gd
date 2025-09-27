# player.gd
extends CharacterBody2D

var stat: PlayerStat
var attacking := false
# 공격하면서 이동 시 이동속도 감소
var slow = 1
var combo = "1"
var attackDir = ""
var hit_active_token := 0

const DEFAULT_SPEED = 400
const DEFAULT_HP = 6
const DEFAULT_DAMAGE = 1
const DEFAULT_ATTACK_SPEED = 1.0

@export var speed := DEFAULT_SPEED
@export var damage := DEFAULT_DAMAGE
@export var attack_speed := DEFAULT_ATTACK_SPEED

@onready var up_hit: CollisionShape2D = $AttackCollision/UpAttack
@onready var down_hit: CollisionShape2D = $AttackCollision/DownAttack
@onready var right_hit: CollisionShape2D = $AttackCollision/RightAttack
@onready var left_hit: CollisionShape2D = $AttackCollision/LeftAttack

func _ready():
	stat = PlayerStat.new() 
	$AnimatedSprite2D.animation_finished.connect(_on_anim_finished)

func _process(_delta):
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
	
func _physics_process(_delta):
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
	
	if abs(to_mouse.x) > abs(to_mouse.y):
		attackDir = "right" if to_mouse.x > 0 else "left"
	else:
		attackDir = "down" if to_mouse.y > 0 else "up"
	
	if attackDir == "left":
		$AnimatedSprite2D.flip_h = true
	elif attackDir == "right":
		$AnimatedSprite2D.flip_h = false
	
	$AnimatedSprite2D.play(attackDir + "_attack" + combo)
	
func _on_anim_finished():
		attacking = false
		slow = 1
		if combo == "1":
			combo = "2"
		else:
			combo = "1"

func _on_animated_sprite_2d_frame_changed():
	var anim = $AnimatedSprite2D.animation
	var frame = $AnimatedSprite2D.frame
	
	if anim == "up_attack1" or anim == "up_attack2":
		if frame == 3:  # 타격 시작 프레임
			$AttackCollision/UpAttack.disabled = false
		elif frame == 5:  # 타격 종료 프레임
			$AttackCollision/UpAttack.disabled = true
	elif anim == "down_attack1" or anim == "down_attack2":
		if frame == 3:  # 타격 시작 프레임
			$AttackCollision/DownAttack.disabled = false
		elif frame == 5:  # 타격 종료 프레임
			$AttackCollision/DownAttack.disabled = true
	elif anim == "left_attack1" or anim == "left_attack2":
		if frame == 3:  # 타격 시작 프레임
			$AttackCollision/LeftAttack.disabled = false
		elif frame == 5:  # 타격 종료 프레임
			$AttackCollision/LeftAttack.disabled = true
	elif anim == "right_attack1" or anim == "right_attack2":
		if frame == 3:  # 타격 시작 프레임
			$AttackCollision/RightAttack.disabled = false
		elif frame == 5:  # 타격 종료 프레임
			$AttackCollision/RightAttack.disabled = true
