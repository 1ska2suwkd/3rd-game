extends "res://enemy/Script/FleeingEnemy.gd"

func _ready() -> void:
	randomize()
	start_random_timer()
	init_stat(100, 3, 1)
	
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
	var projectile = preload("res://projectlies/Shaman_Projectile.tscn").instantiate()
	projectile.target = player
	projectile.global_position = projectile.target.global_position
	projectile.damage = stat.damage
	get_tree().current_scene.add_child(projectile)
	

func _on_animated_sprite_2d_animation_finished() -> void:
	is_attack = false
	start_random_timer()
