extends Node

var current_scene = "StartScene"
var transition_scene = false
var last_num = 0

func _ready():
	randomize()

func get_random_dungeon_scene():
	var num = get_random_num()
	current_scene = "Room" + str(num)
	return "res://Dungeon/Room/Room" + str(num) + ".tscn"

		
func get_random_num():
	var tmp_num = randi_range(1,4)
	while last_num == tmp_num:
		tmp_num = randi_range(1,4)
	if last_num != tmp_num:
		last_num = tmp_num
		return tmp_num
	

func finish_change_scenes():
	if transition_scene == true:
		transition_scene = false
		
		#match current_scene:
			#"StartScene":
				#current_scene = "Room0"
