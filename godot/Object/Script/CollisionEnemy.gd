extends Area2D


var stat: Stat = null

var dead: bool = false

@export var player: Node2D

@onready var Sprite := $Sprite2D

func _ready() -> void:
	if not stat:
		init_stat()

func init_stat(p_speed: int = 350, p_hp: int = 30, p_damage: int = 1):
	stat = Stat.new(p_speed, p_hp, p_damage)
	dead = false


func _on_hit_flash_timer_timeout() -> void:
	Sprite.modulate = Color(1, 1, 1, 1)

func take_damage(p_damage:int):
	if dead: return
	
	Sprite.modulate = Color(18.892, 18.892, 18.892)
	$HitFlashTimer.start()
	stat.hp -= p_damage
	if stat.hp <= 0:
		call_deferred("die")

func _on_area_2d_area_entered(area):
	if area.is_in_group("Player_attack") and not dead:
		take_damage(PlayerStat.TotalDamage)


func die():
	if dead: return
	
	dead = true
	
	if is_in_group("enemy"):
		remove_from_group("enemy") # queue_free는 다음 프레임의 삭제하기 때문에 그룹에서 직접 제거
	
		
	var ysort = get_tree().current_scene.get_node("Ysort")
	var particle = preload("res://enemy/dead_particle.tscn").instantiate()
	particle.global_position = global_position
	particle.emitting = true
	
	if ysort:
		ysort.add_child(particle)
	else:
		push_warning("⚠️ YSort 노드를 찾을 수 없습니다. current_scene에 직접 추가합니다.")
		get_tree().current_scene.add_child(particle)
	
	#if global.random_number_generator.randf() < 0.5:
		#var gold = preload("res://PickUp/gold.tscn").instantiate()
		#gold.global_position = global_position
		#
		#if ysort:
			#ysort.add_child(gold)
		#else:
			#push_warning("⚠️ YSort 노드를 찾을 수 없습니다. current_scene에 직접 추가합니다.")
			#get_tree().current_scene.add_child(gold)
		
	queue_free()
	
