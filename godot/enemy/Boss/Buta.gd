
extends CharacterBody2D

var stat: Stat

var dead = false
var player_chase = false
var is_attack = false
var is_dash = false
var dash_dir := Vector2.ZERO
var _dash_t := 0.0
var dash_speed = 500
var accel_rate = 300.0
var current_speed = 0

@export var player: Node2D

@onready var anim = $AnimatedSprite2D.animation
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D
@onready var healthbar = $백성우/Healthbar

func _ready():
	stat = Stat.new(300, 50, 1) # speed, hp, damage
	$cooldown.start()
	healthbar.init_health(stat.hp)
	
	
func _physics_process(_delta: float) -> void:
	if dead: return
	
	if is_dash:
		_dash_t += _delta
		velocity = dash_dir * dash_speed
		move_and_slide()
	elif not is_attack:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		if player_chase and player:
			current_speed = min(current_speed + accel_rate * _delta, stat.speed)
			velocity = dir * current_speed
		move_and_slide()  # ← 물리 이동 (충돌 적용)
		
		if velocity.length() > 1.0 :
			$AnimatedSprite2D.play("walk")
			if abs(velocity.x) > 1.0: # 임계점 설정
				$AnimatedSprite2D.flip_h = velocity.x < 0
		else:
			$AnimatedSprite2D.play("idle")

func take_damage(p_damage:int):
	stat.hp -= p_damage
	if stat.hp <= 0:
		die()

func makepath() -> void: #플레이어를 찾기위한 경로탐색 함수?
	nav_agent.target_position = player.global_position

func _on_pathfinding_timeout() -> void:
	makepath()

func _on_area_2d_area_entered(area):
	if area.is_in_group("Player_attack") and not dead:
		$AnimatedSprite2D.modulate = Color(0.847, 0.0, 0.102)
		take_damage(PlayerStat.damage)
		healthbar.health = stat.hp

func _on_area_2d_area_exited(area):
	if area.is_in_group("Player_attack"):
		$AnimatedSprite2D.modulate = Color(1.0, 1.0, 1.0, 1.0)

func _on_detection_area_body_entered(body):
	if body.is_in_group("player"):
		player = body
		player_chase = true

func _on_detection_area_body_exited(body):
	if body.is_in_group("player"):
		#player = null
		player_chase = false

func _on_cooldown_timeout():
	if not is_attack and not dead:
		is_attack = true
		$AnimatedSprite2D.play("windup")
		dash_dir = (player.global_position - global_position).normalized()
		$windup.start()

func _on_windup_timeout():
	is_dash = true
	_dash_t = 0.0
	play_n_times("attack", 3)

func play_n_times(anim_name: String, n: int) -> void:
	for i in range(n):
		if dead:  
			return
		$AnimatedSprite2D.play(anim_name)
		await $AnimatedSprite2D.animation_finished
	is_dash = false
	for i in range(n):
		if dead:  
			return
		current_speed = 0 
		$AnimatedSprite2D.play("recover")
		await $AnimatedSprite2D.animation_finished
	is_attack = false
	$cooldown.start()

func _on_animated_sprite_2d_animation_changed() -> void:
	if $AnimatedSprite2D.animation == "attack":
		$Attack_hitbox/attack_hitbox.disabled = false
	else:
		$Attack_hitbox/attack_hitbox.set_deferred("disabled", true)

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.apply_knockback(global_position, 1000.0, 0.5, stat.damage)
		
func _on_contact_damage_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not is_attack and not dead:
		body.apply_knockback(global_position, 1000.0, 0.2, stat.damage)
	

func die():
	if dead: return
	
	dead = true
	is_attack = false
	is_dash = false
	player_chase = false
	velocity = Vector2.ZERO
	
	$cooldown.stop()
	$windup.stop()
	
	$AnimatedSprite2D.play("dead")
