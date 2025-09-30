extends CharacterBody2D

var stat: Stat
var playerstat : PlayerStat

var player_chase = false
var player = null

var is_attack = false
var is_dash = false
var dash_dir := Vector2.ZERO
var _dash_t := 0.0
var dash_speed = 400

var _dead_handled := false

@onready var anim = $AnimatedSprite2D.animation
@onready var frame = $AnimatedSprite2D.frame

func _ready():
	stat = Stat.new(300, 10, 1) # speed, hp, damage
	$cooldown.start()
	
func _physics_process(_delta):
	if stat.dead: return
	
	if is_dash:
		_dash_t += _delta
		velocity = dash_dir * dash_speed
		move_and_slide()
	elif not is_attack:
		var dir := Vector2.ZERO
		if player_chase and player and not is_attack:
			dir = (player.global_position - global_position).normalized()
		velocity = dir * stat.speed
		move_and_slide()  # ← 물리 이동 (충돌 적용)
		
		if velocity.length() > 1.0 :
			$AnimatedSprite2D.play("walk")
			if abs(velocity.x) > 1.0: # 임계점 설정
				$AnimatedSprite2D.flip_h = velocity.x < 0

func _on_area_2d_area_entered(area):
	if area.is_in_group("Player_attack") and not stat.dead:
		$AnimatedSprite2D.modulate = Color(0.847, 0.0, 0.102)
		playerstat = PlayerStat.new()
		stat.take_damage(playerstat.damage)
		if stat.dead:
			die()

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
	if not is_attack and not stat.dead:
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
		if stat.dead:  
			return
		$AnimatedSprite2D.play(anim_name)
		await $AnimatedSprite2D.animation_finished
	is_dash = false
	for i in range(n):
		if stat.dead:  
			return
		velocity = Vector2.ZERO
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

func die():
	if _dead_handled: return
	_dead_handled = true
	
	stat.dead = true
	is_attack = false
	is_dash = false
	player_chase = false
	velocity = Vector2.ZERO
	
	$cooldown.stop()
	$windup.stop()
	
	$AnimatedSprite2D.play("dead")
