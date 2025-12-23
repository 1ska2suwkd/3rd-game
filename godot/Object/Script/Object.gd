extends Area2D


var is_destroy: bool = false
@export var Use_Directional: bool = false
@export var HP: int = 1
@export var DESTROY_PARTICLE: PackedScene

@onready var Sprite := $Sprite2D


func _on_hit_flash_timer_timeout() -> void:
	Sprite.modulate = Color(1, 1, 1, 1)

func take_damage(p_damage:int):
	if is_destroy: return
	
	Sprite.modulate = Color(18.892, 18.892, 18.892)
	$HitFlashTimer.start()
	HP -= p_damage
	if HP <= 0:
		call_deferred("destroy")

func destroy():
	if is_destroy: return
	is_destroy = true
	$CollisionShape2D.set_deferred("disabled", true)
	
	
	var ysort = get_tree().current_scene.get_node("Ysort")
	var particle = DESTROY_PARTICLE.instantiate()
	particle.global_position = global_position
	particle.emitting = true
	
	
	if Use_Directional:
		get_direction(particle)
	
	if ysort:
		ysort.add_child(particle)
	else:
		push_warning("⚠️ YSort 노드를 찾을 수 없습니다. current_scene에 직접 추가합니다.")
		get_tree().current_scene.add_child(particle)
	
	queue_free()

func get_direction(particle):
	particle.process_material = particle.process_material.duplicate()
	var player = get_tree().get_first_node_in_group("player")
	# 2. 플레이어로부터 나(잔디)로 향하는 방향 벡터를 구합니다.
	# (나 - 플레이어)를 해야 내가 튕겨 나가는 방향이 나옵니다.
	var bounce_dir = (global_position - player.global_position).normalized()
		
	# 3. 파티클의 방향을 이 벡터로 설정 (Vector3로 변환)
	# 이렇게 하면 상하좌우+대각선 모든 각도가 완벽하게 반영됩니다.
	particle.process_material.direction = Vector3(bounce_dir.x, bounce_dir.y, 0)
	
	# 4. 퍼짐(Spread)을 조금 주면 더 풍성해집니다.
	particle.restart()
	particle.emitting = true
