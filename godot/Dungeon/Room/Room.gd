#Room.gd
extends Node2D


func _ready() -> void:
	var door_names = ["NorthDoor", "SouthDoor", "EastDoor", "WestDoor"]
	for door_name in door_names:
		if has_node(door_name):
			var area: Area2D = get_node(door_name)
			var method_name = "_on_" + door_name + "_body_entered"
			print(method_name)
			if not area.is_connected("body_entered", Callable(self, method_name)):
				area.connect("body_entered", Callable(self, method_name))
				
	$Ysort/player.position.x = global.player_position_x
	$Ysort/player.position.y = global.player_position_y
	$Ysort/player/AnimatedSprite2D.flip_h = global.player_flip_h

func check_enemies():
	var enemies = get_tree().get_nodes_in_group("enemy")
	var alive_enemies = []
	
	for i in enemies:
		if is_instance_valid(i) and i.is_inside_tree() and self.is_ancestor_of(i):
			alive_enemies.append(i)
	if alive_enemies.is_empty():
		_on_all_enemies_cleared()

func _on_all_enemies_cleared():
	global.clear_room_count += 1
	print("현재 클리어한 방의 수 : ", global.clear_room_count)
	$NorthDoor/Door_animation.play("open")
	$SouthDoor/Door_animation.play("open")
	$EastDoor/Door_animation.play("open")
	$WestDoor/Door_animation.play("open")
	$Door_locked/CollisionPolygon2D.disabled = true
	
func _on_any_door_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		change_room("NorthDoor")
			


func change_room(door_name):
	if global.transition_scene: return # 중복 방지
	global.transition_scene = true
	
	if global.clear_room_count != 3:
		global.change_scene(global.get_random_dungeon_scene())
		
		match door_name:
			"NorthDoor":
				$Ysort/player.position.x = 0
				$Ysort/player.position.y = 345
			"SouthDoor":
				$Ysort/player.position.x = 0
				$Ysort/player.position.y = -305
			"EastDoor":
				pass
			"WestDoor":
				pass
	else:
		global.change_scene("res://Dungeon/Room/Room14.tscn")
		global.clear_room_count = 0




func _on_NorthDoor_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		change_room("NorthDoor")
		global.player_position_x = 0
		global.player_position_y = 345
		global.player_flip_h = $Ysort/player/AnimatedSprite2D.flip_h
func _on_SouthDoor_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		change_room("SouthDoor")
		global.player_position_x = 0
		global.player_position_y = -305
		global.player_flip_h = $Ysort/player/AnimatedSprite2D.flip_h
func _on_EastDoor_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		change_room("EastDoor")
		global.player_position_x = -680.0
		global.player_position_y = -21
		global.player_flip_h = $Ysort/player/AnimatedSprite2D.flip_h
func _on_WestDoor_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		change_room("WestDoor")
		global.player_position_x = 680
		global.player_position_y = -21
		global.player_flip_h = $Ysort/player/AnimatedSprite2D.flip_h
