#Room.gd
extends Node2D


func _ready() -> void:
	var door_names = ["NorthDoor", "SouthDoor", "EastDoor", "WestDoor"]
	for door_name in door_names:
		if has_node(door_name):
			var area: Area2D = get_node(door_name)
			if not area.is_connected("body_entered", Callable(self, "_on_any_door_body_entered")):
				area.connect("body_entered", Callable(self, "_on_any_door_body_entered"))

func check_enemies():
	var enemies = get_tree().get_nodes_in_group("enemy")
	
	var alive_enemies = []
	
	for i in enemies:
		if is_instance_valid(i) and i.is_inside_tree() and self.is_ancestor_of(i):
			alive_enemies.append(i)
	if alive_enemies.is_empty():
		_on_all_enemies_cleared()

func _on_all_enemies_cleared():
	print("모든 적 처치 완료!")
	$NorthDoor/Door_animation.play("open")
	$SouthDoor/Door_animation.play("open")
	$EastDoor/Door_animation.play("open")
	$WestDoor/Door_animation.play("open")
	
func _on_any_door_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if global.transition_scene: return # 중복 방지
		global.transition_scene = true
		call_deferred("_change_scene_deferred")


func _change_scene_deferred():
	if global.transition_scene == true:
		var scene_path = global.get_random_dungeon_scene()
		get_tree().change_scene_to_file(scene_path)
		global.finish_change_scenes()
