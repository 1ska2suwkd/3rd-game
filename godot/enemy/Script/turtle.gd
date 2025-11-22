extends "res://enemy/Script/WanderingEnemy.gd"

const BASE_DASH_SPEED := 500
var dash_speed = BASE_DASH_SPEED
var is_dash = false
var dash_dir := Vector2.ZERO
var _dash_t := 0.0


var restitution := 0.8 # 튕겼을 때 속도 감소량

func _ready() -> void:
	init_stat(100, 5, 1)
	

func _physics_process(_delta: float) -> void:
	super._physics_process(_delta)
	
	if is_dash:
		_dash_t += _delta
		velocity = dash_dir * dash_speed
		
		var col = move_and_collide(velocity * _delta)
		if col:
			var n = col.get_normal().normalized()
			# 반사
			velocity = velocity - 2 * velocity.dot(n) * n
			velocity *= restitution
			# 반사된 방향을 새로운 대시 방향으로 업데이트
			dash_dir = velocity.normalized()
			# 대시 속도도 현재 속도로 동기화
			dash_speed = velocity.length()


func _on_guard_in_timeout() -> void:
	is_dash = true
	_dash_t = 0.0


func _on_cooldown_timeout() -> void:
	if not is_attack and not dead and not player == null:
		is_attack = true
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("guard_in")
		dash_dir = (player.global_position - global_position).normalized()


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "guard_in":
		is_dash = true
		_dash_t = 0.0
		$Attack_Duration.start()		
	#elif $AnimatedSprite2D.animation == "guard_out":
		

func _on_attack_duration_timeout() -> void:
		is_dash = false
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("guard_out")
		await $AnimatedSprite2D.animation_finished
		is_attack = false
		
		dash_speed = BASE_DASH_SPEED
		$cooldown.start()
	
