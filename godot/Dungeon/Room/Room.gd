#Room.gd
extends Node2D


func _ready() -> void:
	var door_names = ["NorthDoor", "SouthDoor", "EastDoor", "WestDoor"]
	for door_name in door_names:
		if has_node(door_name):
			var area: Area2D = get_node(door_name)
			if not area.is_connected("body_entered", Callable(self, "_on_any_door_body_entered")):
				area.connect("body_entered", Callable(self, "_on_any_door_body_entered"))


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
