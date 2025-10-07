extends Node

var current_scene = "StartScene"
var transition_scene = false

func _ready():
	randomize()

func finish_change_scenes():
	if transition_scene == true:
		transition_scene = false
		
		if current_scene == "StartScene":
			current_scene = "Dungeon"
		else:
			var num = randi_range(1, 5)
			#current_scene = "Dungeon" + num
			current_scene = "StartScene"
			
