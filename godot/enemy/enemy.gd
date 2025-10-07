extends CharacterBody2D


# 공통 데이터
var stat: Stat = null

var dead: bool = false
var player_chase: bool = false
var is_attack: bool = false

@export var player: Node2D

@onready var anim_sprite := $AnimatedSprite2D
@onready var nav_agent := $NavigationAgent2D as NavigationAgent2D

func _ready() -> void:
	if not stat:
		init_stat()

func init_stat(p_speed: int = 350, p_hp: int = 4, p_damage: int = 1):
	stat = Stat.new(p_speed, p_hp, p_damage)
	dead = false

func _physics_process(_delta: float) -> void:
	if dead: return
	
	if not is_attack:
		var dir = to_local(nav_agent.get_next_path_position()).normalized()
		if player_chase and player:
			velocity = dir * stat.speed
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

func _on_start_move_timeout() -> void:
	$Pathfinding.start()

func _on_pathfinding_timeout() -> void:
	makepath()

func _on_area_2d_area_entered(area):
	if area.is_in_group("Player_attack") and not dead:
		$AnimatedSprite2D.modulate = Color(0.847, 0.0, 0.102)
		take_damage(PlayerStat.damage)

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
	player_chase = false
	velocity = Vector2.ZERO
	
	
	$AnimatedSprite2D.play("dead")
