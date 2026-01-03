extends Node2D

@onready var outline_material := preload("res://UI/Outline.tres")
@onready var Master_sprite := $Ysort/Master/StaticBody2D/Master_Animation
@onready var Dungeon_sprite := $Dungeon/Dungeon
@onready var Store_sprite := $Ysort/Store/store

@export var player: CharacterBody2D
var master_textbox_scene = preload("res://UI/TextBox/Master/Master_Text_Box.tscn")


var ready_store = false

func _ready() -> void:
	if global.first_enter_village:
		player.get_node("AnimatedSprite2D").flip_h = true
		player.global_position = Vector2(-1077.0, 268.0)
		
		var master_textbox = master_textbox_scene.instantiate()
		master_textbox.queue_text("마지막으로 말해주는 거니까 잘 들어야해!")
		master_textbox.queue_text("우리가 이렇게 2주동안 열심히 수련을 한 이유는 하나야")
		master_textbox.queue_text("중앙통제던전에 잡혀있는 주민들을 구해내야해!")
		master_textbox.queue_text("우리 마을.. 원래는 시끌시끌하고 강한 사람도 많았는데")
		get_tree().current_scene.add_child(master_textbox)
		
		global.first_enter_village = false
	
	outline_material.set_shader_parameter("outline_size", 3)
	Master_sprite.material = null

func _process(_delta):
	if global.transition_scene:
		if Input.is_action_just_pressed("Interaction"):
			SceneManager.change_scene("res://Scene/Dungeon/Room/Room0.tscn")
	elif ready_store:
		pass

# Dungeon 메서드
func _on_area_2d_body_entered(body): 
	if body.is_in_group("player"):
		global.transition_scene = true
		Dungeon_sprite.material = outline_material
func _on_area_2d_body_exited(body: Node2D) -> void:
	if Input.is_action_just_pressed("Interaction"): return
	if body.is_in_group("player"):
		global.transition_scene = false
		Dungeon_sprite.material = null
		



# Store 메서드
func _on_entered_store_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		ready_store = true
		Store_sprite.material = outline_material
func _on_entered_store_body_exited(body: Node2D) -> void:
	if Input.is_action_just_pressed("Interaction"): return
	if body.is_in_group("player"):
		ready_store = false
		Store_sprite.material = null
		
