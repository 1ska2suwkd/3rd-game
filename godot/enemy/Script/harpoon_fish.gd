extends "res://enemy/Script/WanderingEnemy.gd"

func _ready() -> void:
	init_stat(100, 3, 1)


func _on_attack_timeout() -> void:
	if not player == null:
		is_attack = true
		velocity = Vector2.ZERO
		if player.global_position.x < global_position.x:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		
		$AnimatedSprite2D.play("attack")


func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "attack":
		if $AnimatedSprite2D.frame == 4:
			attack()


func attack():
	var projectile = preload("res://projectiles/Harpoon.tscn").instantiate()
	projectile.global_position = global_position
	projectile.target = player
	projectile.damage = stat.damage
	get_tree().current_scene.add_child(projectile)
	

func _on_animated_sprite_2d_animation_finished() -> void:
	is_attack = false
