extends Node2D
class_name DeathComponent

var is_die = false
signal _die()

func die():
	if is_die: return
	is_die = true
	
	EventBus.enemy_die.emit()
	_die.emit()
		
	var ysort = get_tree().current_scene.get_node("Ysort")
	var particle = preload("res://Particle/EnemyDeadParticle.tscn").instantiate()
	particle.global_position = global_position
	
	
	if global.random_number_generator.randf() < 0.5:
		var gold = preload("res://PickUp/gold.tscn").instantiate()
		gold.global_position = global_position
		
		if ysort:
			ysort.add_child(gold)
		else:
			push_warning("⚠️ YSort 노드를 찾을 수 없습니다. current_scene에 직접 추가합니다.")
			get_tree().current_scene.add_child(gold)
	
	
	owner.call_deferred("queue_free")
