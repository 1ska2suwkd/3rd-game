extends Node

var start_game = false
var current_scene = "StartScene"
var transition_scene = false
var last_num = 0
var clear_room_count = 0
var full_screen = false
var room_numbers = [1, 2, 3, 4, 5, 6, 7, 8]
var player_position_x = 0
var player_position_y = 0
var player_flip_h = false

func _ready():
	randomize()
	
func init_game():
	clear_room_count = 0
	PlayerStat.hp = 3
	room_numbers = [1, 2, 3, 4, 5, 6, 7, 8]
	
func _process(_delta: float) -> void:
	if Input.is_action_pressed("change_screen") and full_screen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		full_screen = false
	elif Input.is_action_pressed("change_screen") and not full_screen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		full_screen = true
		

func get_random_dungeon_scene():
	var num = get_random_num()
	current_scene = "Room" + str(num)
	return "res://Dungeon/Room/Room" + str(num) + ".tscn"

		
func get_random_num():
	var Next_Room_Number = randi_range(0,len(room_numbers)-1)
	
	return room_numbers.pop_at(Next_Room_Number)
		
func change_scene(scene_path):
	if transition_scene == true:
		get_tree().call_deferred("change_scene_to_file", scene_path)
		finish_change_scenes()
	

func finish_change_scenes():
	if transition_scene == true:
		transition_scene = false
		
		match current_scene:
			"StartScene":
				current_scene = "Room0"
