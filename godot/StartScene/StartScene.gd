extends Node2D

var ready_master = false
var ready_store = false

func _process(_delta):
	if global.transition_scene:
		if Input.is_action_just_pressed("Interaction"):
			global.change_scene("res://Dungeon/Room/Room0.tscn")
	elif ready_master:
		if Input.is_action_just_pressed("Interaction") and not global.is_reading:
			var master_textbox = preload("res://StartScene/Master/Master_Text_Box.tscn").instantiate()
			master_textbox.queue_text("안녕")
			master_textbox.queue_text("강력한 기술을 배우고싶지?")
			get_tree().current_scene.add_child(master_textbox)
	elif ready_store:
		pass

# Dungeon 메서드
func _on_area_2d_body_entered(body): 
	if body.is_in_group("player"):
		global.transition_scene = true
func _on_area_2d_body_exited(body: Node2D) -> void:
	if Input.is_action_just_pressed("Interaction"): return
	if body.is_in_group("player"):
		global.transition_scene = false


# Master 메서드
func _on_talk_to_master_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		ready_master = true
func _on_talk_to_master_body_exited(body: Node2D) -> void:
	if Input.is_action_just_pressed("Interaction"): return
	if body.is_in_group("player"):
		ready_master = false
		

# Store 메서드
func _on_entered_store_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		ready_store = true
func _on_entered_store_body_exited(body: Node2D) -> void:
	if Input.is_action_just_pressed("Interaction"): return
	if body.is_in_group("player"):
		ready_store = false
