extends CharacterBody2D

var dead: bool = false
var is_attack: bool = false
var knockback_vel: Vector2 = Vector2.ZERO
var knockback_time := 0.0 

@export var player: Node2D

@onready var anim_sprite := $AnimatedSprite2D


func _physics_process(_delta: float) -> void:
	if dead: return
	
	if knockback_time > 0.0:
		# 넉백 중: 입력 무시하고 넉백 속도 적용 + 감속
		velocity = knockback_vel
		knockback_vel = knockback_vel.move_toward(Vector2.ZERO, 2000.0 * _delta)  # 감속량 조절
		knockback_time -= _delta

			
	move_and_slide()
			
func apply_knockback(from: Vector2, strength: float = 1000.0, duration: float = 0.1) -> void:
	if dead: return
	
	var dir := (global_position - from).normalized()
	knockback_vel = dir * strength
	knockback_time = duration

	

func _on_hit_flash_timer_timeout() -> void:
	$AnimatedSprite2D.modulate = Color(1, 1, 1, 1)



func _on_area_2d_area_entered(area):
	if area.is_in_group("Player_attack") and not dead:
		take_damage(PlayerStat.TotalDamage)


func _on_contact_damage_area_entered(area: Area2D) -> void:
	if area.owner.is_in_group("player") and not dead:
		var target = area.owner
		#target.apply_knockback(global_position, 1000.0, 0.1, stat.damage)
		
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
	velocity = Vector2.ZERO
	
	if is_in_group("enemy"):
		remove_from_group("enemy") # queue_free는 다음 프레임의 삭제하기 때문에 그룹에서 직접 제거
	
	var room = find_parent_room()
	if room:
		room.call_deferred("check_enemies")
		
	var ysort = get_tree().current_scene.get_node("Ysort")
	var particle = preload("res://Particle/EnemyDeadParticle.tscn").instantiate()
	particle.global_position = global_position
	particle.emitting = true
	
	if ysort:
		ysort.add_child(particle)
	else:
		push_warning("⚠️ YSort 노드를 찾을 수 없습니다. current_scene에 직접 추가합니다.")
		get_tree().current_scene.add_child(particle)
	
	if global.random_number_generator.randf() < 0.5:
		var gold = preload("res://PickUp/gold.tscn").instantiate()
		gold.global_position = global_position
		
		if ysort:
			ysort.add_child(gold)
		else:
			push_warning("⚠️ YSort 노드를 찾을 수 없습니다. current_scene에 직접 추가합니다.")
			get_tree().current_scene.add_child(gold)
		
	queue_free()
	
