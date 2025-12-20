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


func _on_hit_flash_timer_timeout() -> void:
	Sprite.modulate = Color(1, 1, 1, 1)

func take_damage(p_damage:int):
	if dead: return
	
	Sprite.modulate = Color(18.892, 18.892, 18.892)
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
	
	var to_player = player.global_position - global_position
	
	var particle = preload("res://Particle/GrassParticle.tscn").instantiate()
	particle.global_position = global_position
	particle.emitting = true
	
	if abs(to_player.x) > abs(to_player.y):
		if to_player.x > 0:
			particle.process_material.direction = Vector3(-1,0,0)
		else:
			particle.process_material.direction = Vector3(1,0,0)
	else:
		if to_player.y > 0:
			particle.process_material.direction = Vector3(0,-1,0)
		else:
			particle.process_material.direction = Vector3(0,1,0)

	
	if ysort:
		ysort.add_child(particle)
	else:
		push_warning("⚠️ YSort 노드를 찾을 수 없습니다. current_scene에 직접 추가합니다.")
		get_tree().current_scene.add_child(particle)
	
		
	queue_free()
	
#func _do_attack():
	#PlayerStat.attacking = true
	#var mouse_pos = get_global_mouse_position()
	#var to_mouse = mouse_pos - global_position
	#
	#if abs(to_mouse.x) > abs(to_mouse.y):
		#attackDir = "right" if to_mouse.x > 0 else "left"
	#else:
		#attackDir = "down" if to_mouse.y > 0 else "up"
	#
	#if attackDir == "left":
		#$AnimatedSprite2D.flip_h = true
	#elif attackDir == "right":
		#$AnimatedSprite2D.flip_h = false
	#
	#$AnimatedSprite2D.play(attackDir + "_attack" + combo)
