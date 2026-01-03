extends Node2D

@onready var outline_material := preload("res://UI/Outline.tres")
@onready var Master_sprite := $Ysort/Master/StaticBody2D/Master_Animation
@onready var Dungeon_sprite := $Dungeon/Dungeon
@onready var Store_sprite := $Ysort/Store/store
@onready var transition_out = $SceneManager/AnimationTree


var ready_store = false

func _ready() -> void:
	print("Village")
	#EventBus.scene_transition_in.emit()
	outline_material.set_shader_parameter("outline_size", 3)
	Master_sprite.material = null

func _process(_delta):
	if global.transition_scene:
		if Input.is_action_just_pressed("Interaction"):
			global.is_stop = true
			transition_out.play("transition_out")
			await transition_out.animation_finished
			global.change_scene("res://Scene/Dungeon/Room/Room0.tscn")
			global.is_stop = false
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
		
