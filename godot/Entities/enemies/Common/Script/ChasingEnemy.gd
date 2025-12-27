extends "res://enemy/Script/BaseEnemy.gd"

@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

func _physics_process(_delta: float) -> void:
	super._physics_process(_delta)
	
	if not is_attack:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		if player_chase and player:
			velocity = dir * stat.speed
		
		if velocity.length() > 1.0 :
			$AnimatedSprite2D.play("walk")
			if abs(velocity.x) > 1.0: # 임계점 설정
				$AnimatedSprite2D.flip_h = velocity.x < 0
		else:
			$AnimatedSprite2D.play("idle")

func makepath() -> void: #플레이어를 찾기위한 경로탐색 함수?
	nav_agent.target_position = player.global_position

func _on_start_move_timeout() -> void:
	$Pathfinding.start()

func _on_pathfinding_timeout() -> void:
	makepath()
