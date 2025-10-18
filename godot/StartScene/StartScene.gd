extends Node2D

func _process(_delta):
	if global.transition_scene == true:
		if Input.is_action_just_pressed("Interaction"):
			global.change_scene("res://Dungeon/Room/Room0.tscn")

 
func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		global.transition_scene = true


func _on_area_2d_body_exited(body: Node2D) -> void:
	if Input.is_action_just_pressed("Interaction"): return
	if body.is_in_group("player"):
		global.transition_scene = false
