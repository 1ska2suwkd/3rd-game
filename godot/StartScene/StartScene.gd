extends Node2D

func _process(_delta):
	change_scene()

func change_scene():
	if global.transition_scene == true:
		if global.current_scene == "StartScene" and Input.is_action_just_pressed("Interaction"):
			get_tree().change_scene_to_file("res://Dungeon/Room/Room0.tscn")
			global.finish_change_scenes()
 
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		global.transition_scene = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if Input.is_action_just_pressed("Interaction"): return
	if body.is_in_group("player"):
		global.transition_scene = false
