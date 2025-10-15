extends CharacterBody2D


var stat: Stat = null

var dead: bool = false
var player_chase: bool = false
var is_attack: bool = false
var knockback_vel: Vector2 = Vector2.ZERO
var knockback_time := 0.0 

@export var player: Node2D

@onready var anim_sprite := $AnimatedSprite2D

func _ready() -> void:
	if not stat:
		init_stat()

func init_stat(p_speed: int = 350, p_hp: int = 4, p_damage: int = 1):
	stat = Stat.new(p_speed, p_hp, p_damage)
	dead = false

func _physics_process(_delta: float) -> void:
	if dead: return
	
	if knockback_time > 0.0:
		# 넉백 중: 입력 무시하고 넉백 속도 적용 + 감속
		velocity = knockback_vel
		knockback_vel = knockback_vel.move_toward(Vector2.ZERO, 3000.0 * _delta)  # 감속량 조절
		knockback_time -= _delta

			
	move_and_slide()
			
func apply_knockback(from: Vector2, strength: float = 500.0, duration: float = 0.15) -> void:
	if dead: return
	
	var dir := (global_position - from).normalized()
	knockback_vel = dir * strength
	knockback_time = duration
	

func take_damage(p_damage:int, from: Vector2):
	apply_knockback(from, 500.0, 0.15)
	
	stat.hp -= p_damage
	$AnimatedSprite2D.modulate = Color(0.847, 0.0, 0.102)
	if stat.hp <= 0:
		die()
		

func _on_area_2d_area_entered(area):
	if area.is_in_group("Player_attack") and not dead:
		take_damage(PlayerStat.damage, player.global_position)

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
		

func _on_contact_damage_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") and not dead:
		body.apply_knockback(global_position, 1000.0, 0.2, stat.damage)
		
		
func find_parent_room() -> Node:
	var current = get_parent()
	while current:
		if current is Node2D and current.has_method("check_enemies"):
			return current
		current = current.get_parent()
	return null
		

func die():
	if dead: return
	
	dead = true
	is_attack = false
	player_chase = false
	velocity = Vector2.ZERO
	
	if is_in_group("enemy"):
		remove_from_group("enemy") # queue_free는 다음 프레임의 삭제하기 때문에 그룹에서 직접 제거
	
	var room = find_parent_room()
	if room:
		room.call_deferred("check_enemies")
		
	queue_free()
