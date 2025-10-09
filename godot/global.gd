extends Node

var current_scene = "StartScene"
var transition_scene = false

func _ready():
	randomize()

func get_random_dungeon_scene() -> String:
	var num = randi_range(1, 3)
	current_scene = "Room" + str(num)
	return "res://Dungeon/Room/Room" + str(num) + ".tscn"

func finish_change_scenes():
	if transition_scene == true:
		transition_scene = false
		
		#match current_scene:
			#"StartScene":
				#current_scene = "Room0"
