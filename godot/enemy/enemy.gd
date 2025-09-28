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

@onready var anim = $AnimatedSprite2D.animation
@onready var frame = $AnimatedSprite2D.frame

func _ready():
	stat = Stat.new(200, 10, 1) # speed, hp, damage
	$cooldown.start()
	
func _physics_process(_delta):
	if is_dash:
		_dash_t += _delta
		velocity = dash_dir * dash_speed
		move_and_slide()
	else:
		var dir := Vector2.ZERO
		if player_chase and player and not is_attack:
			dir = (player.global_position - global_position).normalized()
		velocity = dir * stat.speed
		move_and_slide()  # ← 물리 이동 (충돌 적용)
		
	if velocity.length() > 1.0 :
		if not is_dash:
			$AnimatedSprite2D.play("walk")
		$AnimatedSprite2D.flip_h = velocity.x < 0
	elif not is_attack:
		$AnimatedSprite2D.play("idle")

func _on_area_2d_area_entered(area):
	if area.is_in_group("Player_attack"):
		$AnimatedSprite2D.modulate = Color(0.847, 0.0, 0.102)
		playerstat = PlayerStat.new()
		stat.take_damage(playerstat.damage)
		if stat.dead:
			queue_free()# Replace with function body.

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
	if not is_attack:
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
		$AnimatedSprite2D.play(anim_name)
		await $AnimatedSprite2D.animation_finished
	is_dash = false
	for i in range(n):
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("recover")
		await $AnimatedSprite2D.animation_finished
	is_attack = false
	$cooldown.start()

func _on_animated_sprite_2d_animation_changed() -> void:
	if $AnimatedSprite2D.animation == "attack":
		$Attack_hitbox/attack_hitbox.disabled = false
	else:
		$Attack_hitbox/attack_hitbox.disabled = true

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.apply_knockback(global_position, 1000.0, 0.5, stat.damage)
