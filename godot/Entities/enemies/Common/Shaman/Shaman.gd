extends CharacterBody2D

@export var player: CharacterBody2D

var is_attack = false

func _ready() -> void:
	randomize()
	start_random_timer()
	
func start_random_timer() -> void:
	$attack.wait_time = randf_range(1.0, 3.0)
	$attack.start()

func _on_attack_timeout() -> void:
	is_attack = true
	velocity = Vector2.ZERO
	if player.global_position.x < global_position.x:
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.flip_h = false
		
	$AnimatedSprite2D.play("attack")


func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "attack":
		if $AnimatedSprite2D.frame == 5:
			attack()


func attack():
	var projectile = preload("res://projectiles/Shaman_Projectile.tscn").instantiate()
	projectile.target = player
	projectile.global_position = projectile.target.global_position
	projectile.damage = stat.damage
	# 현재 씬에서 YSort 노드 찾기
	var ysort = get_tree().current_scene.get_node("Ysort")

	if ysort:
		ysort.add_child(projectile)
	else:
		push_warning("⚠️ YSort 노드를 찾을 수 없습니다. current_scene에 직접 추가합니다.")
		get_tree().current_scene.add_child(projectile)
	

func _on_animated_sprite_2d_animation_finished() -> void:
	is_attack = false
	start_random_timer()
