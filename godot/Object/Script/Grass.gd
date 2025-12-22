extends Area2D


var stat: Stat = null

var dead: bool = false


@onready var Sprite := $Sprite2D

func _ready() -> void:
	if not stat:
		init_stat()

func init_stat(p_speed: int = 350, p_hp: int = 1, p_damage: int = 1):
	stat = Stat.new(p_speed, p_hp, p_damage)
	dead = false



func take_damage(p_damage:int):
	if dead: return
	
	stat.hp -= p_damage
	if stat.hp <= 0:
		call_deferred("die")

func _on_area_2d_area_entered(area):
	if area.is_in_group("Player_attack") and not dead:
		take_damage(PlayerStat.TotalDamage)


func die():
	var player = get_tree().get_first_node_in_group("player")
	var ysort = get_tree().current_scene.get_node("Ysort")
	if dead: return

	dead = true
	
	var particle = preload("res://Particle/GrassParticle.tscn").instantiate()
	particle.process_material = particle.process_material.duplicate()
	particle.global_position = global_position
	
	if player:
		# 2. 플레이어로부터 나(잔디)로 향하는 방향 벡터를 구합니다.
		# (나 - 플레이어)를 해야 내가 튕겨 나가는 방향이 나옵니다.
		var bounce_dir = (global_position - player.global_position).normalized()
			
		# 3. 파티클의 방향을 이 벡터로 설정 (Vector3로 변환)
		# 이렇게 하면 상하좌우+대각선 모든 각도가 완벽하게 반영됩니다.
		particle.process_material.direction = Vector3(bounce_dir.x, bounce_dir.y, 0)
		
		# 4. 퍼짐(Spread)을 조금 주면 더 풍성해집니다.
		particle.restart()
		particle.emitting = true
		
	if ysort:
		ysort.add_child(particle)
	else:
		push_warning("⚠️ YSort 노드를 찾을 수 없습니다. current_scene에 직접 추가합니다.")
		get_tree().current_scene.add_child(particle)
	
		
	queue_free()
	
