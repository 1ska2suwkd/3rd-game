#Room.gd
extends Node2D

func _ready() -> void:
	var door_names = ["NorthDoor", "SouthDoor", "EastDoor", "WestDoor"]
	for name in door_names:
		if has_node(name):
			var area: Area2D = get_node(name)
			if not area.is_connected("body_entered", Callable(self, "_on_any_door_body_entered")):
				area.connect("body_entered", Callable(self, "_on_any_door_body_entered").bind(area))


func _on_any_door_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if global.transition_scene: return # 중복 방지
		global.transition_scene = true
		change_scene()

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "Dungeon":
			get_tree().change_scene_to_file("res://StartScene/StartScene.tscn")
			global.finish_change_scenes()
