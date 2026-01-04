extends Node2D
class_name DeathComponent

	
func die():
	
	if owner.is_in_group("enemy"):
		remove_from_group("enemy") # queue_free는 다음 프레임의 삭제하기 때문에 그룹에서 직접 제거
		
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
	
	EventBus.check_room_clear.emit()
	
	owner.call_deferred("queue_free")
