extends Node2D

func _process(_delta):
	change_scene()


func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "Dungeon":
			get_tree().change_scene_to_file("res://StartScene/StartScene.tscn")
			global.finish_change_scenes()
			

func _on_north_door_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		global.transition_scene = true


func _on_south_door_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		global.transition_scene = true


func _on_east_door_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		global.transition_scene = true


func _on_west_door_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		global.transition_scene = true
