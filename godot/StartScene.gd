extends Node2D

func _process(_delta):
	change_scene()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		global.transition_scene = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("player"):
		global.transition_scene = false

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "StartScene" and Input.is_action_just_pressed("Interaction"):
			get_tree().change_scene_to_file("res://Dungeon.tscn")
			global.finish_change_scenes()
 
