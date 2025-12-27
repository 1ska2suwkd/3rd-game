extends "res://Entities/enemies/Common/Script/BaseEnemy.gd"
# Skull이 BaseEnemy를 쓰는 이유는 공격 히트박스의 scale.x 변경을 위함

@export var SkullStat: EnemyStat 

@export var detection_area: DetectionComponent
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

func _ready() -> void:
	$Components/ContactDamage.stats = SkullStat


func _physics_process(_delta: float) -> void:
	super._physics_process(_delta)
	
	if not is_attack:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		if detection_area.player_chase and detection_area.player:
			velocity = dir * SkullStat.speed
		
		if velocity.length() > 1.0 :
			$AnimatedSprite2D.play("walk")
			if abs(velocity.x) > 1.0: # 임계점 설정
				if velocity.x < 0:
					$AnimatedSprite2D.flip_h = true
					$Attack_hitbox.scale.x = -1
				else:
					$AnimatedSprite2D.flip_h = false
					$Attack_hitbox.scale.x = 1
					
		else:
			$AnimatedSprite2D.play("idle")
	else:
		velocity = Vector2.ZERO


func _on_attack_detection_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		is_attack = true
		$AnimatedSprite2D.play("attack")


func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "attack":
		if $AnimatedSprite2D.frame == 2:
			$Attack_hitbox/attack_hitbox.disabled = false


func _on_animated_sprite_2d_animation_finished() -> void:
	is_attack = false
	$Attack_hitbox/attack_hitbox.disabled = true
	

func _on_attack_hitbox_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("player"):
		var target = area.owner
		target.apply_knockback(global_position, 1000.0, 0.5, SkullStat.damage)


func makepath() -> void: #플레이어를 찾기위한 경로탐색 함수?
	nav_agent.target_position = player.global_position

func _on_start_move_timeout() -> void:
	$Pathfinding.start()

func _on_pathfinding_timeout() -> void:
	makepath()
