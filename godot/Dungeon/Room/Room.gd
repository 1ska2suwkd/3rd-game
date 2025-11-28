#Room.gd
extends Node2D

@onready var transtion_animation = $Dungeon_Scene_Manager/animation

func _ready() -> void:
	$Ysort/player.position.x = global.player_position_x
	$Ysort/player.position.y = global.player_position_y
	$Ysort/player/AnimatedSprite2D.flip_h = global.player_flip_h
	
	match global.player_position_x:
		-680: 
			SceneReady("east_faid_out")
		680: 
			SceneReady("west_faid_out")
	match global.player_position_y:
		345: 
			SceneReady("north_faid_out")
		-305: 
			SceneReady("south_faid_out")
	
		
	print(global.room_count,"번째 방")
	var door_names = ["NorthDoor", "SouthDoor", "EastDoor", "WestDoor"]
	for door_name in door_names:
		if has_node(door_name):
			var area: Area2D = get_node(door_name)
			var method_name = "_on_" + door_name + "_body_entered"
			if not area.is_connected("body_entered", Callable(self, method_name)):
				area.connect("body_entered", Callable(self, method_name))

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
	print("다음 방이 상자 방일 확률: ", global.probabilities[global.chest_room_stack]*100,"%")
	$NorthDoor/Door_animation.play("open")
	$SouthDoor/Door_animation.play("open")
	$EastDoor/Door_animation.play("open")
	$WestDoor/Door_animation.play("open")
	$Door_locked/CollisionPolygon2D.disabled = true
	

func change_room(direction):
	if global.transition_scene: return # 중복 방지
	global.transition_scene = true

	PlayerPositionSetUp(direction)
	
	if global.random_number_generator.randf() < global.probabilities[global.chest_room_stack]:
		global.change_scene("res://Dungeon/Room/Stage1_chest_Room.tscn")
		match global.chest_room_stack:
			0:
				global.chest_room_stack = 1
			1:
				global.chest_room_stack = 2
	elif global.clear_room_count == 5:
		global.change_scene("res://Dungeon/Room/Stage1_Boss.tscn")
		global.clear_room_count = 0
	else:
		global.room_count += 1
		#global.chest_room_stack += 1
		global.change_scene(global.get_random_dungeon_scene())
		
func SceneReady(AnimationName):
	transtion_animation.play(AnimationName)
	await transtion_animation.animation_finished
	global.is_stop = false

func SceneEnd(direction, AnimationName):
	global.is_stop = true
	transtion_animation.play(AnimationName)
	await transtion_animation.animation_finished
	change_room(direction)
	
func PlayerPositionSetUp(direction):
	match direction:
		"north":
			global.player_position_x = 0
			global.player_position_y = 345
			global.player_flip_h = $Ysort/player/AnimatedSprite2D.flip_h
			
		"south":
			global.player_position_x = 0
			global.player_position_y = -305
			global.player_flip_h = $Ysort/player/AnimatedSprite2D.flip_h
			
		"east":
			global.player_position_x = -680
			global.player_position_y = -21
			global.player_flip_h = $Ysort/player/AnimatedSprite2D.flip_h
			
		"west":
			global.player_position_x = 680
			global.player_position_y = -21
			global.player_flip_h = $Ysort/player/AnimatedSprite2D.flip_h
		
			
func _on_NorthDoor_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SceneEnd("north", "north_faid_in")
		
func _on_SouthDoor_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SceneEnd("south", "south_faid_in")
		
func _on_EastDoor_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SceneEnd("east", "east_faid_in")
		
func _on_WestDoor_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		SceneEnd("west", "west_faid_in")
