extends Node

var current_scene = "StartScene"
var transition_scene = false
var last_num = 0
var clear_room_count = 0

func _ready():
	randomize()

func get_random_dungeon_scene():
	var num = get_random_num()
	current_scene = "Room" + str(num)
	return "res://Dungeon/Room/Room" + str(num) + ".tscn"

		
func get_random_num():
	var tmp_num = randi_range(1,7)
	while last_num == tmp_num:
		tmp_num = randi_range(1,7)
	if last_num != tmp_num:
		last_num = tmp_num
		return tmp_num
		
func change_scene(scene_path):
	if transition_scene == true:
		get_tree().call_deferred("change_scene_to_file", scene_path)
		finish_change_scenes()
	

func finish_change_scenes():
	if transition_scene == true:
		transition_scene = false
		
		#match current_scene:
			#"StartScene":
				#current_scene = "Room0"
