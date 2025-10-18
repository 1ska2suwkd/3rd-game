#Room.gd
extends Node2D


func _ready() -> void:
	var door_names = ["NorthDoor", "SouthDoor", "EastDoor", "WestDoor"]
	for door_name in door_names:
		if has_node(door_name):
			var area: Area2D = get_node(door_name)
			if not area.is_connected("body_entered", Callable(self, "_on_any_door_body_entered")):
				area.connect("body_entered", Callable(self, "_on_any_door_body_entered"))

func check_enemies():
	var enemies = get_tree().get_nodes_in_group("enemy")
	var alive_enemies = []
	
	for i in enemies:
		if is_instance_valid(i) and i.is_inside_tree() and self.is_ancestor_of(i):
			alive_enemies.append(i)
	if alive_enemies.is_empty():
		_on_all_enemies_cleared()

func _on_all_enemies_cleared():
	print("현재 클리어한 방의 수 : ", global.clear_room_count)
	$NorthDoor/Door_animation.play("open")
	$SouthDoor/Door_animation.play("open")
	$EastDoor/Door_animation.play("open")
	$WestDoor/Door_animation.play("open")
	
func _on_any_door_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		if global.transition_scene: return # 중복 방지
		global.transition_scene = true
		
		if global.clear_room_count != 5:
			global.clear_room_count += 1
			global.change_scene(global.get_random_dungeon_scene())
		else:
			global.change_scene("res://Dungeon/Room/Room14.tscn")
			global.clear_room_count = 0
			

#
#func _change_scene_deferred():
	#global.change_scene(global.get_random_dungeon_scene())
