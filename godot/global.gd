extends Node

var current_scene = "StartScene"
var transition_scene = false


func finish_change_scenes():
	if transition_scene == true:
		transition_scene = false
		if current_scene == "StartScene":
			current_scene = "Dungeon"
		else:
			current_scene = "StartScene"
